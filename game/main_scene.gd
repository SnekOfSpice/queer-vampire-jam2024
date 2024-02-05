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
	find_child("FullTextContainer").visible = false
	find_child("Cheats").visible = false
	find_child("OptionsMenu").build_from_options()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("f1") and dev_mode:
		find_child("Cheats").visible = not find_child("Cheats").visible
	if Input.is_action_just_pressed("ui_cancel"):
		if screen == Const.GAME_SCREEN_OPTIONS:
			set_screen(last_screen)
			if screen == Const.GAME_SCREEN_GAME:
				Parser.paused = false
		else:
			set_screen(Const.GAME_SCREEN_OPTIONS)
			Parser.paused = true

func start_new_game():
	set_screen(Const.GAME_SCREEN_GAME)
	Parser.reset_and_start(0)

func load_game():
	pass

func set_screen(screen:String):
	last_screen = self.screen
	self.screen = screen
	var screen_name = screen.trim_prefix("game-screen-")
	screen_name = screen_name.replace("-", " ")
	screen_name = screen_name.capitalize()
	screen_name = screen_name.replace(" ", "")
	for c in get_children():
		if not c is SubViewportContainer:
			continue
		c.visible = c.name == str(screen_name, "ViewportContainer")
	$Dialog.visible = screen == Const.GAME_SCREEN_GAME
	

func set_text_content(style:String):
	find_child("FullTextContainer").visible = style == "fullscreen"
	if style =="fullscreen":
		$LineReader.text_container = find_child("FullTextContainer")
		$LineReader.text_content = find_child("FullText")
	else:
		$LineReader.text_container = find_child("TextContainer")
		$LineReader.text_content = find_child("BottomText")
