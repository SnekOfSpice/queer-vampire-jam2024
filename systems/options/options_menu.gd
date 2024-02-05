extends Control


func build_from_options():
	find_child("FullscreenButton").button_pressed = Options.fullscreen
	find_child("MusicVolumeSlider").value = Options.music_volume-1
	find_child("MusicVolumeSlider").value = Options.music_volume
	find_child("SFXVolumeSlider").value = Options.sfx_volume-1
	find_child("SFXVolumeSlider").value = Options.sfx_volume
	find_child("TextSpeedSlider").value = Parser.line_reader.text_speed-1
	find_child("TextSpeedSlider").value = Parser.line_reader.text_speed
	if Parser.line_reader.auto_continue:
		find_child("AutoDelaySlider").value = find_child("AutoDelaySlider").max_value
	else:
		find_child("AutoDelaySlider").value = Parser.line_reader.auto_continue_delay-1
		find_child("AutoDelaySlider").value = Parser.line_reader.auto_continue_delay
	


func _on_fullscreen_button_toggled(button_pressed: bool) -> void:
	Options.set_fullscreen(button_pressed)


func _on_music_volume_slider_value_changed(value: float) -> void:
	find_child("MusicVolumeLabel").text = str(int(value+80))


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	find_child("SFXVolumeLabel").text = str(int(value+80))

func _on_text_speed_slider_value_changed(value: float) -> void:
	if find_child("TextSpeedSlider").value == 101.0:
		find_child("TextSpeedLabel").text = "Instant"
	else:
		find_child("TextSpeedLabel").text = str(int(value))
	Parser.line_reader.text_speed = value


func _on_auto_delay_slider_value_changed(value: float) -> void:
	if find_child("AutoDelaySlider").value == 101.0:
		find_child("AutoDelayLabel").text = "None"
		Parser.line_reader.auto_continue = false
	else:
		find_child("AutoDelayLabel").text = str(value)
		Parser.line_reader.auto_continue = true
	Parser.line_reader.auto_continue_delay = value
