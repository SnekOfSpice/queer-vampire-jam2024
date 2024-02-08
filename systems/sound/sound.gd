extends Node

const sfx := {
	"join-noise":"res://game/audio/sfx/420521__jfrecords__dist-kalimba.wav",
	"leave-noise":"res://game/audio/sfx/420520__jfrecords__end-kalimba.wav",
	"dialup":"res://game/audio/sfx/545495__ienba__notification.wav",
	"distortion-grime":"res://game/audio/sfx/336254__deleted_user_5959249__guitar-b1-chord.wav",
	"distortion-nailbiter":"res://game/audio/sfx/533847__tosha73__distortion-guitar-power-chord-e.wav",
	"phone-vibration":"res://game/audio/sfx/688629__corycoolguy__cell-notification-vibrate.ogg",
	"bottle-clink":"res://game/audio/sfx/608709__somatik7__bottles-2.wav",
}

const music := {
	"main-menu":"res://game/audio/music/Monplaisir - Sur Tout Le Trajet - 02 Fermons une plage.ogg",
	"concert-ambient":"res://game/audio/music/504648__tosha73__the-hubbub-of-the-crowd-before-the-concert.ogg",
	"grime":"res://game/audio/music/Omniman-Feedback.ogg",
	"nailbiter":"res://game/audio/music/Omniman-The-Reek-of-Madness.ogg",
	"capra-bedroom":"res://game/audio/music/718333__josefpres__piano-loops-083-efect-2-octave-long-loop-120-bpm.ogg",
	"capra-bedroom-intro":"res://game/audio/music/Anonymous420 - How capitalism will end - 03 Commercial Break for my little sponge brain.ogg",
	"metaspirit1":"res://game/audio/music/Anonymous420 - How capitalism will end - 04 Slowly, draining me, until there is nothing, nothing else except a painbuilt body.ogg",
	"party":"res://game/audio/music/611305__szegvari__new-york-cyberpunk-synh-analogue-drums-bass-dance-retro-atmo-ambience-pad-drone-cinematic-action-music-surround.ogg",
	"panic":"res://game/audio/music/Sif - Darkstalker - 02 Kiln.ogg",
	"shanties":"res://game/audio/music/699371__immergomedia__campfire-guitar-alternate-take.ogg",
	"crowd":"res://game/audio/music/Nadrisk - Wounded by Light.ogg",
	"parents":"res://game/audio/music/OTHERTHINKER - DANDELION - 05 THE FOX IN THE TOPHAT WHISPERED INTO THE EAR OF THE RABBIT -I WELCOME YOU WITH MY BARBED WIRE HABIT-.ogg",
	"rain":"res://game/audio/music/380152__bonnyorbit__rain-and-thunder-by-a-window.ogg",
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
	if current_track_name == track_name:
		return
	current_track_name = track_name
	$BGM.stream = load(music.get(track_name, ""))
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
		
