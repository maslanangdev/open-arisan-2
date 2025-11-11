class_name Transition extends CanvasLayer

@onready var color_rect := %Transition
@onready var material := color_rect.material as ShaderMaterial
@onready var label := %Label

func _ready() -> void:
	var aspect_ratio := float(get_tree().root.size.x) / float(get_tree().root.size.y)
	material.set_shader_parameter(&"aspect_ratio", aspect_ratio)
