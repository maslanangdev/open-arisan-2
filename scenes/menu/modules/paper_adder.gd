extends Node

@onready var _grid := %GridContainer

const _paper_scene: PackedScene = preload("uid://dugdwg88q3hsa")
const _paper_cont_scene: PackedScene = preload("uid://f285gc3buqk")

func _ready() -> void:
	owner.file_added.connect(_create_paper)
	PaperQueue.data_changed.connect(_toggle_bg)
	
	if !PaperQueue.get_data().is_empty():
		for i in range(PaperQueue.get_data().size()):
			_create_paper_from_existing(PaperQueue.get_data()[i], i)
		_toggle_bg()
	_toggle_bg.call_deferred()

func _toggle_bg() -> void:
	if PaperQueue.get_data().is_empty(): %BG.modulate.a = 1.0
	else: %BG.modulate.a = 0.33

func _create_paper_from_existing(data: Dictionary, index: int) -> void:
	var paper := _create_paper(data.content, false, data.color)
	PaperQueue.get_data()[index].id = paper.get_instance_id()

func _create_paper(data: Variant, append_data := true, color = null) -> Paper:
	var paper: Paper = _paper_scene.instantiate()
	var type := PaperQueue.TYPE.TEXTURE if data is ImageTexture else PaperQueue.TYPE.STRING
	var paper_cont := _paper_cont_scene.instantiate()
	var center_point := paper_cont.get_child(0)
	
	if color != null:
		paper.default_color = color
	
	_grid.add_child(paper_cont)
	center_point.add_child(paper)
	
	var queue_data := {
		&"id": paper.get_instance_id(),
		&"type": type,
		&"content": data,
		&"color": paper.default_color
	}
	
	paper.queue_data = queue_data
	paper.owner = paper_cont
	paper.set_physics_process(false)
	paper.freeze = true
	
	if append_data:
		PaperQueue.append_data(queue_data)
	
	return paper
