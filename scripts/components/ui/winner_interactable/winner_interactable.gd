class_name WinnerInteractable extends Node2D

static var static_signals := _static_signals.new()

class _static_signals:
	signal paper_picked(which: Paper, interacted: bool)
	signal paper_scaled_to_zero
	signal winner_shown(which: TextureRect)
	signal picture_showed(which: TextureRect, paper: Paper)
	signal picture_hidden(which: TextureRect, paper: Paper)

var paper_pair: Paper

@onready var _button := %Button
var _interacted := false
var _viewport_size: Vector2:
	get: return get_viewport().get_visible_rect().size
var _viewport_center: Vector2:
	get: return get_viewport().get_visible_rect().get_center()

static func create(pair: Paper) -> WinnerInteractable:
	var scene := load("uid://3ybh7v3obbk0")
	var instance: WinnerInteractable = scene.instantiate()
	instance.paper_pair = pair
	Arena.others_nodes.add_child(instance)
	instance.global_transform = pair.global_transform
	return instance

func _ready() -> void:
	_button.mouse_entered.connect(func():
		AutoTween.new(paper_pair, &"modulate", Color(2,2,2), 0.1)
		AutoTween.new(paper_pair, &"scale", Vector2.ONE * 1.1, 0.33, Tween.TRANS_BOUNCE)
		VFX.Highlight.new(paper_pair.icon)
	)
	_button.mouse_exited.connect(func():
		AutoTween.new(paper_pair, &"modulate", Color.WHITE, 0.1)
		AutoTween.new(paper_pair, &"scale", Vector2.ONE, 0.33, Tween.TRANS_SPRING) 
		VFX.Highlight.disable(paper_pair.icon)
	)
	_button.pressed.connect(func():
		static_signals.paper_picked.emit(paper_pair, _interacted)
		if !_interacted:
			_interacted = true
			Bottle.enable_input = false
			_animate_ssr.call_deferred()
		else:
			_create_ui(_create_rect(true))
		_button.mouse_exited.emit()
	)
	
func _physics_process(_delta: float) -> void:
	global_position = paper_pair.global_position
	
func _animate_ssr() -> void:
	const DURATION := 3.0
	const SHAKE := 12.0
	# Duplicating the paper causes a crash with error code 11, no idea why that is.
	var paper_dup: Paper = load(paper_pair.scene_file_path).instantiate()
	
	## Picked
	
	paper_dup.default_color = paper_pair.default_color
	Game.vfx_front_node.add_child(paper_dup)
	GameFX.show_dark_overlay()
	VFX.Shine.new(paper_dup)
	paper_dup.set_physics_process(false)
	paper_dup.freeze = true
	paper_dup.collision_mask = 0
	paper_dup.collision_layer = 0
	paper_dup.global_transform = paper_pair.global_transform
	paper_dup.modulate = Color(3.0, 3.0, 3.0)
	paper_pair.hide()
	
	AutoTween.new.call_deferred(paper_dup, &"global_position", _viewport_size / 2.0, DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	AutoTween.new.call_deferred(paper_dup, &"scale", Vector2.ONE * 2.5, DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	AutoTween.new.call_deferred(paper_dup, &"rotation", 0.0, 1.0, Tween.TRANS_ELASTIC)

	NodeShaker.new(paper_dup.icon.get_parent(), SHAKE, DURATION / 2.0, Vector2.ONE, false, true).finished.connect(func():
		NodeShaker.new(paper_dup.icon.get_parent(), SHAKE, 1.0, Vector2.ONE, true)
	)
	CameraShaker.new(4.0, 1.0, Vector2.ONE, true)
	VFX.Particles.InwardSpellBlast.new(paper_dup, 1.0)
	
	await get_tree().create_timer(DURATION, false).timeout
	
	## Paper scaled down
	
	AutoTween.new(paper_dup, &"scale", Vector2.ZERO, 1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN).finished.connect(CameraShaker.kill_all)
	static_signals.paper_scaled_to_zero.emit()
	get_tree().create_timer(0.3).timeout.connect(func(): GameFX.show_dark_overlay(false, 0.8))
	
	await get_tree().create_timer(1.4, false).timeout

	## Winner shown

	paper_dup.queue_free()
	
	var txt_rect := _create_rect()
	
	_create_ui(txt_rect)
	
	static_signals.winner_shown.emit(txt_rect)
	
func _create_rect(from_paper := false) -> TextureRect:
	var txt_rect := TextureRect.new()
	var tgt_scale := 0.8
	
	var center_scaled := (_viewport_size * tgt_scale) / (2.0 * tgt_scale / (1.0 - tgt_scale))
	var dur := 2.0 if !from_paper else 0.8
	var trans := Tween.TRANS_ELASTIC if !from_paper else Tween.TRANS_QUINT
	
	txt_rect.texture = paper_pair.queue_data.content
	txt_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	txt_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	txt_rect.size = _viewport_size
	txt_rect.z_index = -1
	Game.vfx_front_node.add_child(txt_rect)
	AutoTween.new(txt_rect, &"scale", Vector2.ONE * tgt_scale, dur, trans).from(Vector2.ZERO)
	AutoTween.new(txt_rect, &"global_position", center_scaled, dur, trans).from(_viewport_center if !from_paper else paper_pair.global_position)
	get_viewport().size_changed.connect(_resize_rect.bind(txt_rect, tgt_scale))
	
	static_signals.picture_showed.emit(txt_rect, paper_pair)
	
	return txt_rect

func _create_ui(txt_rect: TextureRect) -> BoxContainer:
	var ui = load("uid://bsygsbwamwn1k").instantiate()
	Game.ui_node.add_child(ui)
	GameFX.show_dark_overlay(false)
	Bottle.enable_input = false
	ui.exit_button.pressed.connect(func():
		ui.queue_free()
		GameFX.hide_dark_overlay(false, 0.66)
		paper_pair.show()
		Bottle.enable_input = true
		
		AutoTween.new(txt_rect, &"scale", Vector2.ZERO, 0.66, Tween.TRANS_QUINT, Tween.EASE_IN_OUT).finished.connect(func():
			txt_rect.queue_free.call_deferred()
		)
		AutoTween.new(txt_rect, &"global_position", paper_pair.global_position, 0.66, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	
		if get_viewport().size_changed.is_connected(_resize_rect):
			get_viewport().size_changed.disconnect(_resize_rect)

		static_signals.picture_hidden.emit(txt_rect, paper_pair)
	)
	return ui

func _resize_rect(rect: TextureRect, tgt_scale: float) -> void:
	rect.size = _viewport_size
	rect.position = (_viewport_size * tgt_scale) / (2.0 * tgt_scale / (1.0 - tgt_scale))
