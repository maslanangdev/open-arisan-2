extends Node2D

var thiccness := 45.0
var duration := 0.5
var color := Color.WHITE
var reverse := false

var _radius: float = 0.0
var _thickness: float:
	set(val): _thickness = clampf(val, 0.0, INF)
var _v_size: Vector2:
	get: return get_viewport().get_visible_rect().size

func recalculate_duration() -> void:
	duration = duration * pow((max(_v_size.x, _v_size.y) / min(_v_size.x, _v_size.y)), 0.33333)

func _ready() -> void:
	hide()

func _pool_claim() -> void:
	reverse = false
	await get_tree().physics_frame
	_enable.call_deferred()

func _pool_unclaim() -> void:
	hide()
	
func _draw() -> void:
	draw_circle(Vector2.ZERO, _radius, color, false, _thickness)

func _enable() -> void:
	global_rotation = randf_range(-PI, PI)
	scale = Vector2.ONE * 1.5
	AutoTween.Method.new(self, func(val):
		_radius = val
		_thickness = (thiccness - val)/5.0
		queue_redraw.call_deferred()
	, 0.0 if !reverse else thiccness, thiccness if !reverse else 0.0, duration
	, Tween.TRANS_QUART if !reverse else Tween.TRANS_SINE, Tween.EASE_OUT if !reverse else Tween.EASE_IN
	
	).finished.connect(ObjectPoolService.unclaim.bind(self))
	show()
	
