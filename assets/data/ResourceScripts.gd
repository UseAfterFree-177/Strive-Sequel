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

var singletones = ['descriptions','custom_effects',]
#singletones
var descriptions = load("res://assets/data/descriptions.gd").new()
var custom_effects = load("res://src/core/custom_effects.gd").new()

var gamestate = ['game_globals', 'game_party', 'game_progress', 'game_res', 'game_world']
#gamestate


func recreate_singletons():
	for s in singletones:
		set(s, load(scriptdict[s]).new())

func revert_gamestate():
	for s in gamestate:
		set(s, load(scriptdict[s]).new())
