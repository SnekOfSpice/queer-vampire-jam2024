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
