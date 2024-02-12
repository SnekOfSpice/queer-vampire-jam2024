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
	if not Parser.line_reader.auto_continue:
		find_child("AutoDelaySlider").value = find_child("AutoDelaySlider").max_value
	else:
		find_child("AutoDelaySlider").value = Parser.line_reader.auto_continue_delay
	
	find_child("ProgressSaveLabel").modulate.a = 0.0
	


func _on_fullscreen_button_toggled(button_pressed: bool) -> void:
	Options.set_fullscreen(button_pressed)


func _on_music_volume_slider_value_changed(value: float) -> void:
	find_child("MusicVolumeLabel").text = str(int(value+80))
	Options.music_volume = value
	Sound.sync_volume()


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	find_child("SFXVolumeLabel").text = str(int(value+80))
	Options.sfx_volume = value

func _on_text_speed_slider_value_changed(value: float) -> void:
	if find_child("TextSpeedSlider").value == 101.0:
		find_child("TextSpeedLabel").text = "Instant"
	else:
		find_child("TextSpeedLabel").text = str(int(value))
	Parser.line_reader.text_speed = value


func _on_auto_delay_slider_value_changed(value: float) -> void:
	if find_child("AutoDelaySlider").value == find_child("AutoDelaySlider").max_value:
		find_child("AutoDelayLabel").text = "None"
		Parser.line_reader.auto_continue = false
	else:
		find_child("AutoDelayLabel").text = str(value)
		Parser.line_reader.auto_continue = true
	Parser.line_reader.auto_continue_delay = value


func _on_close_options_button_pressed() -> void:
	Options.save_options_to_file()
	emit_signal("close_options")


func _on_main_menu_button_pressed() -> void:
	Options.save_options_to_file()
	emit_signal("to_main_menu")


func _on_quit_game_button_pressed() -> void:
	Options.save_options_to_file()
	emit_signal("quit")


func show_save_label():
	find_child("ProgressSaveLabel").modulate.a = 1.0

func hide_save_label():
	find_child("ProgressSaveLabel").modulate.a = 0.0
