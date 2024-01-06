extends Node

func christmas_plans():
	if Parser.fact("plan to go to parents"):
		return "Only family."
	return "Nothing, really."
