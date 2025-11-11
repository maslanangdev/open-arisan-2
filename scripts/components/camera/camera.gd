class_name Camera extends Camera2D

static var instance: Camera
static var shake_offset: Vector2
static var power: float:
	set(val): power = clampf(val, 0.0, 0.33)

var _default_pos: Vector2
var _center_point: Vector2:
	get: return get_viewport().get_visible_rect().get_center()
var _arena_margin: MarginContainer:
	get: return Arena.instance.get_node("%Margin").get_parent() if Arena.instance != null else null

func _init() -> void:
	instance = self

func _ready() -> void:
	_default_pos = _center_point
	shake_offset = Vector2.ZERO

func _process(_delta: float) -> void:
	var d_pos := (_center_point - Bottle.g_position) * 0.05
	_default_pos = _center_point - d_pos
	global_position = _default_pos + shake_offset
	_arena_margin.offset = d_pos
	#global_position = _center_point
