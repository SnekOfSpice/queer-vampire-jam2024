extends HBoxContainer

var character_name :String
var replaced_map_name:String

var user_names := {
	"capra": "Capra (she/her)",
	"crosscull": "x-x",
	"angel": "real",
	"rider": "notrider",
	"starry": "starry",
	"icy-aloe": "Icy | she/they",
	"para" : "Rogue"
}

func serialize() -> Dictionary:
	return {"character_name": character_name, "replaced_map_name": replaced_map_name}

func deserialize(data:Dictionary):
	set_character_name(data.get("character_name", ""))
	replaced_map_name = data.get("replaced_map_name", "")

func _ready() -> void:
	tree_exiting.connect(restore_name_map_entry)
	ParserEvents.listen(self, "new_actor_speaking")

func restore_name_map_entry():
	Parser.line_reader.set_actor_name(character_name, replaced_map_name)

func set_character_name(value:String):
	character_name = value
	replaced_map_name = Parser.line_reader.get_actor_name(character_name)
	Parser.line_reader.set_actor_name(character_name, user_names.get(character_name))
	$Label.text = user_names.get(character_name, character_name)
	find_child("Icon").texture = load(str("res://game/characters/vc_icons/", character_name, ".png"))

func handle_event(event_name:String, event_args:Dictionary):
#	prints("event in char ", event_name, " - ", event_args)
	match event_name:
		"new_actor_speaking":
			find_child("Active").modulate.a = 1.0 if event_args.get("actor_name") == character_name else 0.0
