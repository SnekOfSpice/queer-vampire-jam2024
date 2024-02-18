extends InstructionHandler

signal set_actor_name(actor_key, new_name)
signal set_text_content(style, variant)
signal make_screen_black(hide_characters: bool, new_background: String, attack: float, release: float, sustain: float, new_bgm: String)

func execute(instruction_name, args):
	prints("executing ", instruction_name, " with ", args)
	match instruction_name:
		"play-sfx":
			Sound.play(args.get("key", ""))
		"black-fade":
			var fade_in := float(args.get("fade_in"))
			var fade_out := float(args.get("fade_out"))
			var sustain := float(args.get("sustain"))
			var new_background :String = args.get("new_background")
			var new_bgm :String = args.get("new_bgm")
			var hide_characters := true if args.get("hide_characters") == "true" else false
			emit_signal("make_screen_black", hide_characters, new_background, fade_in, fade_out, sustain, new_bgm)
			return true
		"character-visible":
			var vis_str = args.get("visible")
			var vis : bool
			if vis_str == "true":
				vis = true
			elif vis_str == "false":
				vis = false
			else:
				push_warning("idk get fucked")
				return
			if GameState.game.is_pc_on:
				if GameState.game.pc_screen == "voice-call":
					GameState.game.add_to_voice_call(args.get("name"))
				if args.get("name") == "therapist": # the joys of gamejam hacks
					GameState.game.set_character_visible(args.get("name"), vis)
			else:
				GameState.game.set_character_visible(args.get("name"), vis)
		"hide-all-characters":
			GameState.game.set_all_characters_visible(false)
		"play-bgm":
			var track_name = args.get("track_name")
			var fade_in = float(args.get("fade_in_time"))
			Sound.play_bgm(track_name, fade_in)
		"set-background":
			var track_name = args.get("background_name")
			var fade_in = float(args.get("fade_in_time"))
			GameState.game.set_background(track_name, fade_in)
		"set-name":
			var actor_key = args.get("actor_key")
			var new_name = args.get("new_name")
			emit_signal("set_actor_name", actor_key, new_name)
		"set-display-style":
			emit_signal("set_text_content", args.get("style"), args.get("variant"))
		"close-pc":
			GameState.game.set_is_pc_on(false)
		"open-pc":
			var screen :String = args.get("screen")
			GameState.game.set_pc_screen(screen)
			GameState.game.set_is_pc_on(true)
		"set-emotion":
			for c in get_tree().get_nodes_in_group("character"):
				if c.character_name == "":
					c.set_current_emotion(args.get("emo", "neutral"))


func _on_black_instruction_completed() -> void:
	emit_signal("instruction_completed")
