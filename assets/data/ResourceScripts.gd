extends Node

var scenedict = {
	menu = "res://src/Menu.tscn",
	mansion = "res://src/main/Mansion.tscn",
	loadscreen = "res://src/LoadScreen.tscn",
}

var scriptdict = {
	descriptions = "res://assets/data/descriptions.gd",
	custom_effects = "res://src/core/custom_effects.gd",
}

var singletones = {
	descriptions = load("res://assets/data/descriptions.gd").new(),
	custom_effects = load("res://src/core/custom_effects.gd").new(),
}


