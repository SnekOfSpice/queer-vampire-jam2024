extends Node

func christmas_plans():
	if Parser.get_fact("plan to go to parents"):
		return "Only family."
	return "Nothing, really."

func bar_count():
	if Parser.get_fact("Xmas: swag"):
		return "three"
	return "two"
