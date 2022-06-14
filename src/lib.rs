use std::time::Instant;

use anyhow::{anyhow, Context, Result};
use gdnative::{
    api::{AudioStreamGenerator, AudioStreamGeneratorPlayback, AudioStreamPlayer},
    prelude::*,
};
use once_cell::sync::OnceCell;
use utils::V8ObjectHelpers;

mod utils;

const MAX_SAMPLES: usize = 1024 * 1024;

const PLAYER_JS: &str = r#"
    // synth = new beepbox.Synth("9n31s1k0l00e01t27a7g01j07r1i0o432T1v0u01f10k8q0332d4aAcF8BcQ4200P6789E179T1v1ue1f0q0y10n73d4aA0F0B7Q0000Pe600E2bb619T1v1ue1f0q0y10n73d4aA0F0B7Q0000Pe600E2bb619T3v1uf9f0qwx10l511d08SW86bmhkrrzrkrrrE1b6b4x8x4wp21-IR-g1y-jRcLpjAXB5ekGhFE_97piPh-mVH-rXD2CIFOZpiZCzYk8MarnMyrz-p6CR-mlu1jq_FdvEU7lyna9KfYOtM2Czc6ngpt17honQAuwnQQ4swhQAqqYALOyc0");
    synth = new beepbox.Synth("9n42s0k0l00e03t2ca7g0fj07r1i0o4323T1v1u97f0q0z10t231d4aA9F3B6Q5428Paa74E3ba63975T7v1ue8f10p9q023d19H-SstrsrBzjAqihh6IcE0T7v1u23f10q4q011d08H_RRtrAyAAAsArrh3IaE0T1v1u01f0q0z10t233d4aA9F3B5Q5428Paa74E4ba6397512T3v1u03f0q0x10v31d4aS999arAqirrzAT__E112T4v1uf0f0q011z6666ji8k8k3jSBKSJJAArriiiiii07JCABrzrrrrrrr00YrkqHrsrrrrjr005zrAqzrjzrrqr1jRjrqGGrrzsrsA099ijrABJJJIAzrrtirqrqjqixzsrAjrqjiqaqqysttAJqjikikrizrHtBJJAzArzrIsRCITKSS099ijrAJS____Qg99habbCAYrDzh00E0b52c00000000i4w000000018O0000000052c00000000h4g000000014h00000000p22oFKDVim3cTj-lwpcT7-WCzMqWrF-D4S5dvWjhYAu9p97Ao2hRitBD9p97Cp97CmpddBg5dWfHdPk1pKfNRiq_jPaPepzdPhcPBUPIjHeFKfZpeXuq5d6mcKwLAajbF8Wic1jnBAQo1t04tlmnBllAtlg0");
"#;

static REFERENCE_TIME: OnceCell<Instant> = OnceCell::new();

fn no_op(_: &mut v8::HandleScope, _: v8::FunctionCallbackArguments, _: v8::ReturnValue) {}

fn create_script_processor(
    scope: &mut v8::HandleScope,
    args: v8::FunctionCallbackArguments,
    mut ret: v8::ReturnValue,
) {
    let audio_context = args.this();
    let processor = v8::Object::new(scope);

    let sample_rate = v8::Number::new(scope, 44100.0);
    processor.set(scope, "sampleRate", sample_rate).unwrap();

    let no_op = v8::Function::new(scope, no_op).unwrap();
    processor.set(scope, "connect", no_op).unwrap();
    processor.set(scope, "disconnect", no_op).unwrap();

    audio_context
        .set(scope, "scriptProcessor", processor)
        .unwrap();

    let channel_length = MAX_SAMPLES * std::mem::size_of::<f32>();
    let array_buffer = v8::ArrayBuffer::new(scope, channel_length * 2);
    audio_context
        .set(scope, "outputArrayBuffer", array_buffer)
        .unwrap();

    let left_channel_buffer = v8::Float32Array::new(scope, array_buffer, 0, MAX_SAMPLES).unwrap();
    let right_channel_buffer =
        v8::Float32Array::new(scope, array_buffer, channel_length, MAX_SAMPLES).unwrap();

    let output_buffer = v8::Object::new(scope);

    let get_channel_data = v8::Function::new(scope, get_channel_data).unwrap();
    output_buffer
        .set(scope, "getChannelData", get_channel_data)
        .unwrap();

    output_buffer
        .set(scope, "leftChannelBuffer", left_channel_buffer)
        .unwrap();

    output_buffer
        .set(scope, "rightChannelBuffer", right_channel_buffer)
        .unwrap();

    audio_context
        .set(scope, "outputBuffer", output_buffer)
        .unwrap();

    ret.set(processor.into());
}

fn get_channel_data(
    scope: &mut v8::HandleScope,
    args: v8::FunctionCallbackArguments,
    mut ret: v8::ReturnValue,
) {
    let this = args.this();
    let index = args.get(0).int32_value(scope).unwrap();
    match index {
        0 => ret.set(this.get(scope, "leftChannelBuffer").unwrap()),
        1 => ret.set(this.get(scope, "rightChannelBuffer").unwrap()),
        _ => {}
    }
}

fn resume_playback(
    scope: &mut v8::HandleScope,
    args: v8::FunctionCallbackArguments,
    _: v8::ReturnValue,
) {
    let audio_context = args.this();
    let bool = v8::Boolean::new(scope, true);
    audio_context.set(scope, "playing", bool).unwrap();
}

fn stop_playback(
    scope: &mut v8::HandleScope,
    args: v8::FunctionCallbackArguments,
    _: v8::ReturnValue,
) {
    let audio_context = args.this();
    let bool = v8::Boolean::new(scope, false);
    audio_context.set(scope, "playing", bool).unwrap();
}

fn performance_now(
    scope: &mut v8::HandleScope,
    _: v8::FunctionCallbackArguments,
    mut ret: v8::ReturnValue,
) {
    let time_diff = Instant::now().duration_since(unsafe { *REFERENCE_TIME.get_unchecked() });
    let value = v8::Number::new(scope, time_diff.as_secs_f64() * 1000.0);
    ret.set(value.into());
}

fn new_audio_context(
    scope: &mut v8::HandleScope,
    _: v8::FunctionCallbackArguments,
    mut ret: v8::ReturnValue,
) {
    let audio_context = v8::Object::new(scope);
    let sample_rate = v8::Number::new(scope, 44100.0);
    audio_context.set(scope, "sampleRate", sample_rate).unwrap();

    let bool = v8::Boolean::new(scope, false);
    audio_context.set(scope, "playing", bool).unwrap();

    let global = scope.get_current_context().global(scope);
    global
        .set(scope, "activeAudioContext", audio_context)
        .unwrap();

    let create_script_processor = v8::Function::new(scope, create_script_processor).unwrap();
    audio_context
        .set(scope, "createScriptProcessor", create_script_processor)
        .unwrap();

    let resume_playback = v8::Function::new(scope, resume_playback).unwrap();
    audio_context.set(scope, "resume", resume_playback).unwrap();

    let stop_playback = v8::Function::new(scope, stop_playback).unwrap();
    audio_context.set(scope, "close", stop_playback).unwrap();

    ret.set(audio_context.into());
}

fn poll_audio<'scope>(
    scope: &mut v8::HandleScope<'scope>,
    required_samples: usize,
    audio_context: v8::Local<v8::Object>,
    script_processor: v8::Local<v8::Object>,
    buffer: &mut Vector2Array,
) -> Result<()> {
    let audio_process_callback: v8::Local<v8::Function> =
        script_processor.get(scope, "onaudioprocess")?.try_into()?;

    let undefined: v8::Local<v8::Value> = v8::undefined(scope).into();

    let output_buffer: v8::Local<v8::Object> =
        audio_context.get(scope, "outputBuffer")?.try_into()?;

    let output_buffer_length = v8::Number::new(scope, required_samples as f64);
    output_buffer
        .set(scope, "length", output_buffer_length)
        .unwrap();

    let event = v8::Object::new(scope);
    event.set(scope, "outputBuffer", output_buffer)?;

    audio_process_callback.call(scope, undefined, &[event.into()]);

    let left_channel_buffer: v8::Local<v8::Float32Array> =
        output_buffer.get(scope, "leftChannelBuffer")?.try_into()?;
    let right_channel_buffer: v8::Local<v8::Float32Array> =
        output_buffer.get(scope, "rightChannelBuffer")?.try_into()?;

    // Transform JS audio output (individual channel streams) into Godot sound data (interleaved stereo stream)
    for i in 0..required_samples {
        buffer.set(
            i as i32,
            Vector2::new(
                left_channel_buffer
                    .get_index(scope, i as u32)
                    .context("index out of bounds")?
                    .number_value(scope)
                    .context("value is not a number")? as f32,
                right_channel_buffer
                    .get_index(scope, i as u32)
                    .context("index out of bounds")?
                    .number_value(scope)
                    .context("value is not a number")? as f32,
            ),
        );
    }

    Ok(())
}

struct JSInspector {
    base: v8::inspector::V8InspectorClientBase,
}

impl v8::inspector::V8InspectorClientImpl for JSInspector {
    fn base(&self) -> &v8::inspector::V8InspectorClientBase {
        &self.base
    }

    fn base_mut(&mut self) -> &mut v8::inspector::V8InspectorClientBase {
        &mut self.base
    }

    fn console_api_message(
        &mut self,
        _context_group_id: i32,
        _level: i32,
        message: &v8::inspector::StringView,
        _url: &v8::inspector::StringView,
        _line_number: u32,
        _column_number: u32,
        _stack_trace: &mut v8::inspector::V8StackTrace,
    ) {
        godot_print!("{message}");
    }
}

struct JSContext {
    isolate: v8::OwnedIsolate,
    context: v8::Global<v8::Context>,
    inspector_client: JSInspector,
}

impl JSContext {
    fn new() -> Result<JSContext> {
        let platform = v8::new_default_platform(0, false).make_shared();
        v8::V8::initialize_platform(platform);
        v8::V8::initialize();

        // Create the V8 sandbox
        let mut isolate = v8::Isolate::new(Default::default());
        let context = {
            // Create global variables and functions
            let mut scope = v8::HandleScope::new(&mut isolate);
            let global = v8::ObjectTemplate::new(&mut scope);

            global.set(
                v8::String::new(&mut scope, "AudioContext").unwrap().into(),
                v8::FunctionTemplate::new(&mut scope, new_audio_context).into(),
            );

            let performance = v8::ObjectTemplate::new(&mut scope);
            let performance_now = v8::FunctionTemplate::new(&mut scope, performance_now);
            performance.set(
                v8::String::new(&mut scope, "now").unwrap().into(),
                performance_now.into(),
            );
            global.set(
                v8::String::new(&mut scope, "performance").unwrap().into(),
                performance.into(),
            );

            global.set(
                v8::String::new(&mut scope, "oerformance").unwrap().into(),
                performance.into(),
            );

            let context = v8::Context::new_from_template(&mut scope, global);

            // Wrap the context in a global object so its lifetime is unbound
            v8::Global::new(&mut scope, context)
        };

        let mut context = JSContext {
            isolate,
            context,
            inspector_client: JSInspector {
                base: v8::inspector::V8InspectorClientBase::new::<JSInspector>(),
            },
        };

        // Bind the global object for compatibility with web browser scripts
        context.run("bootstrap", "const window = this")?;

        Ok(context)
    }

    fn run(&mut self, filename: &str, src: &str) -> Result<Variant> {
        self.do_scoped(filename, |scope| {
            // Build and run the script
            let src = v8::String::new(scope, src).context("could not build v8 string")?;
            let value = v8::Script::compile(scope, src, None)
                .context("failed to compile script")?
                .run(scope)
                .context("missing return value")?;
            Ok(utils::v8_value_to_godot_variant(scope, value))
        })
    }

    fn do_scoped<'scope, T>(
        &'scope mut self,
        filename: &str,
        mut callback: impl FnMut(&mut v8::HandleScope<'scope>) -> Result<T>,
    ) -> Result<T> {
        // "Raw" script scope
        let mut scope = v8::HandleScope::new(&mut self.isolate);
        let context = v8::Local::new(&mut scope, self.context.clone());

        // Create and bind an inspector for console logging
        let mut inspector =
            v8::inspector::V8Inspector::create(&mut scope, &mut self.inspector_client);
        inspector.context_created(
            context,
            1,
            v8::inspector::StringView::from(b"Inspector" as &[u8]),
        );

        // Script scope with globals + error handling
        let mut scope = v8::ContextScope::new(&mut scope, context);
        let mut scope = v8::TryCatch::new(&mut scope);

        // Run user callback using the scope
        let script_result = callback(&mut scope);

        if scope.has_caught() {
            let message = scope.message().context("could not extract error message")?;
            return script_result.context(anyhow!(
                "{} ({filename}:{})",
                message.get(&mut scope).to_rust_string_lossy(&mut scope),
                message.get_line_number(&mut scope).unwrap_or(0),
            ));
        }

        script_result
    }
}

#[derive(NativeClass)]
#[inherit(AudioStreamPlayer)]
pub struct Synthesizer {
    playback: Ref<AudioStreamGeneratorPlayback>,
    buffer: Vector2Array,
    js: JSContext,
}

#[methods]
impl Synthesizer {
    fn new(owner: &AudioStreamPlayer) -> Self {
        // Set up Godot audio player
        let generator = AudioStreamGenerator::new();
        generator.set_mix_rate(44100.0);
        generator.set_buffer_length(0.1);
        owner.set_stream(generator.into_shared());

        let playback = owner
            .get_stream_playback()
            .expect("stream playback is missing")
            .cast()
            .expect("stream playback is not an instance of AudioStreamGeneratorPlayback");

        let mut buffer = Vector2Array::new();
        buffer.resize(MAX_SAMPLES as i32);

        Synthesizer {
            playback,
            buffer,
            js: JSContext::new().expect("failed to create js context"),
        }
    }

    #[export]
    fn _ready(&mut self, owner: &AudioStreamPlayer) {
        self.js
            .run(
                "beepbox_synth.js",
                include_str!("../dependencies/beepbox/website/beepbox_synth.js"),
            )
            .unwrap();

        self.js.run("player.js", PLAYER_JS).unwrap();
        owner.play(0.0);
    }

    #[export]
    fn _process(&mut self, _: &AudioStreamPlayer, _: f32) {
        self.js
            .do_scoped("_process", |scope| {
                let global = scope.get_current_context().global(scope);
                let audio_context = global.get(scope, "activeAudioContext").unwrap();
                if audio_context.is_undefined() {
                    return Ok(());
                }
                let audio_context: v8::Local<v8::Object> = audio_context.try_into().unwrap();
                let script_processor: v8::Local<v8::Object> =
                    audio_context.get(scope, "scriptProcessor")?.try_into()?;

                // Ask godot how much data needs to be filled
                let playback = unsafe { self.playback.assume_safe() };
                let required_samples = playback.get_frames_available() as usize;

                // Pull data from Beepbox
                poll_audio(
                    scope,
                    required_samples,
                    audio_context,
                    script_processor,
                    &mut self.buffer,
                )?;

                // Fill Godot's sound buffer
                for i in 0..required_samples {
                    playback.push_frame(self.buffer.get(i as i32));
                }

                Ok(())
            })
            .unwrap();
    }

    #[export]
    fn resume(&mut self, _: &AudioStreamPlayer) {
        self.js.run("resume", "synth.play()").unwrap();
    }

    #[export]
    fn pause(&mut self, _: &AudioStreamPlayer) {
        self.js.run("pause", "synth.pause()").unwrap();
    }

    #[export]
    fn eval(&mut self, _: &AudioStreamPlayer, code: String) -> Variant {
        self.js.run("eval", &code).unwrap()
    }
}

fn init(handle: InitHandle) {
    std::env::set_var("RUST_LIB_BACKTRACE", "1");
    std::panic::set_hook(Box::new(|info| {
        // let backtrace = Backtrace::new();
        // godot_error!("{info}\n{backtrace:?}");
        godot_print!("{info}");
    }));
    REFERENCE_TIME.set(Instant::now()).unwrap();
    handle.add_class::<Synthesizer>();
}

godot_init!(init);