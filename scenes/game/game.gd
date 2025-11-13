class_name Game extends Node

static var instance: Game
static var bgm_playback_pos: float
static var is_bgm_on := true

static var vfx_node: CanvasLayer:
	get: return instance.get_node("%VFX")
static var vfx_front_node: CanvasLayer:
	get: return instance.get_node("%VFXFront")
static var ui_node: CanvasLayer:
	get: return instance.get_node("%UI")
static var bgm_manager: Node:
	get: return instance.get_node("Modules/BGMManager")

@onready var _fps := %FPS

static func toggle_bgm(button: Button) -> void:
	bgm_manager.toggle_bgm(button)

static func play_bgm(fading := 0.0) -> void:
	bgm_manager.play_bgm(fading)

static func stop_bgm() -> void:
	bgm_manager.stop_bgm()

func _init() -> void:
	instance = self
	ObjectPoolService.clear_all.call_deferred()

func _ready() -> void:
	_fps.visible = App.data.debug_build
	_update_fps()

func _update_fps() -> void:
	_fps.text = "%d FPS" % int(Engine.get_frames_per_second())
	get_tree().create_timer(1.0).timeout.connect(_update_fps)
