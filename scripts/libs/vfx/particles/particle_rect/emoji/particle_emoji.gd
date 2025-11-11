extends Node2D

@onready var _particles := [$Spooky, $Flower, $Love, $Surprised]

var emission_rect_extents: Vector2
var node: Node

func _ready() -> void:
	for p in _particles:
		p.emission_rect_extents = emission_rect_extents

func _physics_process(_delta: float) -> void:
	if !is_instance_valid(node):
		return
	if node.has_method(&"get_rect"):
		global_position = node.global_position + node.get_rect().size / 2.0
	else:
		global_position = node.global_position
