extends PanelContainer

@onready var _back_button := %BackButton
@onready var _add_files_button := %AddFilesButton
@onready var _add_text_button := %AddTextButton

var _text_adder_scene := load("uid://bf8o2vb0ocl7a")
#@onready var _add_files_label := %AddFilesLabel
#@onready var _add_text_label := %AddTextLabel

var _exiting := false

func _ready() -> void:
	Animate.fade_in(self)
	_add_files_button.pressed.connect(_add_files)
	_add_text_button.pressed.connect(_add_text)
	_back_button.pressed.connect(_exit)

	MainMenu.instance.file_added.connect(func(_d): _exit())

func _add_files() -> void:
	MainMenu.instance.spawn_file_picker.emit()

func _add_text() -> void:
	MainMenu.ui_node.add_child(_text_adder_scene.instantiate())
	_exit.call_deferred()

func _exit() -> void:
	if _exiting:
		return
	_exiting = true
	for b in [_add_files_button, _add_files_button, _back_button]:
		b.disabled = true
	Animate.fade_out(self).finished.connect(queue_free)
