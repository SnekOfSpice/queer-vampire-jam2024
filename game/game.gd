extends Node2D
class_name Game

func _ready() -> void:
	GameState.game = self


func set_background(background_name: String, fade_in: float):
	var nodes_to_remove = $BackgroundLayer.get_children()
	var s = Sprite2D.new()
	s.texture = load(str("res://game/backgrounds/",background_name,".png"))
	s.modulate.a = 0.0
	$BackgroundLayer.add_child(s)
	var t = create_tween()
	t.tween_property(s, "modulate:a", 1.0, fade_in)
	t.connect("finished", remove_nodes.bind(nodes_to_remove))
	

func remove_nodes(nodes:Array):
	for n in nodes:
		n.queue_free()
	

func set_all_characters_visible(value:bool):
	for c in $Characters.get_children():
		c.visible = value

func set_character_visible(character_name: String, value:bool):
	for c in $Characters.get_children():
		if c.character_name == character_name:
			c.visible = value

func arrange_characters():
	var left_count := 0
	var right_count := 0
	var neutral_count := 0
	for c in $Characters.get_children():
		if not c.visible:
			continue
		if c.position_preference == "left":
			c.position = $CharacterPositions/Left.position + Vector2(40, 0) * left_count
			left_count += 1
		elif c.position_preference == "right":
			c.position = $CharacterPositions/Right.position - Vector2(40, 0) * right_count
			right_count += 1
		else:
			var mid = ($CharacterPositions/Left.position + $CharacterPositions/Right.position) * 0.5
			c.position = mid + Vector2(20, 0) * neutral_count * 1 if neutral_count % 2 == 0 else -1
			neutral_count += 1
