extends Node

func set_bgm_volume(db:float):
	$BGM.volume_db = db

func play_bgm(track_name:String, fade_in:=0.0):
	match track_name:
		"concert-ambient":
			$BGM.stream = load("res://game/audio/music/504648__tosha73__the-hubbub-of-the-crowd-before-the-concert.ogg")
		"grime":
			$BGM.stream = load("res://game/audio/music/Omniman-Feedback.ogg")
		"nailbiter":
			$BGM.stream = load("res://game/audio/music/Omniman-The-Reek-of-Madness.ogg")
	if fade_in > 0.0:
		var t = create_tween()
		$BGM.volume_db = -80
		t.tween_property($BGM, "volume_db", Options.music_volume, fade_in)
	$BGM.play()
