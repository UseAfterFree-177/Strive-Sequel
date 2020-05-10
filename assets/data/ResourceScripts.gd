extends Node

var scenedict = {
	menu = "res://src/Menu.tscn",
	mansion = "res://src/main/Mansion.tscn",
	loadscreen = "res://src/LoadScreen.tscn",
}

var scriptdict = {
	descriptions = "res://assets/data/descriptions.gd",
	custom_effects = "res://src/core/custom_effects.gd",
	core_animations = "res://src/core/core_animations.gd",
	game_globals = "res://src/core/game_globals.gd",
	game_party = "res://src/core/game_party.gd",
	game_progress = "res://src/core/game_progress.gd",
	game_res = "res://src/core/game_res.gd",
	game_world = "res://src/core/game_world.gd",
}

var singletones = ['descriptions','custom_effects', "core_animations"]
#singletones
var descriptions = load("res://assets/data/descriptions.gd").new()
var custom_effects = load("res://src/core/custom_effects.gd").new()
var core_animations = null

var gamestate = ['game_globals', 'game_party', 'game_progress', 'game_res', 'game_world']
#gamestate
var game_globals
var game_party
var game_progress
var game_res
var game_world

func recreate_singletons():
	for n in get_children():
		remove_child(n)
		n.free()
	for s in singletones:
		set(s, load(scriptdict[s]).new())
		add_child(get(s))

func revert_gamestate():
	for s in gamestate:
		set(s, load(scriptdict[s]).new())
