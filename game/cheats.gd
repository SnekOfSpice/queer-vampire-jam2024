extends Control


func init():
	ParserEvents.listen(self, "fact_changed")
	find_child("PageSpinBox").max_value = Parser.page_data.size() - 1
	find_child("AutoContinueCheckButton").button_pressed = Parser.line_reader.auto_continue
	build_fact_list()

func handle_event(event_name: String, event_args: Dictionary):
	match event_name:
		"fact_changed":
			build_fact_list()

func build_fact_list():
	find_child("FactsList").clear()
	for fact in Parser.facts:
		var icon:Texture2D
		if Parser.get_fact(fact):
			icon = load("res://systems/true.png")
		else:
			icon = load("res://systems/false.png")
		find_child("FactsList").add_item(fact, icon)

func _on_reset_facts_pressed() -> void:
	Parser.reset_facts()
	build_fact_list()

func _on_change_fact_button_pressed() -> void:
	for idx in find_child("FactsList").get_selected_items():
		var fact = find_child("FactsList").get_item_text(idx)
		Parser.change_fact(fact, find_child("FactValueButton").button_pressed)
	build_fact_list()


func _on_load_page_button_pressed() -> void:
	Parser.read_page(find_child("PageSpinBox").value)


func _on_auto_continue_check_button_pressed() -> void:
	Parser.line_reader.auto_continue = find_child("AutoContinueCheckButton").button_pressed
