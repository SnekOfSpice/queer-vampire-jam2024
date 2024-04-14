extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.save_icon_layer = self
	visible = false

func show_save_icon():
	visible = true
	var t = get_tree().create_timer(2.0)
	t.connect("timeout", hide_save_icon)

func hide_save_icon():
	visible = false
