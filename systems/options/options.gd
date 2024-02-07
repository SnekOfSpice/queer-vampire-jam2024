extends Node

const OPTIONS_PATH := "user://preferences.cfg"
const PARSER_STATE_PATH := "user://parser_state.json"
const GAME_STATE_PATH := "user://game_state.json"
var music_volume := 0.0
var sfx_volume := 0.0

var fullscreen := true

func save_options_to_file():
	# Create new ConfigFile object.
	var config = ConfigFile.new()

	# Store some values.
	config.set_value("preferences", "music_volume", music_volume)
	config.set_value("preferences", "sfx_volume", sfx_volume)
	config.set_value("preferences", "fullscreen", fullscreen)
	config.set_value("preferences", "line_reader", Parser.line_reader.get_preferences())

	# Save it to a file (overwrite if already exists).
	config.save(OPTIONS_PATH)

func load_options_from_file():
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load(OPTIONS_PATH)

	# If the file didn't load, ignore it.
	if err != OK:
		set_music_volume(0)
		set_fullscreen(not OS.is_debug_build())
		return

	set_music_volume(config.get_value("preferences", "music_volume", 0))
	sfx_volume = config.get_value("preferences", "sfx_volume", 0)
	Parser.line_reader.apply_preferences(config.get_value("preferences", "line_reader", {}))
	set_fullscreen(config.get_value("preferences", "fullscreen", true))

func set_fullscreen(value:bool):
	fullscreen = value
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func save_gamestate():
#	var data_to_save := {}
#	data_to_save["Sound.current_bgm_key"] = Sound.current_bgm_key
#	data_to_save["Game.current_background_image"] = current_background_image
#	var character_visibilities := {}
#	for c in get_tree().get_nodes_in_group("Character"):
#		character_visibilities[c.character_name] = c.serialize()
#	data_to_save["Game.character_visibilities"] = character_visibilities
	Parser.save_parser_state_to_file(PARSER_STATE_PATH)
	var file = FileAccess.open(GAME_STATE_PATH, FileAccess.WRITE)
	var data_to_save := GameState.serialize()
	file.store_string(JSON.stringify(data_to_save, "\t"))
	file.close()
	DialogLogger.save_log_history()

func does_savegame_exist():
	if not ResourceLoader.exists(PARSER_STATE_PATH):
		return false
	if not ResourceLoader.exists(GAME_STATE_PATH):
		return false
	return true

func load_gamestate():
	Parser.load_parser_state_from_file(PARSER_STATE_PATH)
	var file = FileAccess.open(GAME_STATE_PATH, FileAccess.READ)
	if not file:
		push_warning(str("No file at ", GAME_STATE_PATH))
		return
	
	var data : Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	
	GameState.deserialize(data)
	
#	loaded_bgm_key = game_data.get("Sound.current_bgm_key", "")
#	current_background_image = game_data.get("Game.current_background_image", "")
#	var character_visibilities : Dictionary= game_data.get("Game.character_visibilities", {})
#	for c in get_tree().get_nodes_in_group("Character"):
#		c.deserialize(character_visibilities.get(c.character_name, {}))

func set_music_volume(value:float):
	music_volume = value
	Sound.set_bgm_volume(music_volume)
