extends Node2D

@export var character_name:String
@export var position_preference:String

func _ready() -> void:
	ParserEvents.listen(self, "dialog_line_args_passed")
	ParserEvents.listen(self, "new_actor_speaking")
	add_to_group("character")
	connect("visibility_changed", on_visibility_changed)
	visible = false

func on_visibility_changed():
	if GameState.game:
		GameState.game.arrange_characters()
		if not $Sprite.texture:
			$Sprite.texture = load(str("res://game/characters/sprites/", character_name, "/neutral.png"))
		

func handle_event(event_name:String, event_args:Dictionary):
	prints("event in char ", event_name, " - ", event_args)
	match event_name:
		"new_actor_speaking":
			if event_args.get("actor_name") == character_name:
				visible = true
				GameState.game.arrange_characters()
		"dialog_line_args_passed":
			var args : Dictionary = event_args.get("dialog_line_arg_dict")
			if args.keys().has(str(character_name + "-emotion")):
				var emo_name = args.get(str(character_name + "-emotion"))
				$Sprite.texture = load(str("res://game/characters/sprites/", character_name, "/", emo_name, ".png"))
