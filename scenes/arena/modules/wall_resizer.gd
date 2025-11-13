extends Node

## NOT USED, SINCE THE WALL USES BOUNDARY

@onready var _margin: MarginContainer = %Margin
#@onready var _wall_colliders: Array = [
#	[%WallTop.get_child(0), %WallBottom.get_child(0)],
#	[%WallLeft.get_child(0), %WallRight.get_child(0)] 
#]
@onready var _ground: Line2D = %Ground
@onready var _ground_bg := %GroundWhite
#@onready var _offset: float = abs(_wall_colliders[1][0].polygon[1].y) - _target_size.y

var _target_size: Vector2:
	get: return get_viewport().get_visible_rect().size

func _ready() -> void:
	get_viewport().size_changed.connect(_resize)
	_resize()

func _resize() -> void:
	AutoTween.new(_margin, &"size", _target_size)
	#for c in _wall_colliders[0]:
	#	var dir = 1 if c == _wall_colliders[0][0] else -2
	#	c.polygon[1].x = _target_size.x * dir
	#	c.polygon[2].x = _target_size.x * dir
	
	#for c in _wall_colliders[1]:
	#	var dir = 1 if c == _wall_colliders[1][0] else -1
	#	c.polygon[1].y = (_target_size.y + _offset) * dir
	#	c.polygon[2].y = (_target_size.y + _offset) * dir
	_ground.points[0].x = -_target_size.x
	_ground_bg.size.x = _target_size.x * 1.3
