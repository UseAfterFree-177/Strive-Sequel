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
	ch_statlist = "res://src/character/stats.gd",
	ch_xp_module = "res://src/character/leveling.gd",
	ch_equipment = "res://src/character/equip.gd",
	ch_skills = "res://src/character/skills.gd",
	ch_travel = "res://src/character/travelling.gd",
	ch_effects = "res://src/character/effects.gd",
	ch_food = "res://src/character/food.gd",
	combat_animation = "res://src/combat/CombatAnimations.gd",
	sexinteraction_parser = "res://src/sexdescriptions.gd",
	sexinteraction_member = "res://src/interaction_member.gd",
	sexinteraction_sexdict = "res://src/newsexdictionary.gd",
	class_slave = "res://src/character/CharacterClass.gd",
	class_sskill = "res://src/classes/short_skill_new.gd",
	class_sskill_legacy = "res://src/classes/short_skill.gd",
	class_sskill_value = "res://src/classes/short_skill_value.gd",
	class_ai_base = "res://src/classes/AI_base.gd",
	world_gen = "res://src/core/world_gen.gd",
	custom_text = "res://src/core/custom_text.gd",
	}

var singletones = ['descriptions','custom_effects', "core_animations", "world_gen", "custom_text"]
#singletones
var descriptions
var custom_effects
var core_animations
var world_gen
var custom_text

var gamestate = ['game_globals', 'game_party', 'game_progress', 'game_res', 'game_world']
#gamestate
var game_globals
var game_party
var game_progress
var game_res
var game_world

func load_scripts():
	for s in scriptdict:
		scriptdict[s] = load(scriptdict[s])

func recreate_singletons():
	for n in get_children():
		remove_child(n)
		n.free()
	for s in singletones:
		set(s, scriptdict[s].new())
		add_child(get(s))

func revert_gamestate():
	for s in gamestate:
		set(s, scriptdict[s].new())
