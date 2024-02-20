extends Node

var game: Game
var screen:String
var last_screen:String

func serialize() -> Dictionary:
	var data := {}
	
	data["Game"] = game.serialize()
	data["Sound"] = Sound.serialize()
	data["DialogLogger"] = DialogLogger.serialize()
	
	return data

func deserialize(data:Dictionary):
	game.deserialize(data.get("Game", {}))
	Sound.deserialize(data.get("Sound", {}))
	DialogLogger.deserialize(data.get("DialogLogger", {}))

func reach_end(end_name:String):
	var dir = DirAccess.open("user://")
	var end_path = str("user://", end_name, ".txt")
	var file = FileAccess.open(end_path, FileAccess.READ)
	if file:
		# ending reached once before
		file.close()
		return
	
	file  = FileAccess.open(end_path, FileAccess.WRITE)
	var end_string := str(
		"Capra became ", end_name, " on ", Time.get_datetime_string_from_system()
	)
	file.store_string(end_string)
	
	file.close()
