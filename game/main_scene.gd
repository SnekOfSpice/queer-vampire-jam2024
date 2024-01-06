extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Parser.reset_and_start()
	find_child("FullTextContainer").visible = false


func set_text_content(style:String):
	find_child("FullTextContainer").visible = style == "fullscreen"
	if style =="fullscreen":
		$LineReader.text_container = find_child("FullTextContainer")
		$LineReader.text_content = find_child("FullText")
	else:
		$LineReader.text_container = find_child("TextContainer")
		$LineReader.text_content = find_child("BottomText")
