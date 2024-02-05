extends Node

const sfx := {
	"join-noise":"res://game/audio/sfx/420521__jfrecords__dist-kalimba.wav",
	"leave-noise":"res://game/audio/sfx/420520__jfrecords__end-kalimba.wav",
	"dialup":"res://game/audio/sfx/545495__ienba__notification.wav",
	"distortion-grime":"res://game/audio/sfx/336254__deleted_user_5959249__guitar-b1-chord.wav",
	"distortion-nailbiter":"res://game/audio/sfx/533847__tosha73__distortion-guitar-power-chord-e.wav",
	"phone-vibration":"res://game/audio/sfx/688629__corycoolguy__cell-notification-vibrate.ogg"
}
var current_track_name:String

func serialize() -> Dictionary:
	var data := {}
	
	data["current_track_name"] = current_track_name
	
	return data

func deserialize(data:Dictionary):
	play_bgm(data.get("current_track_name", ""))

func set_bgm_volume(db:float):
	$BGM.volume_db = db

func play_bgm(track_name:String, fade_in:=0.0):
	current_track_name = track_name
	match track_name:
		"concert-ambient":
			$BGM.stream = load("res://game/audio/music/504648__tosha73__the-hubbub-of-the-crowd-before-the-concert.ogg")
		"grime":
			$BGM.stream = load("res://game/audio/music/Omniman-Feedback.ogg")
		"nailbiter":
			$BGM.stream = load("res://game/audio/music/Omniman-The-Reek-of-Madness.ogg")
		"capra-bedroom":
			$BGM.stream = load("res://game/audio/music/718333__josefpres__piano-loops-083-efect-2-octave-long-loop-120-bpm.ogg")
		"party":
			$BGM.stream = load("res://game/audio/music/611305__szegvari__new-york-cyberpunk-synth-analogue-drums-bass-dance-retro-atmo-ambience-pad-drone-cinematic-action-music-surround.ogg")
		"panic":
			$BGM.stream = load("res://game/audio/music/Sif - Darkstalker - 02 Kiln.ogg")
		"shanties":
			$BGM.stream = load("res://game/audio/music/699371__immergomedia__campfire-guitar-alternate-take.ogg")
		"idk unused stuff":
			pass
			#
		_:
			push_warning(str("Track ", track_name, " is not defined."))
			return
	if fade_in > 0.0:
		var t = create_tween()
		$BGM.volume_db = -80
		t.tween_property($BGM, "volume_db", Options.music_volume, fade_in)
	$BGM.play()

func play(soundName:String, randomPitch := false) -> AudioStreamPlayer:
	var s = load(sfx.get(soundName, ""))
	if not s:
		print("Sound \"" + soundName + "\" is not defined") 
		return null
	
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
		
