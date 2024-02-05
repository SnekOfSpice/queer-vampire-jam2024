extends Node2D
class_name Game

var is_pc_on := false
var pc_screen:String
var background:String

func serialize() -> Dictionary:
	var data := {}
	
	# background
	data["background"] = background
	
	# characters
	var characters = {}
	for c in $Characters.get_children():
		characters[c.character_name] = c.serialize()
	data["characters"] = characters
	
	# pc
	data["is_pc_on"] = is_pc_on
	data["pc_screen"] = pc_screen
	
	# vc
	var participants := {}
	for c in find_child("VCParticipantContainer").get_children():
		participants[c.character_name] = c.serialize()
	data["participants"] = participants
	
	return data

func deserialize(data:Dictionary):
	set_background(data.get("background", ""))
	
	for c in $Characters.get_children():
		c.deserialize(data.get("characters", {}).get(c.character_name))
	
	set_is_pc_on(data.get("is_pc_on", false))
	if is_pc_on:
		set_pc_screen(data.get("pc_screen", "default"))
	
	var participants = data.get("participants", {})
	for part in participants:
		var participant = add_to_voice_call(part)
		participant.deserialize(participants.get(part, {}))

func set_is_pc_on(value:bool):
	$PC.visible = value
	is_pc_on = value
	if value:
		for c in $Characters.get_children():
			if c.character_name != "capra":
				c.visible = false
	else:
		for c in find_child("VCParticipantContainer").get_children():
			c.queue_free()

func set_pc_screen(screen:String):
	pc_screen = screen
	find_child("TherapyOverlay").visible = screen == "therapy"
	find_child("VoiceCall").visible = screen == "voice-call"
	match screen:
		"voice-call":
			Sound.play("join-noise")
			for c in find_child("VCParticipantContainer").get_children():
				c.queue_free()
			add_to_voice_call("capra")

func add_to_voice_call(character_name:String) -> Node:
	for c in find_child("VCParticipantContainer").get_children():
		if c.character_name == character_name:
			return
	var item = preload("res://game/screens/voice_chat_participant.tscn").instantiate()
	item.set_character_name(character_name)
	find_child("VCParticipantContainer").add_child(item)
	return item

func _ready() -> void:
	GameState.game = self
	set_is_pc_on(false)


func set_background(background_name: String, fade_in:=0.0):
	var nodes_to_remove = $BackgroundLayer.get_children()
	var s = Sprite2D.new()
	s.centered = false
	s.texture = load(str("res://game/backgrounds/",background_name,".png"))
	s.modulate.a = 0.0
	$BackgroundLayer.add_child(s)
	var t = create_tween()
	t.tween_property(s, "modulate:a", 1.0, fade_in)
	t.connect("finished", remove_nodes.bind(nodes_to_remove))
	background = background_name
	

func remove_nodes(nodes:Array):
	for n in nodes:
		if not is_instance_valid(n):
			continue
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
		if c.position_preference.begins_with("anchor-"):
			var anchor_name :String= c.position_preference.trim_prefix("anchor-")
			var anchor_position = $CharacterPositions/Anchors.find_child(anchor_name.capitalize())
			c.position = anchor_position
		elif c.position_preference == "left":
			c.position = $CharacterPositions/Left.position + Vector2(240, 0) * left_count
			c.z_index = 10 - left_count
			left_count += 1
		elif c.position_preference == "right":
			c.position = $CharacterPositions/Right.position - Vector2(240, 0) * right_count
			c.z_index = 10 - right_count
			right_count += 1
		else:
			var mid = ($CharacterPositions/Left.position + $CharacterPositions/Right.position) * 0.5
			c.position = mid + Vector2(140, 0) * (neutral_count * 1 if neutral_count % 2 == 0 else -1)
			c.z_index = 10 - neutral_count
			neutral_count += 1
		c.position.y -= c.height
