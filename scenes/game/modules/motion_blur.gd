extends Node

const FRAMERATE := 1.0/24.0

@export var quality := 2

var blur_node: CanvasLayer
var active := false

var _framebuffers: Array[Image]
var _txt_rects: Array[TextureRect]
var _viewport_size: Vector2i:
	get: return Vector2i(get_viewport().get_visible_rect().size)

func activate() -> void:
	blur_node.show()
	active = true
	_framebuffers.clear()
	for t in _txt_rects:
		t.texture = null
	_create_clock.call_deferred()

func deactivate() -> void:
	blur_node.hide()
	active = false

func _ready() -> void:
	if !_txt_rects.is_empty() and blur_node != null:
		return
		
	blur_node = CanvasLayer.new()
	Game.instance.add_child.call_deferred(blur_node)
	blur_node.name = "BlurNode"
	
	await get_tree().physics_frame
	
	for i in range(quality):
		var txt_rect := TextureRect.new()
		blur_node.add_child(txt_rect)
		_txt_rects.append(txt_rect)
		txt_rect.modulate.a = remap(i, 0.0, quality, 0.1, 0.0)
		txt_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		txt_rect.stretch_mode = TextureRect.STRETCH_SCALE
		txt_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	_resize_rects()
	
	get_viewport().size_changed.connect(_resize_rects)

func _create_clock() -> void:
	var image = get_viewport().get_texture().get_image()

	if _framebuffers.size() > quality:
		_framebuffers.pop_back()
	if _framebuffers.size() <= _txt_rects.size():
		for i in range(_framebuffers.size()):
			_txt_rects[i].texture = ImageTexture.create_from_image(_framebuffers[i])
	_framebuffers.push_front.call_deferred(image)
	if active:
		get_tree().create_timer(FRAMERATE, false).timeout.connect(_create_clock)
	
func _resize_rects() -> void:
	for r in _txt_rects:
		r.size = _viewport_size
