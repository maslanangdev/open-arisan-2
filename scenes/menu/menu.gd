class_name MainMenu extends Node

@warning_ignore("unused_signal")
signal progress(current_bytes: int, total_bytes: int)
@warning_ignore("unused_signal")
signal file_added(data: Variant)
signal spawn_file_picker

static var instance: MainMenu
static var ui_node: CanvasLayer:
	get: return instance.get_node("%UI")
static var init := true

@onready var _start_button := %StartButton
@onready var _clear_button := %ClearButton
@onready var _version := %Version
@onready var _toggle_music_button := %MusicButton
@onready var _add_button: Button = %AddButton

var _game_scene: PackedScene = load("uid://b5q4vk5sol5pb")

func _init() -> void:
	instance = self

func _ready() -> void:
	_start_button.pressed.connect(func():
		SceneManager.change_scene(_game_scene, false, true)
	)
	_clear_button.pressed.connect(func():
		var alert := Alert.create("Yakin?")
		alert.yes.pressed.connect(func():
			for d in PaperQueue.get_data():
				var paper = instance_from_id(d.id)
				paper.queue_free()
				PaperQueue.erase_data.call_deferred(d)
			alert.exit.call_deferred()
		)
	)
	_toggle_music_button.pressed.connect(func():
		Game.is_bgm_on = !Game.is_bgm_on
		_toggle_music_button.text = "󰝛" if !Game.is_bgm_on else "󰝚"
		Audio.set_bgm_vol(0.0 if !Game.is_bgm_on else 100.0)
	)
	_add_button.pressed.connect(spawn_file_picker.emit)
	
	_version.text = "MyArisan 2 - v%s" % App.data.version
	_toggle_music_button.text = "󰝛" if !Game.is_bgm_on else "󰝚"
	
	get_tree().create_timer(0.1).timeout.connect(func():
		if !init:
			return
		Audio.set_master_vol(100.0)
		SFX.create(self, [SFX.playlist.wallpaper], {&"volume_db": -8.0})
		init = false
	)
		
	SFX.create(self, [SFX.playlist.wallpaper], {&"volume_db": -8.0}).play_at(Game.bgm_playback_pos).is_bgm()
	tree_exiting.connect(func():
		Game.bgm_playback_pos = SFX.get_sfx(self, [SFX.playlist.wallpaper]).stream_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	)
