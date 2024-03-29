extends Node

const sfx := {
	"join-noise":"res://game/audio/sfx/420521__jfrecords__dist-kalimba.wav",
	"leave-noise":"res://game/audio/sfx/420520__jfrecords__end-kalimba.wav",
	"dialup":"res://game/audio/sfx/545495__ienba__notification.wav",
	"distortion-grime":"res://game/audio/sfx/336254__deleted_user_5959249__guitar-b1-chord.wav",
	"distortion-nailbiter":"res://game/audio/sfx/533847__tosha73__distortion-guitar-power-chord-e.wav",
	"phone-vibration":"res://game/audio/sfx/vibrate_amped.ogg",
	"bottle-clink":"res://game/audio/sfx/608709__somatik7__bottles-2.wav",
	"notification":"res://game/audio/sfx/542015__rob_marion__gasp_ui_notification_3.wav",
	"phone-call":"res://game/audio/sfx/276609__mickleness__notification-bumptious.wav",
	"motivation-sting":"res://game/audio/sfx/metaspirit_vanish.ogg",
	"bus-halting":"res://game/audio/sfx/498447__16hpanskagalantic_pavel__the-bus-is-braking.wav",
	"train-screech":"res://game/audio/sfx/333006__michael_kur95__train-braking-01.ogg",
	"confront-parents":"res://game/audio/music/171953__thatjeffcarter__droneish.ogg",
}

const music := {
	"main-menu":"res://game/audio/music/Monplaisir - Sur Tout Le Trajet - 02 Fermons une plage.ogg",
	"concert-ambient":"res://game/audio/music/untitled.ogg",
	"grime":"res://game/audio/music/Omniman-Feedback.ogg",
	"nailbiter":"res://game/audio/music/Omniman-The-Reek-of-Madness.ogg",
	"capra-bedroom":"res://game/audio/music/718333__josefpres__piano-loops-083-efect-2-octave-long-loop-120-bpm.ogg",
	"capra-bedroom-intro":"res://game/audio/music/Anonymous420 - How capitalism will end - 03 Commercial Break for my little sponge brain.ogg",
	"metaspirit1":"res://game/audio/music/Anonymous420 - How capitalism will end - 04 Slowly, draining me, until there is nothing, nothing else except a painbuilt body.ogg",
	"party":"res://game/audio/music/611305__szegvari__new-york-cyberpunk-synth-analogue-drums-bass-dance-retro-atmo-ambience-pad-drone-cinematic-action-music-surround.ogg",
	"panic":"res://game/audio/music/Sif - Darkstalker - 02 Kiln.ogg",
	"shanties":"res://game/audio/music/699371__immergomedia__campfire-guitar-alternate-take.ogg",
	"crowd":"res://game/audio/music/Nadrisk - Wounded by Light.ogg",
	"parents":"res://game/audio/music/OTHERTHINKER - DANDELION - 05 THE FOX IN THE TOPHAT WHISPERED INTO THE EAR OF THE RABBIT -I WELCOME YOU WITH MY BARBED WIRE HABIT-.ogg",
	"rain":"res://game/audio/music/380152__bonnyorbit__rain-and-thunder-by-a-window.ogg",
	"silly-food-discussion":"res://game/audio/music/GugsSuggs - Music For Streams Vol. 1 - 06 Smooth Brain Hour.ogg",
	"alcoholism":"res://game/audio/music/смерть в летнюю полночь - где же твои крылья, Ча - 05 отчего твоя душа болит, Чайка -Tape Mastering-.ogg",
	"christmas":"res://game/audio/music/смерть в летнюю полночь - где же твои крылья, Ча - 01 когда же это было, Чайка -Tape Mastering-.ogg",
	"lonely-in-forest":"res://game/audio/music/467867__haiku1996__improvisation-on-piano-ii.ogg",
	"metaspirit2":"res://game/audio/music/OTHERTHINKER - DANDELION - 01 MY SKIN DRIPS LIKE SOME THICKENED INK.ogg",
	"idle":"res://game/audio/music/Monplaisir - Sur Tout Le Trajet - 03 Sur Tout Le Retour.ogg",
	"theory-reading":"res://game/audio/music/Monplaisir - Sur Tout Le Trajet - 03 Sur Tout Le Retour.ogg",
	"sentimental-talk":"res://game/audio/music/смерть в летнюю полночь - где же твои крылья, Ча - 03 где же твои крылья, Чайка -Tape Mastering-.ogg",
	"walk-outside":"res://game/audio/music/Koi-discovery-Noise-hydrogen.ogg",
	"travel-to-club":"res://game/audio/music/GugsSuggs - Music For Streams Vol. 1 - 07 Take It Easy Tonight.ogg",
	"speed":"res://game/audio/music/t.A.T.u - mybodyisnotmyown - 02 All The Things She Said (mushroom girl remix).ogg",
	"capra-winddown":"res://game/audio/music/mushroom girl - mybodyisnotmyown - 01 mybodyisnotmyown.ogg",
	"lonely-in-forest-panic":"res://game/audio/music/Vivian Vulpine - Our Forbidden Love - Misery in Lieu - 02 Misery in Lieu.ogg",
	"killing-psychosis":"res://game/audio/music/723927__jalastram__dark_ambient_026.ogg",
	"killing":"res://game/audio/music/465551__gis_sweden__electronic-minute-no-257-some-flute-maybe.ogg",
	"after-killing":"res://game/audio/music/723930__logicmoon__city-nights.ogg",
	"bouncer":"res://game/audio/music/458557__doctor_dreamchip__arturia-acid-2019-02-04.ogg",
	"ending-doom":"res://game/audio/music/330210__erokia__ambient-wave-2-stretched.ogg",
	"ending-shade":"res://game/audio/music/556806__doctor_dreamchip__circuit-7-synth-4.ogg",
	"rider-apartment":"res://game/audio/music/652558__angelorizzo__filo-chillare-ar04-2_46.ogg",
	"forest-clearing":"res://game/audio/music/220713__edtijo__melodic-metal-with-reverb-lead.ogg",
}
# unused but good
#"res://game/audio/music/GugsSuggs - Music For Streams Vol. 1 - 03 Away From Keyboard.ogg"
#"res://game/audio/music/GugsSuggs - Music For Streams Vol. 1 - 07 Take It Easy Tonight.ogg"

var current_track_name:String

var bgm_player:AudioStreamPlayer

func serialize() -> Dictionary:
	var data := {}
	
	data["current_track_name"] = current_track_name
	data["playback_position"] = bgm_player.get_playback_position()
	
	return data

func deserialize(data:Dictionary):
	play_bgm(data.get("current_track_name", ""), 0.0, data.get("playback_position", 0.0))

func sync_volume():
	if not bgm_player:
		return
	bgm_player.volume_db = Options.music_volume

func set_bgm_volume(db:float):
	if not bgm_player:
		return
	bgm_player.volume_db = db

func play_bgm(track_name:String, fade_in:=0.0, from:=0.0):
	if current_track_name == track_name:
		return
	if not music.has(track_name):
		push_warning(str("\"", track_name, "\" isn't defined!"))
		return
	current_track_name = track_name
	if not bgm_player:
		bgm_player = AudioStreamPlayer.new()
		add_child(bgm_player)
	if fade_in > 0.0:
		var new_player = AudioStreamPlayer.new()
		add_child(new_player)
		new_player.stream = load(music.get(track_name, track_name))
		var t = create_tween()
		new_player.volume_db = -80
		t.tween_property(new_player, "volume_db", Options.music_volume, fade_in)
		t.parallel()
		t.tween_property(bgm_player, "volume_db", -80, fade_in)
		new_player.play(from)
		t.tween_callback(set_bgm_player.bind(new_player))
	else:
		bgm_player.stream = load(music.get(track_name, track_name))
		bgm_player.play(from)

func set_bgm_player(player:AudioStreamPlayer):
	bgm_player.queue_free()
	bgm_player = player

func play(soundName:String, randomPitch := false) -> AudioStreamPlayer:
	var s = load(sfx.get(soundName, soundName))
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
		
