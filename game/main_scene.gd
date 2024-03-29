extends Control

@export var dev_mode := true
@export var start_page_index := 0
var screen := Const.GAME_SCREEN_MAIN_MENU
var last_screen:= Const.GAME_SCREEN_MAIN_MENU

func _ready() -> void:
	Parser.paused = true
	if dev_mode:
		Parser.line_reader.auto_continue = false
		Parser.line_reader.auto_continue_delay = 0.0
		find_child("Cheats").init()
		set_screen(Const.GAME_SCREEN_MAIN_MENU)
		if screen == Const.GAME_SCREEN_GAME:
			Parser.reset_and_start(start_page_index)
	else:
		set_screen(Const.GAME_SCREEN_MAIN_MENU)
	find_child("FullTextContainer").visible = false
	find_child("Cheats").visible = false
	find_child("OptionsMenu").build_from_options()
	find_child("History").visible = false
	ParserEvents.listen(self, "terminate_page")
	ParserEvents.listen(self, "choice_pressed")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("f1") and dev_mode:
		find_child("Cheats").visible = not find_child("Cheats").visible
	if Input.is_action_just_pressed("ui_cancel"):# or Input.is_action_just_pressed("rclick"):
		toggle_option_screen()

func handle_event(event_name: String, event_args: Dictionary):
	match event_name:
		"terminate_page":
			set_screen(Const.GAME_SCREEN_MAIN_MENU)
		"choice_pressed":
			Options.save_gamestate()

func toggle_option_screen():
	if find_child("History").visible:
		set_history_visible(false)
		return
	if screen == Const.GAME_SCREEN_OPTIONS:
		Options.save_options_to_file()
		set_screen(last_screen)
		if screen == Const.GAME_SCREEN_GAME:
			Parser.paused = false
			set_history_visible(false)
	else:
		set_screen(Const.GAME_SCREEN_OPTIONS)
		Parser.paused = true

func start_new_game():
	set_screen(Const.GAME_SCREEN_GAME)
	Parser.reset_and_start(0)
	DialogLogger.start_new_log()
	GameState.game.set_all_characters_visible(false)

func load_game():
	set_screen(Const.GAME_SCREEN_GAME)
	Options.load_gamestate()
	Parser.paused = false

func set_history_visible(value:bool):
	Parser.paused = value
	find_child("History").visible = value
	find_child("ButtonsContainer").visible = not value
	if find_child("History").visible:
		find_child("HistoryLabel").text = Parser.build_history_string()

func set_screen(new_screen:String):
	last_screen = screen
	screen = new_screen
	GameState.screen = new_screen
	GameState.last_screen = last_screen
	var screen_name = screen.trim_prefix("game-screen-")
	screen_name = screen_name.replace("-", " ")
	screen_name = screen_name.capitalize()
	screen_name = screen_name.replace(" ", "")
	for c in get_children():
		if not c is SubViewportContainer:
			continue
		c.visible = c.name == str(screen_name, "ViewportContainer")
	$Dialog.visible = screen == Const.GAME_SCREEN_GAME
	find_child("ButtonsContainer").visible = screen == Const.GAME_SCREEN_GAME
	
	match self.screen:
		Const.GAME_SCREEN_MAIN_MENU:
#			Options.save_gamestate()
			Sound.play_bgm("main-menu")
			find_child("MainMenu").set_load_button_visible(Options.does_savegame_exist())
		Const.GAME_SCREEN_OPTIONS:
			find_child("OptionsMenu").build_from_options()

func set_text_content(style:String, variant:String):
	find_child("FullTextContainer").visible = style == "fullscreen"
	if style =="fullscreen":
		$LineReader.text_container = find_child("FullTextContainer")
		$LineReader.text_content = find_child("FullText")
		find_child("FullTextBackground").texture = load(str("res://game/backgrounds/fullscreen-", variant, ".png"))
	else:
		$LineReader.text_container = find_child("TextContainer")
		$LineReader.text_content = find_child("BottomText")
	$LineReader.text_content.text = ""

func quit_game():
	Options.save_options_to_file()
	get_tree().quit()


func _on_line_reader_line_reader_ready() -> void:
	Options.load_options_from_file()
#	if dev_mode:
#		Options.set_fullscreen(false)
