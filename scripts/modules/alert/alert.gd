class_name Alert extends MarginContainer

static var instance: Alert

signal on_out

var prev_physics := false

var text: Label:
	get: return %Text
var yes: Button:
	get: return %Yes
var no: Button:
	get: return %No

static func create(content: String) -> Alert:
	var alert_scene := load("uid://1w8nu40os8cu")
	var new_alert: Alert = alert_scene.instantiate()
	new_alert.set_text(content)
	if MainMenu.instance != null:
		MainMenu.ui_node.add_child(new_alert)
	elif Game.instance != null:
		Game.ui_node.add_child(new_alert)
	else:
		printerr("Something's fucked.")
	return new_alert

func set_text(_str: String) -> void:
	text.text = _str

func exit() -> void:
	get_tree().paused = prev_physics
	on_out.emit()
	for b in [yes, no]:
		if is_instance_valid(b): b.disabled = true
	await Animate.fade_out(self).finished
	queue_free()

func _init() -> void:
	instance = self

func _ready() -> void:
	prev_physics = get_tree().paused
	Animate.fade_in(self)
	no.pressed.connect(func():
		exit()
	)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		exit()
