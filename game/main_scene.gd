extends Control

@export var dev_mode := true
var screen := Const.GAME_SCREEN_MAIN_MENU

func _ready() -> void:
	if dev_mode:
		set_screen(Const.GAME_SCREEN_GAME)
		Parser.reset_and_start()
	find_child("FullTextContainer").visible = false

func set_screen(screen:String):
	self.screen = screen
	var screen_name = screen.trim_prefix("game-screen-").capitalize()
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
