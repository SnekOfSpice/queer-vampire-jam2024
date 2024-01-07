extends HBoxContainer

var character_name :String

func set_character_name(value:String):
	character_name = value
	$Label.text = Parser.line_reader.name_map.get(character_name, character_name)
	find_child("Icon").texture = load(str("res://game/characters/vc_icons/", character_name, ".png"))

func _ready() -> void:
	ParserEvents.listen(self, "new_actor_speaking")

func handle_event(event_name:String, event_args:Dictionary):
	prints("event in char ", event_name, " - ", event_args)
	match event_name:
		"new_actor_speaking":
			printt(event_args.get("actor_name"), character_name)
			find_child("Active").modulate.a = 1.0 if event_args.get("actor_name") == character_name else 0.0