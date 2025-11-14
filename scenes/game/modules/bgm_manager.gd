extends Node

func _ready() -> void:
	play_bgm.call_deferred()

func toggle_bgm(button: Button) -> void:
	Game.is_bgm_on = !Game.is_bgm_on
	button.text = "󰝛" if !Game.is_bgm_on else "󰝚"
	Audio.set_bgm_vol(0.0 if !Game.is_bgm_on else 100.0)

func play_bgm(fading := 0.0) -> void:
	var bgm := SFX.create(Game.instance, [SFX.playlist.wallpaper], {&"volume_db": -8.0}).play_at(Game.bgm_playback_pos).is_bgm()
	if fading != 0.0:
		bgm.fade_in(fading)

func stop_bgm() -> void:
	Game.bgm_playback_pos = SFX.get_sfx(Game.instance, [SFX.playlist.wallpaper]).stream_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	SFX.get_sfx(Game.instance, [SFX.playlist.wallpaper]).stop()
