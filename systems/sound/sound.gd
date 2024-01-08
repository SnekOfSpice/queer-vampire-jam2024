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
		_:
			push_warning(str("Track ", track_name, " is not defined."))
			return
	if fade_in > 0.0:
		var t = create_tween()
		$BGM.volume_db = -80
		t.tween_property($BGM, "volume_db", Options.music_volume, fade_in)
	$BGM.play()

func play(soundName:String, randomPitch := false) -> AudioStreamPlayer:
	var s = get(soundName)
	if s is Array:
		if s.size() == 0:
			prints("no sounds in array ", soundName)
			return null
		randomize()
		s = s[randi_range(0, s.size() - 1)]
	if s:
		var p = AudioStreamPlayer.new()
		add_child(p)
		p.volume_db = 4 + Options.sfx_volume
		p.connect("finished", p.queue_free)
		p.stream = s
		p.play()
		if randomPitch:
			randomize()
			p.pitch_scale = randf_range(0.8, 1.0 / 0.8)
		return p
	else:
		print("Sound \"" + soundName + "\" is not defined") 
		return null
