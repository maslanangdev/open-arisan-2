class_name UIPreviewer extends PanelContainer

static var previewer_scene := preload("uid://bhoyf86d6ufjl")
static var active_previewer: UIPreviewer
static var static_signal = static_signals.new()

var queue_index: int

@onready var _prev_button: Button = %PrevButton
@onready var _next_button: Button = %NextButton
@onready var _exit_button: Button = %ExitButton
@onready var _text_rect: TextureRect = %TextureRect
@onready var _texture_temp: Control = %TextureTemp

class static_signals:
	@warning_ignore("unused_signal")
	signal previewer_toggled(b: bool)

var _paper_data: Dictionary:
	get: return PaperQueue.get_data()[queue_index]
var _init_text_pos: Vector2

static func show_previewer(queue_data: Dictionary) -> void:
	if active_previewer != null:
		return
	active_previewer = previewer_scene.instantiate()
	active_previewer.queue_index = PaperQueue.get_data().find(queue_data)
	static_signal.previewer_toggled.emit(true)
	MainMenu.ui_node.add_child(active_previewer)

func _ready() -> void:
	_update_content(false)
	get_tree().get_root().size_changed.connect(_resize)
	_next_button.pressed.connect(_next)
	_prev_button.pressed.connect(_prev)
	_exit_button.pressed.connect(func():
		var active_container: UIPaperContainer = instance_from_id(_paper_data.id).owner
		active_container.activate_inspector.call_deferred()
		_animate_out()
		static_signal.previewer_toggled.emit(false)
	)
#	UIPaperContainer.active_container.remove_inspector()
	
	_animate_in.call_deferred()
	(func(): _init_text_pos = _text_rect.global_position).call_deferred()
	

func _next() -> void:
	queue_index = wrapi(queue_index + 1, 0, PaperQueue.get_data().size())
	_update_content(true, 1)

func _prev() -> void:
	queue_index = wrapi(queue_index - 1, 0, PaperQueue.get_data().size())
	_update_content(true, -1)

func _update_content(animate := true, dir: int = 1) -> void:
	if animate:
		const DUR = 0.5
		var tgt := Vector2(get_viewport_rect().size.x, 0.0) * dir
		var dup := _text_rect.duplicate()
		var init_pos := _init_text_pos
		var init_size := _text_rect.size
		
		# If user is too quick
		if !_texture_temp.get_children().is_empty() and _texture_temp.get_child(0) is TextureRect:
			_texture_temp.get_child(0).queue_free()
			
		_texture_temp.add_child(dup)
		_texture_temp.move_child(dup, 0)
		dup.size = init_size
		dup.global_position = _text_rect.global_position
		(func():
			AutoTween.new(dup, &"global_position", init_pos - tgt, DUR).finished.connect(dup.queue_free)
			AutoTween.new(_text_rect, &"global_position", init_pos, DUR).from(init_pos + tgt)
		).call_deferred()
	if _paper_data.type == PaperQueue.TYPE.TEXTURE:
		_text_rect.texture = _paper_data.content
		
func _animate_in() -> void:
	const DUR := 0.5
	const TRANS := Tween.TRANS_EXPO
	
	var init_scale := 0.5
	var init_pos := _text_rect.position
	var tgt := _text_rect.get_rect().size * (1.0 - init_scale) / 2.0
	
	#AutoTween.new(self, &"modulate:a", 1.0).from(0.0)
	AutoTween.new(self, &"modulate:a", 1.0, DUR).from(0.0)
	AutoTween.new(_text_rect, &"position", init_pos, DUR, TRANS).from(init_pos + tgt)
	AutoTween.new(_text_rect, &"scale", Vector2.ONE, DUR, TRANS).from(Vector2(init_scale, init_scale))

func _animate_out() -> void:
	const DUR := 0.33
	var init_pos := global_position
	var tgt_scale := 0.8
	var tgt := get_rect().size * (1.0 - tgt_scale) / 2.0
	
	AutoTween.new(self, &"modulate:a", 0.0, DUR).from(1.0)
	AutoTween.new(self, &"global_position", init_pos + tgt, DUR).from(init_pos)
	AutoTween.new(self, &"scale", Vector2(tgt_scale, tgt_scale), DUR).from(Vector2.ONE).finished.connect(queue_free)

func _resize() -> void:
	_text_rect.size = get_viewport().get_visible_rect().size
