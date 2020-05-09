#extends Reference
extends Node

#world
var areas = {}
var capitals = []
var area_order = []
var starting_area = 'Plains'
var location_links = {}
var factions = {}


var locationcounter = 0

var easter_egg_characters_generated = []
var easter_egg_characters_acquired = []

func _ready():
	input_handler.connect("EnemyKilled", self, "quest_kill_receiver")

func make_world():
	world_gen.build_world()
	areas.plains.unlocked = true
	areas.forests.unlocked = true

func quest_kill_receiver(monstercode):
	for i in areas.values():
		for guild in i.quests.factions:
			for quest in i.quests.factions[guild].values():
				if quest.state == 'taken':
					for cond in quest.requirements:
						if cond.code == 'kill_monsters' && cond.type == monstercode && cond.value > cond.curvalue:
							cond.curvalue += 1
		for quest in i.quests.global.values():
			if quest.state == 'taken':
				for cond in quest.requirements:
					if cond.code == 'kill_monsters' && cond.type == monstercode && cond.value > cond.curvalue:
						cond.curvalue += 1
