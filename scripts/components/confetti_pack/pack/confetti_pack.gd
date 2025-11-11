extends VBoxContainer

@onready var _confetties = [
	%Confetti1, %Confetti2, %Confetti3, %Confetti4 
]

func _ready() -> void:
	var time: float
	for c: GPUParticles2D in _confetties:
		c.one_shot = true
		c.emitting = true
		time = c.lifetime
	get_tree().create_timer(time).timeout.connect(queue_free)
