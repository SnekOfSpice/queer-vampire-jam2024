extends Control

signal close_options()
signal to_main_menu()
signal quit()

func build_from_options():
	Options.load_options_from_file()
	find_child("FullscreenButton").button_pressed = Options.fullscreen
	find_child("MusicVolumeSlider").value = Options.music_volume
	find_child("SFXVolumeSlider").value = Options.sfx_volume
	find_child("TextSpeedSlider").value = Parser.line_reader.text_speed
	find_child("AutoDelaySlider").value = Parser.line_reader.auto_continue_delay
	
	find_child("ProgressSaveLabel").modulate.a = 0.0
	find_child("MainMenuButton").visible = GameState.last_screen == Const.GAME_SCREEN_GAME
	find_child("QuitGameButton").visible = GameState.last_screen == Const.GAME_SCREEN_GAME and not OS.has_feature("web")
	
	find_child("PCSaveLabel").visible = GameState.game.is_pc_on
	find_child("MainMenuButton").disabled = GameState.game.is_pc_on
	find_child("QuitGameButton").disabled = GameState.game.is_pc_on
	
	find_child("AutoContinueButton").button_pressed = Parser.line_reader.auto_continue
	
	update_labels()
	

func update_labels():
	find_child("MusicVolumeLabel").text = str(int(Options.music_volume+80))
	find_child("SFXVolumeLabel").text = str(int(Options.sfx_volume+80))
	
	if find_child("TextSpeedSlider").value == 101.0:
		find_child("TextSpeedLabel").text = "Instant"
	else:
		find_child("TextSpeedLabel").text = str(int(Parser.line_reader.text_speed))
		
	find_child("AutoDelayLabel").text = str(Parser.line_reader.auto_continue_delay)
	find_child("AutoDelaySlider").visible = find_child("AutoContinueButton").button_pressed
	find_child("AutoDelayLabel").visible = find_child("AutoContinueButton").button_pressed


func _on_fullscreen_button_toggled(button_pressed: bool) -> void:
	Options.set_fullscreen(button_pressed)


func _on_music_volume_slider_value_changed(value: float) -> void:
	Options.music_volume = value
	Sound.sync_volume()
	update_labels()


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	Options.sfx_volume = value
	update_labels()

func _on_text_speed_slider_value_changed(value: float) -> void:
	Parser.line_reader.text_speed = value
	update_labels()


func _on_auto_delay_slider_value_changed(value: float) -> void:
	Parser.line_reader.auto_continue_delay = value
	update_labels()


func _on_close_options_button_pressed() -> void:
	Options.save_options_to_file()
	emit_signal("close_options")


func _on_main_menu_button_pressed() -> void:
	if GameState.last_screen == Const.GAME_SCREEN_GAME:
		Options.save_gamestate()
	Options.save_options_to_file()
	emit_signal("to_main_menu")


func _on_quit_game_button_pressed() -> void:
	if GameState.last_screen == Const.GAME_SCREEN_GAME:
		Options.save_gamestate()
	Options.save_options_to_file()
	emit_signal("quit")


func show_save_label():
	find_child("ProgressSaveLabel").modulate.a = 1.0

func hide_save_label():
	find_child("ProgressSaveLabel").modulate.a = 0.0

func _on_auto_continue_button_toggled(button_pressed: bool) -> void:
	Parser.line_reader.auto_continue = button_pressed
	update_labels()
