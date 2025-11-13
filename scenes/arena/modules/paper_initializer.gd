extends Node

const Y_OFFSET := -100.0

var _paper_scene := load("uid://dugdwg88q3hsa")
var _thread := Thread.new()

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	if _thread.is_started():
		_thread.wait_to_finish()
	_thread.start(_init_papers)
	
func _init_papers() -> void:
	var index_spawned := []
	var data_size := PaperQueue.get_data().size()
	while index_spawned.size() != data_size:
		var index: int

		while index_spawned.has(index):
			index = randi_range(0, data_size - 1)
		_spawn_paper.call_deferred(PaperQueue.get_data()[index])
		
		index_spawned.append(index)
		await get_tree().create_timer(1.0/30.0 if PaperQueue.get_data().size() <= 32 else 1.0/60.0).timeout

func _spawn_paper(data: Dictionary) -> void:
	var instance: Paper = _paper_scene.instantiate()
	var rng_pos := Vector2(randf_range(-16.0, 16.0), randf_range(-16.0, 16.0))
	instance.global_position = Bottle.instance.global_position + Vector2(0.0, Y_OFFSET).rotated(Bottle.instance.global_rotation) + rng_pos
	instance.global_rotation = randf_range(-PI, PI)
	instance.queue_data = data
	instance.default_color = data.color
	Arena.papers_nodes.add_child(instance)
