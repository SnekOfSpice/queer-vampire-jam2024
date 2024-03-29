extends Control


signal new_game()
signal load_game()
signal open_screen(screen:String)
signal quit()

func _ready() -> void:
	find_child("QuitButton").visible = not OS.has_feature("web")

func set_load_button_visible(value:bool):
	find_child("LoadGameButton").visible = value

func _on_new_game_button_pressed() -> void:
	emit_signal("new_game")


func _on_load_game_button_pressed() -> void:
	emit_signal("load_game")


func _on_tw_button_pressed() -> void:
	emit_signal("open_screen", Const.GAME_SCREEN_TW)


func _on_options_button_pressed() -> void:
	emit_signal("open_screen", Const.GAME_SCREEN_OPTIONS)


func _on_credits_button_pressed() -> void:
	emit_signal("open_screen", Const.GAME_SCREEN_CREDITS)


func _on_quit_button_pressed() -> void:
	emit_signal("quit")
