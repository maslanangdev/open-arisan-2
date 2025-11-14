extends Node

@onready var _polygon: Polygon2D = Arena.papers_nodes

var _init_data: PackedVector2Array

func _ready() -> void:
	_init_data = _polygon.polygon.duplicate()

func _process(_delta: float) -> void:
	var data: PackedVector2Array
	for p in _init_data:
		data.append(
			p.rotated(Bottle.instance.global_rotation) + Bottle.instance.global_position
		)
	_polygon.polygon = data
	
