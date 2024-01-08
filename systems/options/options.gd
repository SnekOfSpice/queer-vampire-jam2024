extends Node

const OPTIONS_PATH := "user://preferences.cfg"
var music_volume := 0.0
var sfx_volume := 0.0

var fullscreen := true

func _ready() -> void:
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load(OPTIONS_PATH)

	# If the file didn't load, ignore it.
	if err != OK:
		print("ERR")
		return

	set_music_volume(config.get_value("preferences", "music_volume", 0))
	sfx_volume = config.get_value("preferences", "sfx_volume", 0)
	Parser.line_reader.apply_preferences(config.get_value("preferences", "line_reader", {}))
	set_fullscreen(config.get_value("preferences", "fullscreen", true))

func save_prefs():
	# Create new ConfigFile object.
	var config = ConfigFile.new()

	# Store some values.
	config.set_value("preferences", "music_volume", music_volume)
	config.set_value("preferences", "sfx_volume", sfx_volume)
	config.set_value("preferences", "fullscreen", fullscreen)
	config.set_value("preferences", "line_reader", Parser.line_reader.get_preferences())

	# Save it to a file (overwrite if already exists).
	config.save(OPTIONS_PATH)

func set_fullscreen(value:bool):
	fullscreen = value
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func set_music_volume(value:float):
	music_volume = value
	Sound.set_bgm_volume(music_volume)
