extends BoxContainer

@onready var lights := [
	%Spotlight1.light,
	%Spotlight2.light
]
@onready var confetti := [
	%Confetti1,
	%Confetti2
]

var _last_dur := INF

func _ready() -> void:
	await get_tree().create_timer(1.5).timeout
	if !is_instance_valid(self):
		return
	for c: GPUParticles2D in confetti:
		c.emitting = true

func fade_in() -> void:
	AutoTween.new(self, &"modulate:a", 1.0, 0.8, Tween.TRANS_LINEAR).from(0.0)
	for l: PointLight2D in lights:
		AutoTween.new(l, &"energy", l.energy, 0.8, Tween.TRANS_LINEAR).from(0.0)

func fade_out(dur := 0.8) -> void:
	if _last_dur <= dur:
		return
	AutoTween.new(self, &"modulate:a", 0.0, dur, Tween.TRANS_LINEAR)
	for l: PointLight2D in lights:
		AutoTween.new(l, &"energy", 0.0, dur, Tween.TRANS_LINEAR).finished.connect(func():
			if !is_queued_for_deletion():
				queue_free()
		)
	_last_dur = dur
