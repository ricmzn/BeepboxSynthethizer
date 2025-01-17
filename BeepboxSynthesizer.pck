GDPC                                                                               <   res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex�      �      &�y���ڞu;>��.p    res://beepbox_synthesizer.tres         �       ��GJI�
Nn~9��    res://default_bus_layout.tres   �      T       l6"Ė�l��!��^E�   res://default_env.tres         �       um�`�N��<*ỳ�8   res://icon.png  0&     �      G1?��z�c��vN��   res://icon.png.import   �
      �      ��fe��6�B��^ U�   res://main.tscn @      �      C&ݼ��������   res://project.binary 3     >      ��Ap-��D�sm� v   res://song1.json       �K      ��(�f�@��6V�   res://song2.json�j      �B      �'��=�
 r�7��   res://song3.json��      �x      �1VF�������=���{            [gd_resource type="GDNativeLibrary" format=2]

[resource]
entry/Windows.64 = "res://target/debug/beepbox_synthesizer.dll"
dependency/Windows.64 = [  ]
         [gd_resource type="AudioBusLayout" format=2]

[resource]
bus/0/volume_db = 0.267241
            [gd_resource type="Environment" load_steps=2 format=2]

[sub_resource type="ProceduralSky" id=1]

[resource]
background_mode = 2
background_sky = SubResource( 1 )
             GDST@   @            �  WEBPRIFF�  WEBPVP8L�  /?����m��������_"�0@��^�"�v��s�}� �W��<f��Yn#I������wO���M`ҋ���N��m:�
��{-�4b7DԧQ��A �B�P��*B��v��
Q�-����^R�D���!(����T�B�*�*���%E["��M�\͆B�@�U$R�l)���{�B���@%P����g*Ųs�TP��a��dD
�6�9�UR�s����1ʲ�X�!�Ha�ߛ�$��N����i�a΁}c Rm��1��Q�c���fdB�5������J˚>>���s1��}����>����Y��?�TEDױ���s���\�T���4D����]ׯ�(aD��Ѓ!�a'\�G(��$+c$�|'�>����/B��c�v��_oH���9(l�fH������8��vV�m�^�|�m۶m�����q���k2�='���:_>��������á����-wӷU�x�˹�fa���������ӭ�M���SƷ7������|��v��v���m�d���ŝ,��L��Y��ݛ�X�\֣� ���{�#3���
�6������t`�
��t�4O��ǎ%����u[B�����O̲H��o߾��$���f���� �H��\��� �kߡ}�~$�f���N\�[�=�'��Nr:a���si����(9Lΰ���=����q-��W��LL%ɩ	��V����R)�=jM����d`�ԙHT�c���'ʦI��DD�R��C׶�&����|t Sw�|WV&�^��bt5WW,v�Ş�qf���+���Jf�t�s�-BG�t�"&�Ɗ����׵�Ջ�KL�2)gD� ���� NEƋ�R;k?.{L�$�y���{'��`��ٟ��i��{z�5��i������c���Z^�
h�+U�mC��b��J��uE�c�����h��}{�����i�'�9r�����ߨ򅿿��hR�Mt�Rb���C�DI��iZ�6i"�DN�3���J�zڷ#oL����Q �W��D@!'��;�� D*�K�J�%"�0�����pZԉO�A��b%�l�#��$A�W�A�*^i�$�%a��rvU5A�ɺ�'a<��&�DQ��r6ƈZC_B)�N�N(�����(z��y�&H�ض^��1Z4*,RQjԫ׶c����yq��4���?�R�����0�6f2Il9j��ZK�4���է�0؍è�ӈ�Uq�3�=[vQ�d$���±eϘA�����R�^��=%:�G�v��)�ǖ/��RcO���z .�ߺ��S&Q����o,X�`�����|��s�<3Z��lns'���vw���Y��>V����G�nuk:��5�U.�v��|����W���Z���4�@U3U�������|�r�?;�
         [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon.png"
dest_files=[ "res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
              [gd_scene load_steps=7 format=2]

[ext_resource path="res://beepbox_synthesizer.tres" type="GDNativeLibrary" id=1]

[sub_resource type="GDScript" id=4]
script/source = "extends Container

onready var buttonTemplate := $ToggleChannel
onready var playButton := $PlayPause
onready var player := $\"/root/Main/AudioStreamPlayer\"
var buttons := []

func _ready():
	buttonTemplate.get_parent().remove_child(buttonTemplate)
	update()

func update():
	for button in buttons:
		button.queue_free()

	buttons = []

	if player.eval(\"typeof(synth) !== 'undefined' && synth.song != null\"):
		playButton.disabled = false
		var channels = player.eval(\"synth.song.channels.length\")
		for i in range(channels):
			var button = buttonTemplate.duplicate()
			var instrumentName = player.eval(
				\"beepbox.Config.instrumentTypeNames[synth.song.channels[%d].instruments[0].type]\" % i)
			button.active = player.eval(\"synth.song.channels[%d].muted === false\" % i)
			button.description = instrumentName
			button.index = i
			button.update_text()
			buttons.append(button)
			add_child(button)
	else:
		playButton.disabled = true
"

[sub_resource type="GDScript" id=5]
script/source = "extends Button

onready var fileDialog = $\"/root/Main/FileDialog\"
onready var player = $\"/root/Main/AudioStreamPlayer\"
onready var container = $\"/root/Main/CenterContainer/VBoxContainer\"

func _on_Import_pressed():
	fileDialog.popup()

func _on_FileDialog_file_selected(path):
	player.import(path)
	container.update()
"

[sub_resource type="GDScript" id=2]
script/source = "extends Button

onready var stream = $\"/root/Main/AudioStreamPlayer\"
var playing = false

func _on_Button_pressed():
	if playing:
		stream.pause()
		playing = false
		text = \"Play\"
	else:
		stream.resume()
		playing = true
		text = \"Pause\"
"

[sub_resource type="GDScript" id=3]
script/source = "extends Button

onready var stream = $\"/root/Main/AudioStreamPlayer\"
onready var initial_text = text
var description = \"\"
var active = true
var index = 0

func update_text():
	text = \"Toggle Channel %d\" % index
	hint_tooltip = description
	if not active:
		text = \"%s [M]\" % text

func _ready():
	update_text()

func _on_Button_pressed():
	if active:
		stream.eval(\"synth.song.channels[%d].muted = true\" % index)
		active = false
		update_text()
	else:
		stream.eval(\"synth.song.channels[%d].muted = false\" % index)
		active = true
		update_text()
"

[sub_resource type="NativeScript" id=1]
resource_name = "Synthesizer"
class_name = "Synthesizer"
library = ExtResource( 1 )

[node name="Main" type="Control"]
anchor_right = 1.0
anchor_bottom = 1.0

[node name="CenterContainer" type="CenterContainer" parent="."]
anchor_right = 1.0
anchor_bottom = 1.0

[node name="VBoxContainer" type="VBoxContainer" parent="CenterContainer"]
margin_left = 362.0
margin_top = 250.0
margin_right = 662.0
margin_bottom = 350.0
rect_min_size = Vector2( 300, 0 )
custom_constants/separation = 20
script = SubResource( 4 )

[node name="Import" type="Button" parent="CenterContainer/VBoxContainer"]
margin_right = 300.0
margin_bottom = 20.0
text = "Import JSON..."
script = SubResource( 5 )

[node name="PlayPause" type="Button" parent="CenterContainer/VBoxContainer"]
margin_top = 40.0
margin_right = 300.0
margin_bottom = 60.0
text = "Play"
script = SubResource( 2 )

[node name="ToggleChannel" type="Button" parent="CenterContainer/VBoxContainer"]
margin_top = 80.0
margin_right = 300.0
margin_bottom = 100.0
text = "Toggle Channel X"
script = SubResource( 3 )

[node name="FileDialog" type="FileDialog" parent="."]
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
margin_left = -400.0
margin_top = -250.0
margin_right = 400.0
margin_bottom = 250.0
rect_min_size = Vector2( 800, 500 )
window_title = "Open a File"
mode = 0
filters = PoolStringArray( "*.json" )

[node name="AudioStreamPlayer" type="AudioStreamPlayer" parent="."]
volume_db = -25.0
script = SubResource( 1 )

[connection signal="pressed" from="CenterContainer/VBoxContainer/Import" to="CenterContainer/VBoxContainer/Import" method="_on_Import_pressed"]
[connection signal="pressed" from="CenterContainer/VBoxContainer/PlayPause" to="CenterContainer/VBoxContainer/PlayPause" method="_on_Button_pressed"]
[connection signal="pressed" from="CenterContainer/VBoxContainer/ToggleChannel" to="CenterContainer/VBoxContainer/ToggleChannel" method="_on_Button_pressed"]
[connection signal="file_selected" from="FileDialog" to="CenterContainer/VBoxContainer/Import" method="_on_FileDialog_file_selected"]
        {
	"format": "BeepBox",
	"version": 9,
	"scale": "easy :)",
	"key": "C",
	"introBars": 0,
	"loopBars": 7,
	"beatsPerBar": 8,
	"ticksPerBeat": 4,
	"beatsPerMinute": 150,
	"layeredInstruments": false,
	"patternInstruments": false,
	"channels": [
		{
			"type": "pitch",
			"instruments": [
				{
					"type": "FM",
					"volume": 80,
					"eqFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 5656.85,
							"linearGain": 2.8284
						}
					],
					"preset": 839,
					"effects": [
						"chorus",
						"reverb"
					],
					"chorus": 100,
					"reverb": 33,
					"fadeInSeconds": 0.0413,
					"fadeOutTicks": 6,
					"algorithm": "1 2 3 4",
					"feedbackType": "1⟲ 2⟲ 3⟲ 4⟲",
					"feedbackAmplitude": 7,
					"operators": [
						{
							"frequency": "1×",
							"amplitude": 15
						},
						{
							"frequency": "3×",
							"amplitude": 4
						},
						{
							"frequency": "6×",
							"amplitude": 2
						},
						{
							"frequency": "11×",
							"amplitude": 2
						}
					],
					"envelopes": [
						{
							"target": "feedbackAmplitude",
							"envelope": "twang 1"
						}
					]
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								57
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								55
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								52
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								48
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								45
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								50
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								52
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								48
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								52
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								50
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								52
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								50
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								52
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								50
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								52
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								50
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				1,
				1,
				2,
				3,
				3,
				3,
				4
			],
			"octaveScrollBar": 3
		},
		{
			"type": "pitch",
			"instruments": [
				{
					"type": "FM",
					"volume": 80,
					"eqFilter": [],
					"preset": 653,
					"effects": [
						"note filter",
						"chorus",
						"reverb"
					],
					"noteFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 4000,
							"linearGain": 0.5
						}
					],
					"chorus": 100,
					"reverb": 33,
					"fadeInSeconds": 0,
					"fadeOutTicks": -3,
					"algorithm": "1←(2 3←4)",
					"feedbackType": "1⟲",
					"feedbackAmplitude": 2,
					"operators": [
						{
							"frequency": "~2×",
							"amplitude": 11
						},
						{
							"frequency": "~1×",
							"amplitude": 5
						},
						{
							"frequency": "11×",
							"amplitude": 2
						},
						{
							"frequency": "16×",
							"amplitude": 5
						}
					],
					"envelopes": [
						{
							"target": "noteFilterAllFreqs",
							"envelope": "punch"
						},
						{
							"target": "operatorAmplitude",
							"envelope": "swell 3",
							"index": 3
						}
					]
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								43
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								40
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								40
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								33
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								36
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								40
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								33
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								40
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 14,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 14,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								33
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								40
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 22,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 22,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								31
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								40
							],
							"points": [
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				0,
				1,
				2,
				3,
				3,
				3,
				2
			],
			"octaveScrollBar": 2
		},
		{
			"type": "pitch",
			"instruments": [
				{
					"type": "FM",
					"volume": 80,
					"eqFilter": [],
					"preset": 388,
					"effects": [
						"chord type",
						"note filter",
						"reverb"
					],
					"chord": "strum",
					"noteFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 11313.71,
							"linearGain": 0.1768
						}
					],
					"reverb": 33,
					"fadeInSeconds": 0,
					"fadeOutTicks": 48,
					"algorithm": "1←(2 3←4)",
					"feedbackType": "3⟲",
					"feedbackAmplitude": 5,
					"operators": [
						{
							"frequency": "2×",
							"amplitude": 14
						},
						{
							"frequency": "1×",
							"amplitude": 6
						},
						{
							"frequency": "9×",
							"amplitude": 4
						},
						{
							"frequency": "1×",
							"amplitude": 11
						}
					],
					"envelopes": [
						{
							"target": "noteFilterAllFreqs",
							"envelope": "twang 1"
						},
						{
							"target": "operatorAmplitude",
							"envelope": "twang 2",
							"index": 2
						},
						{
							"target": "feedbackAmplitude",
							"envelope": "twang 1"
						}
					]
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								19
							],
							"points": [
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								19
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								19
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								19
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								19
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								16
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								19
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								19
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								16
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								16
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								16
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				2,
				2,
				2,
				3,
				1,
				1,
				1
			],
			"octaveScrollBar": 1
		},
		{
			"type": "drum",
			"instruments": [
				{
					"type": "noise",
					"volume": 80,
					"eqFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 16000,
							"linearGain": 0.3536
						}
					],
					"preset": 69,
					"effects": [
						"chord type"
					],
					"chord": "arpeggio",
					"fadeInSeconds": 0,
					"fadeOutTicks": -3,
					"wave": "retro",
					"envelopes": []
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								1
							],
							"points": [
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 6,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 10,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								1
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 14,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								1
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 22,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 26,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								1
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 0
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				0,
				0,
				0,
				0,
				0,
				1,
				1
			]
		}
	]
}         {
	"format": "BeepBox",
	"version": 9,
	"scale": "easy :(",
	"key": "C",
	"introBars": 0,
	"loopBars": 2,
	"beatsPerBar": 8,
	"ticksPerBeat": 4,
	"beatsPerMinute": 135,
	"layeredInstruments": false,
	"patternInstruments": false,
	"channels": [
		{
			"type": "pitch",
			"instruments": [
				{
					"type": "FM",
					"volume": 100,
					"eqFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 2000,
							"linearGain": 1.4142
						}
					],
					"effects": [
						"chorus",
						"reverb"
					],
					"chorus": 100,
					"reverb": 67,
					"fadeInSeconds": 0.0575,
					"fadeOutTicks": 96,
					"algorithm": "1 2 3 4",
					"feedbackType": "1⟲ 2⟲ 3⟲ 4⟲",
					"feedbackAmplitude": 12,
					"operators": [
						{
							"frequency": "3×",
							"amplitude": 6
						},
						{
							"frequency": "2×",
							"amplitude": 7
						},
						{
							"frequency": "1×",
							"amplitude": 8
						},
						{
							"frequency": "1×",
							"amplitude": 9
						}
					],
					"envelopes": [
						{
							"target": "feedbackAmplitude",
							"envelope": "swell 1"
						}
					]
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								58,
								63
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								53,
								60
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								58
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 13,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								60,
								55
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								58
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 21,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								60,
								51
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								53
							],
							"points": [
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								55
							],
							"points": [
								{
									"tick": 2,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								53
							],
							"points": [
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 6,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								58,
								51
							],
							"points": [
								{
									"tick": 6,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								58,
								55,
								48
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								53
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 13,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								58
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 17,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								55,
								60,
								41
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								53,
								46
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				1,
				2
			],
			"octaveScrollBar": 3
		},
		{
			"type": "pitch",
			"instruments": [
				{
					"type": "FM",
					"volume": 80,
					"eqFilter": [],
					"preset": 897,
					"effects": [
						"note filter",
						"chorus"
					],
					"noteFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 3363.59,
							"linearGain": 1
						}
					],
					"chorus": 100,
					"fadeInSeconds": 0.0575,
					"fadeOutTicks": 96,
					"algorithm": "1←(2 3 4)",
					"feedbackType": "1⟲",
					"feedbackAmplitude": 7,
					"operators": [
						{
							"frequency": "1×",
							"amplitude": 14
						},
						{
							"frequency": "1×",
							"amplitude": 6
						},
						{
							"frequency": "1×",
							"amplitude": 0
						},
						{
							"frequency": "1×",
							"amplitude": 0
						}
					],
					"envelopes": [
						{
							"target": "noteFilterAllFreqs",
							"envelope": "swell 3"
						},
						{
							"target": "operatorAmplitude",
							"envelope": "swell 1",
							"index": 1
						}
					]
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								39
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								36
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								34
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								36
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								39
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								31
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				1,
				2
			],
			"octaveScrollBar": 2
		},
		{
			"type": "pitch",
			"instruments": [
				{
					"type": "FM",
					"volume": 80,
					"eqFilter": [],
					"preset": 897,
					"effects": [
						"note filter",
						"chorus"
					],
					"noteFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 3363.59,
							"linearGain": 1
						}
					],
					"chorus": 100,
					"fadeInSeconds": 0.0575,
					"fadeOutTicks": 96,
					"algorithm": "1←(2 3 4)",
					"feedbackType": "1⟲",
					"feedbackAmplitude": 7,
					"operators": [
						{
							"frequency": "1×",
							"amplitude": 14
						},
						{
							"frequency": "1×",
							"amplitude": 6
						},
						{
							"frequency": "1×",
							"amplitude": 0
						},
						{
							"frequency": "1×",
							"amplitude": 0
						}
					],
					"envelopes": [
						{
							"target": "noteFilterAllFreqs",
							"envelope": "swell 3"
						},
						{
							"target": "operatorAmplitude",
							"envelope": "swell 1",
							"index": 1
						}
					]
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								19
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								17
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								22
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								19
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								15
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								22
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								24
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								22
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								17
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				2,
				1
			],
			"octaveScrollBar": 1
		},
		{
			"type": "drum",
			"instruments": [
				{
					"type": "spectrum",
					"volume": 80,
					"eqFilter": [],
					"preset": 969,
					"effects": [
						"chord type",
						"note filter",
						"reverb"
					],
					"chord": "strum",
					"noteFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 2378.41,
							"linearGain": 0.5
						}
					],
					"reverb": 33,
					"fadeInSeconds": 0,
					"fadeOutTicks": 48,
					"spectrum": [
						100,
						29,
						14,
						0,
						0,
						86,
						14,
						43,
						29,
						86,
						29,
						14,
						29,
						57,
						43,
						43,
						43,
						43,
						57,
						43,
						43,
						43,
						29,
						57,
						43,
						43,
						43,
						43,
						43,
						43
					],
					"envelopes": [
						{
							"target": "noteFilterAllFreqs",
							"envelope": "twang 1"
						}
					]
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								3
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 2,
									"pitchBend": 0,
									"volume": 0
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								3
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 10,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								3
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 18,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								3
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 22,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 22,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								3
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 0
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								3
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 2,
									"pitchBend": 0,
									"volume": 0
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 6,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 10,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								1
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 14,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 18,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								1
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								3
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 0
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				1,
				2
			]
		}
	]
}    {
	"format": "BeepBox",
	"version": 9,
	"scale": "easy :)",
	"key": "C",
	"introBars": 0,
	"loopBars": 4,
	"beatsPerBar": 8,
	"ticksPerBeat": 4,
	"beatsPerMinute": 140,
	"layeredInstruments": false,
	"patternInstruments": false,
	"channels": [
		{
			"type": "pitch",
			"instruments": [
				{
					"type": "FM",
					"volume": 80,
					"eqFilter": [],
					"preset": 583,
					"effects": [
						"note filter",
						"chorus",
						"reverb"
					],
					"noteFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 9513.66,
							"linearGain": 0.1768
						}
					],
					"chorus": 100,
					"reverb": 33,
					"fadeInSeconds": 0.0575,
					"fadeOutTicks": 96,
					"algorithm": "(1 2)←(3 4)",
					"feedbackType": "4⟲",
					"feedbackAmplitude": 6,
					"operators": [
						{
							"frequency": "4×",
							"amplitude": 10
						},
						{
							"frequency": "3×",
							"amplitude": 10
						},
						{
							"frequency": "2×",
							"amplitude": 7
						},
						{
							"frequency": "7×",
							"amplitude": 4
						}
					],
					"envelopes": [
						{
							"target": "noteFilterAllFreqs",
							"envelope": "swell 2"
						},
						{
							"target": "operatorAmplitude",
							"envelope": "swell 1",
							"index": 3
						},
						{
							"target": "feedbackAmplitude",
							"envelope": "flare 3"
						}
					]
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								55
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								52
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								57
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								60,
								52
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								62,
								52
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								48,
								55
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								50
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								52
							],
							"points": [
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								55
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								52,
								48
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				1,
				4,
				2,
				3
			],
			"octaveScrollBar": 3
		},
		{
			"type": "pitch",
			"instruments": [
				{
					"type": "Picked String",
					"volume": 80,
					"eqFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 4756.83,
							"linearGain": 2
						}
					],
					"preset": 904,
					"effects": [
						"chorus"
					],
					"chorus": 100,
					"fadeInSeconds": 0.0125,
					"fadeOutTicks": 72,
					"harmonics": [
						100,
						86,
						86,
						86,
						43,
						57,
						43,
						71,
						43,
						43,
						43,
						57,
						43,
						43,
						57,
						71,
						57,
						43,
						29,
						43,
						57,
						57,
						43,
						29,
						29,
						29,
						29,
						14
					],
					"unison": "octave",
					"stringSustain": 86,
					"envelopes": []
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								31
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								36
							],
							"points": [
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 6,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								33
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								36
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 14,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								36
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 22,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								33
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 26,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								28
							],
							"points": [
								{
									"tick": 26,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								31
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								36
							],
							"points": [
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								31
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								36
							],
							"points": [
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 6,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								36
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 14,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								33
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								28
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								33
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 26,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								28
							],
							"points": [
								{
									"tick": 26,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								31
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								33
							],
							"points": [
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				1,
				2,
				1,
				2
			],
			"octaveScrollBar": 2
		},
		{
			"type": "pitch",
			"instruments": [
				{
					"type": "Picked String",
					"volume": 80,
					"eqFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 5656.85,
							"linearGain": 0.3536
						}
					],
					"preset": 131,
					"effects": [
						"reverb"
					],
					"reverb": 33,
					"fadeInSeconds": 0,
					"fadeOutTicks": 48,
					"harmonics": [
						100,
						100,
						86,
						71,
						86,
						71,
						43,
						71,
						43,
						43,
						57,
						57,
						57,
						29,
						57,
						57,
						57,
						57,
						57,
						57,
						43,
						57,
						57,
						57,
						43,
						43,
						43,
						43
					],
					"unison": "honky tonk",
					"stringSustain": 71,
					"envelopes": []
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								16
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								19
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								24
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				1,
				2,
				3,
				2
			],
			"octaveScrollBar": 1
		},
		{
			"type": "pitch",
			"instruments": [
				{
					"type": "FM",
					"volume": 80,
					"eqFilter": [],
					"effects": [
						"note filter",
						"chorus",
						"reverb"
					],
					"noteFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 9513.66,
							"linearGain": 0.1768
						}
					],
					"chorus": 100,
					"reverb": 100,
					"fadeInSeconds": 0.0575,
					"fadeOutTicks": 96,
					"algorithm": "(1 2)←(3 4)",
					"feedbackType": "4⟲",
					"feedbackAmplitude": 5,
					"operators": [
						{
							"frequency": "4×",
							"amplitude": 10
						},
						{
							"frequency": "3×",
							"amplitude": 10
						},
						{
							"frequency": "2×",
							"amplitude": 7
						},
						{
							"frequency": "7×",
							"amplitude": 4
						}
					],
					"envelopes": [
						{
							"target": "noteFilterAllFreqs",
							"envelope": "swell 2"
						},
						{
							"target": "operatorAmplitude",
							"envelope": "swell 1",
							"index": 3
						},
						{
							"target": "feedbackAmplitude",
							"envelope": "flare 3"
						},
						{
							"target": "noteVolume",
							"envelope": "punch"
						}
					]
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								45,
								38
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								40
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								43,
								38
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								36
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								45,
								40
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								48
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								43,
								50
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								45
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								48,
								40
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								33,
								40
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								43
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": [
						{
							"pitches": [
								45
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								43
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								48,
								40
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								}
							]
						},
						{
							"pitches": [
								38
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 100
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				1,
				4,
				2,
				3
			],
			"octaveScrollBar": 2
		},
		{
			"type": "drum",
			"instruments": [
				{
					"type": "spectrum",
					"volume": 80,
					"eqFilter": [],
					"effects": [
						"note filter",
						"reverb"
					],
					"noteFilter": [
						{
							"type": "low-pass",
							"cutoffHz": 13454.34,
							"linearGain": 0.25
						}
					],
					"reverb": 33,
					"fadeInSeconds": 0.0575,
					"fadeOutTicks": 96,
					"spectrum": [
						14,
						14,
						14,
						14,
						14,
						14,
						14,
						29,
						43,
						43,
						57,
						57,
						43,
						29,
						29,
						29,
						43,
						43,
						43,
						43,
						57,
						43,
						57,
						57,
						86,
						100,
						100,
						100,
						100,
						100
					],
					"envelopes": [
						{
							"target": "noteVolume",
							"envelope": "punch"
						}
					]
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 2,
									"pitchBend": 0,
									"volume": 0
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 10,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								1
							],
							"points": [
								{
									"tick": 14,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 18,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								1
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 26,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 0
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				1,
				1,
				1,
				1
			]
		},
		{
			"type": "drum",
			"instruments": [
				{
					"type": "drumset",
					"volume": 80,
					"eqFilter": [],
					"preset": 960,
					"effects": [
						"reverb"
					],
					"reverb": 33,
					"drums": [
						{
							"filterEnvelope": "twang 1",
							"spectrum": [
								57,
								71,
								71,
								86,
								86,
								86,
								71,
								71,
								71,
								71,
								57,
								57,
								57,
								57,
								43,
								43,
								43,
								43,
								29,
								29,
								29,
								29,
								29,
								29,
								29,
								29,
								29,
								29,
								29,
								29
							]
						},
						{
							"filterEnvelope": "twang 1",
							"spectrum": [
								0,
								0,
								0,
								100,
								71,
								71,
								57,
								86,
								57,
								57,
								57,
								71,
								43,
								43,
								57,
								43,
								43,
								43,
								43,
								43,
								43,
								43,
								43,
								43,
								43,
								43,
								43,
								43,
								43,
								43
							]
						},
						{
							"filterEnvelope": "twang 1",
							"spectrum": [
								0,
								0,
								0,
								0,
								100,
								57,
								43,
								43,
								29,
								57,
								43,
								29,
								71,
								43,
								43,
								43,
								43,
								57,
								43,
								43,
								43,
								43,
								43,
								43,
								43,
								43,
								29,
								43,
								43,
								43
							]
						},
						{
							"filterEnvelope": "twang 1",
							"spectrum": [
								0,
								0,
								0,
								0,
								0,
								71,
								57,
								43,
								43,
								43,
								57,
								57,
								43,
								29,
								57,
								43,
								43,
								43,
								29,
								43,
								57,
								43,
								43,
								43,
								43,
								43,
								43,
								29,
								43,
								43
							]
						},
						{
							"filterEnvelope": "decay 2",
							"spectrum": [
								0,
								14,
								29,
								43,
								86,
								71,
								29,
								43,
								43,
								43,
								43,
								29,
								71,
								29,
								71,
								29,
								43,
								43,
								43,
								43,
								57,
								43,
								43,
								57,
								43,
								43,
								43,
								57,
								57,
								57
							]
						},
						{
							"filterEnvelope": "decay 1",
							"spectrum": [
								0,
								0,
								14,
								14,
								14,
								14,
								29,
								29,
								29,
								43,
								43,
								43,
								57,
								57,
								57,
								71,
								71,
								71,
								71,
								71,
								71,
								71,
								71,
								57,
								57,
								57,
								57,
								43,
								43,
								43
							]
						},
						{
							"filterEnvelope": "twang 3",
							"spectrum": [
								43,
								43,
								43,
								71,
								29,
								29,
								43,
								43,
								43,
								29,
								43,
								43,
								43,
								29,
								29,
								43,
								43,
								29,
								29,
								29,
								57,
								14,
								57,
								43,
								43,
								57,
								43,
								43,
								57,
								57
							]
						},
						{
							"filterEnvelope": "decay 3",
							"spectrum": [
								29,
								43,
								43,
								43,
								43,
								29,
								29,
								43,
								29,
								29,
								43,
								29,
								14,
								29,
								43,
								29,
								43,
								29,
								57,
								29,
								43,
								57,
								43,
								71,
								43,
								71,
								57,
								57,
								71,
								71
							]
						},
						{
							"filterEnvelope": "twang 3",
							"spectrum": [
								43,
								29,
								29,
								43,
								29,
								29,
								29,
								57,
								29,
								29,
								29,
								57,
								43,
								43,
								29,
								29,
								57,
								43,
								43,
								43,
								71,
								43,
								43,
								71,
								57,
								71,
								71,
								71,
								71,
								71
							]
						},
						{
							"filterEnvelope": "decay 3",
							"spectrum": [
								57,
								57,
								57,
								43,
								57,
								57,
								43,
								43,
								57,
								43,
								43,
								43,
								71,
								57,
								43,
								57,
								86,
								71,
								57,
								86,
								71,
								57,
								86,
								100,
								71,
								86,
								86,
								86,
								86,
								86
							]
						},
						{
							"filterEnvelope": "flare 1",
							"spectrum": [
								0,
								0,
								14,
								14,
								14,
								14,
								29,
								29,
								29,
								43,
								43,
								43,
								57,
								57,
								71,
								71,
								86,
								86,
								100,
								100,
								100,
								100,
								100,
								100,
								100,
								100,
								86,
								57,
								29,
								0
							]
						},
						{
							"filterEnvelope": "decay 2",
							"spectrum": [
								14,
								14,
								14,
								14,
								29,
								14,
								14,
								29,
								14,
								43,
								14,
								43,
								57,
								86,
								57,
								57,
								100,
								57,
								43,
								43,
								57,
								100,
								57,
								43,
								29,
								14,
								0,
								0,
								0,
								0
							]
						}
					],
					"envelopes": []
				}
			],
			"patterns": [
				{
					"notes": [
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 0,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 0
								}
							],
							"continuesLastPattern": false
						},
						{
							"pitches": [
								5
							],
							"points": [
								{
									"tick": 4,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 6,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								8
							],
							"points": [
								{
									"tick": 6,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								9
							],
							"points": [
								{
									"tick": 8,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 10,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								5
							],
							"points": [
								{
									"tick": 12,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 14,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								8
							],
							"points": [
								{
									"tick": 14,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								2
							],
							"points": [
								{
									"tick": 16,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								5
							],
							"points": [
								{
									"tick": 20,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 22,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								8
							],
							"points": [
								{
									"tick": 22,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								9
							],
							"points": [
								{
									"tick": 24,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 26,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								5
							],
							"points": [
								{
									"tick": 28,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 0
								}
							]
						},
						{
							"pitches": [
								8
							],
							"points": [
								{
									"tick": 30,
									"pitchBend": 0,
									"volume": 100
								},
								{
									"tick": 32,
									"pitchBend": 0,
									"volume": 0
								}
							]
						}
					]
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				},
				{
					"notes": []
				}
			],
			"sequence": [
				1,
				1,
				1,
				1
			]
		}
	]
}           �PNG

   IHDR   @   @   �iq�   sRGB ���  �IDATx��ytTU��?�ի%���@ȞY1JZ �iA�i�[P��e��c;�.`Ow+4�>�(}z�EF�Dm�:�h��IHHB�BR!{%�Zߛ?��	U�T�
���:��]~�������-�	Ì�{q*�h$e-
�)��'�d�b(��.�B�6��J�ĩ=;���Cv�j��E~Z��+��CQ�AA�����;�.�	�^P	���ARkUjQ�b�,#;�8�6��P~,� �0�h%*QzE� �"��T��
�=1p:lX�Pd�Y���(:g����kZx ��A���띊3G�Di� !�6����A҆ @�$JkD�$��/�nYE��< Q���<]V�5O!���>2<��f��8�I��8��f:a�|+�/�l9�DEp�-�t]9)C�o��M~�k��tw�r������w��|r�Ξ�	�S�)^� ��c�eg$�vE17ϟ�(�|���Ѧ*����
����^���uD�̴D����h�����R��O�bv�Y����j^�SN֝
������PP���������Y>����&�P��.3+�$��ݷ�����{n����_5c�99�fbסF&�k�mv���bN�T���F���A�9�
(.�'*"��[��c�{ԛmNު8���3�~V� az
�沵�f�sD��&+[���ke3o>r��������T�]����* ���f�~nX�Ȉ���w+�G���F�,U�� D�Դ0赍�!�B�q�c�(
ܱ��f�yT�:��1�� +����C|��-�T��D�M��\|�K�j��<yJ, ����n��1.FZ�d$I0݀8]��Jn_� ���j~����ցV���������1@M�)`F�BM����^x�>
����`��I�˿��wΛ	����W[�����v��E�����u��~��{R�(����3���������y����C��!��nHe�T�Z�����K�P`ǁF´�nH啝���=>id,�>�GW-糓F������m<P8�{o[D����w�Q��=N}�!+�����-�<{[���������w�u�L�����4�����Uc�s��F�륟��c�g�u�s��N��lu���}ן($D��ת8m�Q�V	l�;��(��ڌ���k�
s\��JDIͦOzp��مh����T���IDI���W�Iǧ�X���g��O��a�\:���>����g���%|����i)	�v��]u.�^�:Gk��i)	>��T@k{'	=�������@a�$zZ�;}�󩀒��T�6�Xq&1aWO�,&L�cřT�4P���g[�
p�2��~;� ��Ҭ�29�xri� ��?��)��_��@s[��^�ܴhnɝ4&'
��NanZ4��^Js[ǘ��2���x?Oܷ�$��3�$r����Q��1@�����~��Y�Qܑ�Hjl(}�v�4vSr�iT�1���f������(���A�ᥕ�$� X,�3'�0s����×ƺk~2~'�[�ё�&F�8{2O�y�n�-`^/FPB�?.�N�AO]]�� �n]β[�SR�kN%;>�k��5������]8������=p����Ցh������`}�
�J�8-��ʺ����� �fl˫[8�?E9q�2&������p��<�r�8x� [^݂��2�X��z�V+7N����V@j�A����hl��/+/'5�3�?;9
�(�Ef'Gyҍ���̣�h4RSS� ����������j�Z��jI��x��dE-y�a�X�/�����:��� +k�� �"˖/���+`��],[��UVV4u��P �˻�AA`��)*ZB\\��9lܸ�]{N��礑]6�Hnnqqq-a��Qxy�7�`=8A�Sm&�Q�����u�0hsPz����yJt�[�>�/ޫ�il�����.��ǳ���9��
_
��<s���wT�S������;F����-{k�����T�Z^���z�!t�۰؝^�^*���؝c
���;��7]h^
��PA��+@��gA*+�K��ˌ�)S�1��(Ե��ǯ�h����õ�M�`��p�cC�T")�z�j�w��V��@��D��N�^M\����m�zY��C�Ҙ�I����N�Ϭ��{�9�)����o���C���h�����ʆ.��׏(�ҫ���@�Tf%yZt���wg�4s�]f�q뗣�ǆi�l�⵲3t��I���O��v;Z�g��l��l��kAJѩU^wj�(��������{���)�9�T���KrE�V!�D���aw���x[�I��tZ�0Y �%E�͹���n�G�P�"5FӨ��M�K�!>R���$�.x����h=gϝ�K&@-F��=}�=�����5���s �CFwa���8��u?_����D#���x:R!5&��_�]���*�O��;�)Ȉ�@�g�����ou�Q�v���J�G�6�P�������7��-���	պ^#�C�S��[]3��1���IY��.Ȉ!6\K�:��?9�Ev��S]�l;��?/� ��5�p�X��f�1�;5�S�ye��Ƅ���,Da�>�� O.�AJL(���pL�C5ij޿hBƾ���ڎ�)s��9$D�p���I��e�,ə�+;?�t��v�p�-��&����	V���x���yuo-G&8->�xt�t������Rv��Y�4ZnT�4P]�HA�4�a�T�ǅ1`u\�,���hZ����S������o翿���{�릨ZRq��Y��fat�[����[z9��4�U�V��Anb$Kg������]������8�M0(WeU�H�\n_��¹�C�F�F�}����8d�N��.��]���u�,%Z�F-���E�'����q�L�\������=H�W'�L{�BP0Z���Y�̞���DE��I�N7���c��S���7�Xm�/`�	�+`����X_��KI��^��F\�aD�����~�+M����ㅤ��	SY��/�.�`���:�9Q�c �38K�j�0Y�D�8����W;ܲ�pTt��6P,� Nǵ��Æ�:(���&�N�/ X��i%�?�_P	�n�F�.^�G�E���鬫>?���"@v�2���A~�aԹ_[P, n��N������_rƢ��    IEND�B`�       ECFG      application/config/name         BeepboxSynthesizer     application/run/main_scene         res://main.tscn    application/config/icon         res://icon.png  )   physics/common/enable_pause_aware_picking         )   rendering/environment/default_environment          res://default_env.tres    