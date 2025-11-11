class_name UIInspector extends Control

var paper_container_pair: UIPaperContainer
var image: ImageTexture
var paper_pair: Paper

@onready var inspect_container: VBoxContainer = %InspectContainer

@onready var _up_container: VBoxContainer = %Up
@onready var _down_container: VBoxContainer = %Down
#@onready var _edit_button := %EditButton
@onready var _delete_button := %DeleteButton
@onready var _preview := %Preview
@onready var _preview_button := %PreviewButton

var _paper_duplicate: Paper

func activate() -> void:
	modulate.a = 1.0
	_down_container.show()
	_preview_button.mouse_filter = Control.MOUSE_FILTER_PASS
	inspect_container.mouse_filter = Control.MOUSE_FILTER_PASS
	AutoTween.new(_up_container, &"position", Vector2.ZERO, 0.33, Tween.TRANS_BOUNCE).from(Vector2(0.0, -8.0))
	(func():
		var init_pos := _down_container.position
		AutoTween.new(_down_container, &"position", init_pos, 0.33).from(init_pos + Vector2(0.0, -16.0))
		set_physics_process(true)
		if !is_instance_valid(_paper_duplicate):
			_paper_duplicate = paper_pair.duplicate()
			_paper_duplicate.default_color = paper_pair.default_color
			_paper_duplicate.z_index = 2
			MainMenu.ui_node.add_child(_paper_duplicate)
			_paper_duplicate.global_transform = paper_pair.global_transform
	).call_deferred()

func animate_in() -> void:
	AutoTween.new(_up_container, &"position", Vector2.ZERO).from(Vector2(0.0, 16.0))
	AutoTween.new(_up_container, &"modulate:a", 1.0, 0.25).from(0.0)

func _ready() -> void:
	_preview_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview.texture = image
	_delete_button.pressed.connect(_delete)
	_preview_button.pressed.connect(UIPreviewer.show_previewer.bind(paper_pair.queue_data))
	_preview_button.pressed.connect(_delete_duplicate)
	_down_container.hide()
	tree_exited.connect(_delete_duplicate)
	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	var rect = paper_container_pair.get_rect().size
	global_position = paper_container_pair.global_position + (rect / 2.0)
	if is_instance_valid(_paper_duplicate):
		_paper_duplicate.global_transform = paper_pair.global_transform

func _delete() -> void:
	PaperQueue.erase_data(paper_pair.queue_data)
	paper_pair.queue_free()
	_delete_duplicate()
	queue_free()

func _delete_duplicate() -> void:
	if is_instance_valid(_paper_duplicate):
		_paper_duplicate.queue_free()
