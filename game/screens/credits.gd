extends Control


signal close()



func _on_close_button_pressed() -> void:
	emit_signal("close")



func _on_rich_text_label_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))
