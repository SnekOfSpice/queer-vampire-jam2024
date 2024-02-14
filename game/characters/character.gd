extends Node2D

@export var character_name:String
@export var position_preference:String
@export var height:int

var current_emotion:String

func _ready() -> void:
	ParserEvents.listen(self, "dialog_line_args_passed")
	ParserEvents.listen(self, "new_actor_speaking")
	add_to_group("character")
	connect("visibility_changed", on_visibility_changed)
	visible = false
	$Sprite.scale.x *= 0.65
	$Sprite.scale.y *= 0.65
	if character_name == "therapist":
		$Sprite.scale.x *= 0.48
		$Sprite.scale.y *= 0.48

func on_visibility_changed():
	if GameState.game:
		GameState.game.arrange_characters()
		if not $Sprite.texture:
			$Sprite.texture = load(str("res://game/characters/sprites/", character_name, "/neutral.png"))
		

func handle_event(event_name:String, event_args:Dictionary):
#	prints("event in char ", event_name, " - ", event_args)
	match event_name:
		"new_actor_speaking":
			if (character_name != "capra" and not character_name == "therapist") and GameState.game.is_pc_on:
				return
			if event_args.get("actor_name") == character_name:
				$Sprite.modulate.v = 1.0
				visible = true
				GameState.game.arrange_characters()
#				get_parent().move_child(self, get_parent().get_child_count())
#				z_index += 10
			else:
				$Sprite.modulate.v = 0.8
#				z_index -= 10
		"dialog_line_args_passed":
			var args : Dictionary = event_args.get("dialog_line_arg_dict")
			if args.keys().has(str(character_name + "-emotion")):
				var emo_name = args.get(str(character_name + "-emotion"))
				set_current_emotion(emo_name)
				

func set_current_emotion(emo_name:String):
	if visible:
		printt(character_name, emo_name)
	if visible and emo_name == "invisible": # the joys of gamejam hacks
		visible = false
	current_emotion = emo_name
	$Sprite.texture = load(str("res://game/characters/sprites/", character_name, "/", emo_name, ".png"))

func serialize() -> Dictionary:
	var data := {}
	
	data["visible"] = visible
	if current_emotion == "" or current_emotion == null:
		data["current_emotion"] = "neutral"
	else:
		data["current_emotion"] = current_emotion
	
	return data

func deserialize(data:Dictionary):
	visible = data.get("visible", false)
	set_current_emotion(data.get("current_emotion", "neutral"))
