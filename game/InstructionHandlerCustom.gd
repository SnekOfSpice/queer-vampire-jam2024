extends InstructionHandler

signal set_actor_name(actor_key, new_name)

func execute(instruction_name, args):
	prints("executing ", instruction_name, " with ", args)
	match instruction_name:
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
			GameState.game.set_character_visible(args.get("name"), vis)
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
