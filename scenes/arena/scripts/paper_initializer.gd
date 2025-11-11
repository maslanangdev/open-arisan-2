extends Node

const Y_OFFSET := -100.0

var _paper_scene := load("uid://dugdwg88q3hsa")

func _ready() -> void:
	_init_papers.call_deferred()
	
func _init_papers() -> void:
	await get_tree().create_timer(0.1).timeout
	for d in PaperQueue.get_data():
		var instance: Paper = _paper_scene.instantiate()
		var rng_pos := Vector2(randf_range(-16.0, 16.0), randf_range(-16.0, 16.0))

		instance.global_position = Bottle.instance.global_position + Vector2(0.0, Y_OFFSET).rotated(Bottle.instance.global_rotation) + rng_pos
		instance.global_rotation = randf_range(-PI, PI)
		instance.queue_data = d
		instance.default_color = d.color
		Arena.papers_nodes.add_child(instance)
		await get_tree().create_timer(1.0/30.0 if PaperQueue.get_data().size() <= 32 else 1.0/60.0).timeout
