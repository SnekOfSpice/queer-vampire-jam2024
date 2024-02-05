extends Node

var game: Game


func serialize() -> Dictionary:
	var data := {}
	
	data["Game"] = game.serialize()
	data["Sound"] = Sound.serialize()
	
	return data

func deserialize(data:Dictionary):
	game.deserialize(data.get("Game", {}))
	Sound.deserialize(data.get("Sound", {}))
