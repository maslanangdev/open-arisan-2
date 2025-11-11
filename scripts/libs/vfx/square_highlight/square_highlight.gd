extends Node2D

var thiccness: float
var duration: float
var color: Color
var filled: bool
var dimension: Vector2
var minimum_scale: float

var _dimension: Vector2

func _ready() -> void:
	hide()

func _pool_claim() -> void:
	await get_tree().physics_frame
	_enable.call_deferred()
	set_physics_process.call_deferred(true)

func _pool_unclaim() -> void:
	hide()
	set_physics_process(false)
	
func _draw() -> void:
	draw_rect(Rect2(- _dimension / 2.0, _dimension), color, filled, thiccness)

func _enable() -> void:
	AutoTween.Method.new(self, func(val):
		_dimension = val
		color.a = remap(val.x, dimension.x, dimension.x * minimum_scale, 1.0, 0.0)
	, dimension, dimension * minimum_scale, duration).finished.connect(ObjectPoolService.unclaim.bind(self))
	show()
	
func _physics_process(_delta: float) -> void:
	queue_redraw()
