extends BackBufferCopy

var lifespan := 3.0
var atlas := false
var reverse := false
var speed := 15.0
var feather := 0.2
var gap := 0.1
var force := 0.25
var initial_size := 0.0

@onready var _shockwave: ColorRect = $Shockwave

var tracker: Node2D = Node2D.new()

var _force := 0.0
var _expanding := false
var _size: float

func _ready():
	var v_x: float = max(get_viewport().get_visible_rect().size.x, get_viewport().get_visible_rect().size.y)
	var rect_size := Vector2(v_x, v_x)

	_shockwave.size = rect_size
	_shockwave.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_size = initial_size if !reverse else 1.5

	_shockwave.material.set(&"shader_parameter/force", 0.0)
	_shockwave.material.set(&"shader_parameter/preview_atlas", atlas)
	_shockwave.material.set(&"shader_parameter/rect_size", rect_size)
	_shockwave.material.set(&"shader_parameter/feather", feather)
	_shockwave.material.set(&"shader_parameter/gap", gap)

func _physics_process(delta):
	var relative_position := tracker.get_global_transform_with_canvas().origin

	_shockwave.material.set(&"shader_parameter/position", relative_position)
	_shockwave.material.set(&"shader_parameter/size", _size)
	_shockwave.material.set(&"shader_parameter/force", _force)
	
	if !reverse:
		_size += delta / (1.0 / speed * 10)
	else:
		_size -= delta / (1.0 / speed * 8)
	
	if !_expanding:
		_force += delta * 2.0
		if _force >= force:
			_expanding = true
			_force = force
			
	else:
		_force -= delta/(lifespan)
		if _force <= 0:
			set_process(false)
			tracker.queue_free()
			queue_free()
