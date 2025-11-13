extends Button

var parent: Node

func _ready() -> void:
	if is_instance_valid(Game.instance):
		parent = Game.instance
	else:
		parent = MainMenu.instance
	mouse_entered.connect(func():
		SFX.create(parent, [SFX.playlist.button_hover]).no_pitch_change().is_ui()
	)
	pressed.connect(func():
		SFX.create(parent, [SFX.playlist.button_click], {&"volume_db": -5.0}).no_pitch_change().is_ui()
	)
