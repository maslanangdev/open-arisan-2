extends Node
const Y_OFFSET := 12.0
# TODO refactor and make it modular
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func fade_in(obj: Object, dur: float = 0.3) -> AutoTween:
	obj.modulate.a = 0.0
	(func():
		AutoTween.new(obj, &"position", obj.position, dur).ignore_engine_time().ignore_pause().from(obj.position + Vector2(0.0, Y_OFFSET))
	).call_deferred()
	return AutoTween.new(obj, &"modulate:a", 1.0, dur).ignore_engine_time().ignore_pause()
	
func fade_out(obj: Object, dur: float = 0.3) -> AutoTween:
	obj.modulate.a = 1.0
	(func():
		AutoTween.new(obj, &"position", obj.position + Vector2(0.0, Y_OFFSET), dur).ignore_engine_time().ignore_pause().from(obj.position)
	).call_deferred()
	return AutoTween.new(obj, &"modulate:a", 0.0, dur).ignore_engine_time().ignore_pause()
