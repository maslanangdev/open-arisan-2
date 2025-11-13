extends Node

signal window_moved(delta: Vector2)

@onready var _body: RigidBody2D = %RigidBody2D
@onready var _old_pos: Vector2 = get_window().position
var _new_pos: Vector2:
	get: return get_window().position

func _ready() -> void:
	window_moved.connect(func(w: Vector2):
		_body.apply_central_force(-w * 512.0)
	)

func _physics_process(_delta: float) -> void:
	if _new_pos != _old_pos:
		window_moved.emit(_new_pos - _old_pos)
		_old_pos = _new_pos
