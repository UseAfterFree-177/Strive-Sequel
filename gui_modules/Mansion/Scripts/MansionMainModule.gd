extends Control

# VARIABLES
# Modules
onready var TravelsModule = $MansionTravelsModule
onready var SlaveListModule = $MansionSlaveListModule
onready var SkillModule = $MansionSkillsModule
onready var UpgradesModule = $MansionUpgradesModule
onready var SlaveModule = $MansionSlaveModule
onready var TaskModule = $MansionTaskInfoModule
onready var MenuModule = $MansionBottomLeftModule
#onready var NavModule = $NavigationModule
onready var CraftModule = $MansionCraftModule
onready var CraftSmallModule = $MansionCraftSmallModule
onready var JobModule = $MansionJobModule
onready var SexSelect = $MansionSexSelectionModule
onready var Journal = $MansionJournalModule
onready var Locations = $MansionLocationsModule
# onready var GUIWorld = input_handler.get_spec_node(input_handler.NODE_GUI_WORLD, null, false)
onready var submodules = []

export var test_mode = false
export var generate_test_chars = false


#Skills
var skill_source
var skill_target
var chars_for_skill = []

# Travels
var travels_defaults = {code = 'default'}
var selected_travel_characters = []
var is_travel_selected
var selected_destination
var selected_location


# Upgrades
var select_chars_mode = false
var selected_upgrade
var chars_for_upgrades = []

# Craft
var is_craft_selected = false
var selected_craft_task
var persons_for_craft = []
var craft_state = "default"

# Sex
var sex_participants = []


onready var active_person = ResourceScripts.game_party.get_master()
var hovered_person = null
var is_entered = false


var mansion_state = "default" setget mansion_state_set
var mansion_prev_state


var prev_selected_travel

var always_show = [
	"TestButton",
	"MansionTaskInfoModule",
	"MansionClockModule",
	"MansionBottomLeftModule",
	"MansionSlaveModule",
	"MansionSlaveListModule",
	"MansionLogModule",
	"NavigationModule",
	"MenuButton",
]


func _ready():
	if test_mode:
		test_mode()
	var is_new_game = false
	if globals.start_new_game == true:
		globals.start_new_game = false
		self.visible = false
		is_new_game = true
		var newgame_node = Node.new()
		newgame_node.set_script(ResourceScripts.scriptdict.gamestart)
		newgame_node.start()
		input_handler.GameStartNode = newgame_node
		yield(input_handler, "StartingSequenceComplete")
		input_handler.GameStartNode.queue_free()
		show()
		input_handler.ActivateTutorial("introduction")
		if starting_presets.preset_data[ResourceScripts.game_globals.starting_preset].story == true:
			input_handler.interactive_message('intro', '', {})
		globals.common_effects([{code = 'add_timed_event', value = 'aliron_exotic_trader', args = [{type = 'fixed_date', date = 7, hour = 6}]}])
	input_handler.CurrentScene = self
	input_handler.CurrentScreen = 'mansion'
	yield(get_tree(),'idle_frame')
	gui_controller.mansion = self
	gui_controller.current_screen = self
	gui_controller.clock = input_handler.get_spec_node(input_handler.NODE_CLOCK)
	$MenuButton.connect("pressed", self, "show_menu")
	$TutorialButton.connect('pressed', self, 'show_tutorial')
	$tutorialpanel/Button.connect('pressed',$tutorialpanel,'hide')
	slave_list_manager()
	globals.log_node = $MansionLogModule
	input_handler.SetMusicRandom("mansion")
	if globals.start_new_game:
		set_active_person(ResourceScripts.game_party.get_master())
		SlaveListModule.rebuild()
		SlaveListModule.build_locations_list()
		mansion_state_set("default")
#	if globals.start_new_game == true:
#		yield(input_handler, 'EventFinished')
#		input_handler.get_spec_node(input_handler.NODE_MANSION_NEW).show_tutorial()

func show_tutorial():
	$tutorialpanel.show()
	$tutorialpanel.raise()

func show_menu():
	gui_controller.game_menu = input_handler.get_spec_node(input_handler.NODE_GAMEMENU)
	gui_controller.game_menu.show()
	gui_controller.previous_screen = gui_controller.current_screen
	gui_controller.current_screen = gui_controller.game_menu


func set_active_person(person):
	active_person = person
	SlaveListModule.prev_selected_location = SlaveListModule.selected_location
	slave_list_manager()

func mansion_state_set(state):
	# input_handler.CurrentScene = self
	mansion_prev_state = mansion_state
	mansion_state = state
	match_state()
	slave_list_manager()
	get_node("TutorialButton").show()

func reset_vars():
	if mansion_state != mansion_prev_state:
		select_chars_mode = false
		selected_upgrade = null
		chars_for_upgrades.clear()
		submodules.clear()
	if active_person == null:
		active_person = ResourceScripts.game_party.get_master()
	Journal.hide()
		# sex_participants.clear()

# Handles Resizing and visibility
func match_state():
	gui_controller.nav_panel = $NavigationModule
	gui_controller.nav_panel.build_accessible_locations()
	Journal.visible = MenuModule.get_node("VBoxContainer/Journal").is_pressed()
	for node in get_children():
		if node.get_class() == "Tween":
			continue
		if node.name.findn(mansion_state) == -1 && ! node.name in always_show:
			node.hide()
	var menu_buttons = MenuModule.get_node("VBoxContainer")
	for button in menu_buttons.get_children():
		button.pressed = false
	match mansion_state:
		"default":
			reset_vars()
			SlaveListModule.show()
			$MansionSlaveListModule.set_size(Vector2(1100, 845))
			$MansionSlaveListModule/ScrollContainer.set_size(Vector2(1004, 620))
			# SlaveListModule.get_node("Background").set_size(Vector2(1100, 845))
			$MansionSkillsModule.show()
			if mansion_state != mansion_prev_state:
				ResourceScripts.core_animations.UnfadeAnimation($MansionSkillsModule, 0.3)
				ResourceScripts.core_animations.UnfadeAnimation($MansionSlaveListModule, 0.3)
		"skill":
			$MansionSlaveListModule.show()
			$MansionSlaveListModule.set_size(Vector2(1100, 845))
			# SlaveListModule.get_node("Background").set_size(Vector2(1100, 845))
			$MansionSlaveListModule/ScrollContainer.set_size(Vector2(1004, 620))
			$MansionSlaveListModule.rebuild()
			if mansion_state != mansion_prev_state:
				ResourceScripts.core_animations.UnfadeAnimation($MansionSkillsModule, 0.3)
				ResourceScripts.core_animations.UnfadeAnimation($MansionSlaveListModule, 0.3)
		"travels":
			$MansionTravelsModule.show()
			$MansionSlaveListModule.set_size(Vector2(1100, 580))
			SlaveListModule.get_node("Background").set_size(Vector2(1100, 580))
			$MansionSlaveListModule/ScrollContainer.set_size(Vector2(1004, 360)) 
			travels_manager(travels_defaults)
			menu_buttons.get_node("TravelsButton").pressed = true
			if mansion_state != mansion_prev_state:
				ResourceScripts.core_animations.UnfadeAnimation($MansionTravelsModule, 0.3)
				ResourceScripts.core_animations.UnfadeAnimation($MansionSlaveListModule, 0.3)
		"upgrades":
			$MansionUpgradesModule.show()
			$MansionUpgradesModule.open()
			$MansionUpgradesModule.open_queue()
			$MansionSlaveListModule.set_size(Vector2(1100, 580))
			SlaveListModule.get_node("Background").set_size(Vector2(1100, 580))
			$MansionSlaveListModule/ScrollContainer.set_size(Vector2(1004, 360))
			menu_buttons.get_node("UpgradesButton").pressed = true
			SlaveListModule.rebuild()
			if mansion_state != mansion_prev_state:
				ResourceScripts.core_animations.UnfadeAnimation($MansionUpgradesModule, 0.3)
				ResourceScripts.core_animations.UnfadeAnimation($MansionSlaveListModule, 0.3)
		"occupation":
			$MansionSlaveListModule.rebuild()
			$MansionJobModule.show()
			$MansionSlaveListModule.set_size(Vector2(1100, 580))
			SlaveListModule.get_node("Background").set_size(Vector2(1100, 580))
			$MansionSlaveListModule/ScrollContainer.set_size(Vector2(1004, 360))
			# $MansionSlaveListModule/ScrollContainer.set_size($MansionSlaveListModule/ScrollContainer/VBoxContainer.get_size()) 
			$MansionJobModule.cancel_job_choice()
			if mansion_state != mansion_prev_state:
				ResourceScripts.core_animations.UnfadeAnimation($MansionJobModule, 0.3)
				ResourceScripts.core_animations.UnfadeAnimation($MansionSlaveListModule, 0.3)
		"char_info":
			open_char_info()
		"craft":
			craft_handler()
			menu_buttons.get_node("CraftButton").pressed = true
		"sex":
			SlaveListModule.show()
			$MansionSlaveListModule.set_size(Vector2(1100, 845))
			SlaveListModule.get_node("Background").set_size(Vector2(1100, 845))
			$MansionSlaveListModule/ScrollContainer.set_size(Vector2(1004, 650))
			if mansion_state != mansion_prev_state:
				ResourceScripts.core_animations.UnfadeAnimation(SexSelect, 0.3)
				ResourceScripts.core_animations.UnfadeAnimation($MansionSlaveListModule, 0.3)
			SexSelect.show()
			sex_handler()
			menu_buttons.get_node("SexButton").pressed = true

	rebuild_task_info()
	SlaveListModule.set_hover_area()

func open_char_info():
	gui_controller.slavepanel = input_handler.get_spec_node(input_handler.NODE_SLAVEMODULE)
	gui_controller.slavepanel.set_state("default")
	gui_controller.slavepanel.SummaryModule.show_summary()
	gui_controller.slavepanel.show()
	gui_controller.previous_screen = gui_controller.mansion
	gui_controller.previous_screen.hide()
	gui_controller.current_screen = gui_controller.slavepanel
	gui_controller.close_all_closeable_windows()
	gui_controller.emit_signal("screen_changed")
	ResourceScripts.core_animations.UnfadeAnimation(gui_controller.slavepanel, 0.3)

func rebuild_mansion():
	$MansionSlaveListModule.update()
	$MansionSkillsModule.build_skill_panel()
	CraftModule.rebuild_scheldue()
	UpgradesModule.open_queue()
	SlaveModule.show_slave_info()
	$TutorialButton.show()

func rebuild_task_info():
	if ResourceScripts.game_party.active_tasks == []:
		TaskModule.visible = false
		if TaskModule.is_visible():
			ResourceScripts.core_animations.FadeAnimation(TaskModule, 0.3)
		return
	for i in ResourceScripts.game_party.active_tasks:
		if i.workers != []:
			if !TaskModule.is_visible():
				ResourceScripts.core_animations.UnfadeAnimation(TaskModule, 0.3)
			TaskModule.visible = true
			break
		else:
			TaskModule.visible = false
			if TaskModule.is_visible():
				ResourceScripts.core_animations.FadeAnimation(TaskModule, 0.3)
	TaskModule.show_task_info()

### State Managers ###
# Action Handlers for Modules
func sex_handler():
	if mansion_prev_state != mansion_state:
		active_person = null
		sex_participants.clear()
		mansion_prev_state = mansion_state


func craft_handler():
	match craft_state:
		"default":
			selected_craft_task = null
			# is_craft_selected = false
			CraftModule.open()
			CraftModule.get_node("MaterialSetupPanel").hide()
			CraftModule.update()
			# CraftModule.get_node("filter").hide()
			ResourceScripts.core_animations.UnfadeAnimation(CraftModule, 0.3)
			ResourceScripts.core_animations.UnfadeAnimation($MansionSlaveListModule, 0.3)
		"confirm":
			$MansionSlaveListModule.set_size(Vector2(1100, 580))
			SlaveListModule.get_node("Background").set_size(Vector2(1100, 580))
			$MansionSlaveListModule/ScrollContainer.set_size(Vector2(871, 300))
			ResourceScripts.core_animations.FadeAnimation(CraftModule, 0.3)
			CraftModule.hide()
			CraftSmallModule.update()
			CraftSmallModule.show()
			SlaveListModule.rebuild()
			ResourceScripts.core_animations.UnfadeAnimation(CraftSmallModule, 0.3)
			ResourceScripts.core_animations.UnfadeAnimation($MansionSlaveListModule, 0.3)


func travels_manager(params):
	TravelsModule.open_character_dislocation()
	match params.code:
		'default':
			is_travel_selected = false
			selected_destination = null
			Locations.show()
			selected_travel_characters.clear()
			TravelsModule.get_node("Resources").hide()
			TravelsModule.get_node("SelectedLocation/Label").text = "Select Location"
			TravelsModule.get_node("LocationListButton").pressed = Locations.is_visible()
			TravelsModule.update_character_dislocation()
			# SlaveListModule.rebuild()
		'destination_selected':
			is_travel_selected = true
			selected_travel_characters.clear()
			selected_destination = params.destination
			TravelsModule.update_character_dislocation() 
			SlaveListModule.rebuild()
#			TravelsModule.update_buttons()

func upgrades_manager():
	SlaveListModule.rebuild()

func skill_manager():
	mansion_state = "skill"
	SlaveListModule.rebuild()			

func slave_list_manager():
	match mansion_state:
		'default':
			if mansion_prev_state == "skill" || mansion_prev_state == "sex":
				mansion_prev_state = null
				active_person = skill_source
				hovered_person = null
			else:
				skill_source = active_person
			SkillModule.build_skill_panel()
			SlaveListModule.rebuild()
			SlaveModule.show_slave_info()
		'skill':
			if active_person in chars_for_skill:
				SkillModule.use_skill(active_person)
			set_active_person(skill_source)
			SkillModule.build_skill_panel()
			SlaveListModule.rebuild()
		'travels':
			if is_travel_selected:
				if active_person in selected_travel_characters:
					self.selected_travel_characters.erase(active_person)
				else:
					self.selected_travel_characters.append(active_person)
				TravelsModule.update_character_dislocation()
			SlaveListModule.rebuild()
#			TravelsModule.update_buttons()
		'upgrades':
			if !select_chars_mode:
				SlaveModule.show_slave_info()
				SlaveListModule.rebuild()
				return
			if chars_for_upgrades.has(active_person):
				chars_for_upgrades.erase(active_person)
			else:
				chars_for_upgrades.append(active_person)
			SlaveListModule.rebuild()
			UpgradesModule.open_queue()
		'occupation':
			$MansionSlaveListModule.rebuild()
			$MansionJobModule.open_jobs_window()
		'craft':
			if active_person == null:
				set_active_person(SlaveListModule.visible_persons[0])
			if (active_person.get_location() == ResourceScripts.game_world.mansion_location) && !active_person in persons_for_craft:
				persons_for_craft.append(active_person)
			else:
				persons_for_craft.erase(active_person)
			SlaveListModule.rebuild()
			CraftSmallModule.update()
		'sex':
			if !sex_participants.has(active_person) && active_person != null:
				sex_participants.append(active_person)
			else:
				sex_participants.erase(active_person)
			SlaveListModule.rebuild()
			update_sex_date_buttons()
	SlaveModule.show_slave_info()

func update_sex_date_buttons():
	if ResourceScripts.game_globals.daily_sex_left > 0:
		SexSelect.get_node("SexButton").disabled = sex_participants.size() < 2 || sex_participants.size() > SlaveListModule.limit
	else:
		SexSelect.get_node("SexButton").disabled = true
	
	SexSelect.get_node("DateButton").disabled = (
		sex_participants.size() > 1 
		|| sex_participants.size() == 0 
		|| sex_participants.has(ResourceScripts.game_party.get_master()) 
		|| ResourceScripts.game_globals.daily_dates_left <= 0 
		|| ResourceScripts.game_party.get_master().travel.location != ResourceScripts.game_world.mansion_location
	)

func set_hovered_person(node, person):
	hovered_person = person
	SlaveModule.show_slave_info()

func remove_hovered_person():
	if SlaveListModule.is_in_area():
		return
	hovered_person = null
	SlaveModule.show_slave_info()


func _on_TestButton_pressed():
	print(ResourceScripts.game_party.active_tasks)
	print(input_handler)



func test_mode():
	variables.allow_skip_fights = true
	ResourceScripts.game_world.make_world()

	if generate_test_chars:
		var character = ResourceScripts.scriptdict.class_slave.new()
		character.create('Fairy', 'futa', 'random')
		character.unlock_class("master")
		characters_pool.move_to_state(character.id)
		ResourceScripts.game_res.upgrades.resource_gather_veges = 1
		ResourceScripts.game_res.upgrades.resource_gather_grains = 1
		#ResourceScripts.game_res.upgrades.resource_gather_cloth = 1
		ResourceScripts.game_res.upgrades.tailor = 1
		
	#	globals.impregnate(character, character)
	#	character.get_stat('pregnancy', true).duration = 2
		character.add_stat('charm', 100)
		character.add_stat('physics', 100)
		character.add_stat('hpmax', 100)
		character.unlock_class("master")
		character.unlock_class("caster")
		character.unlock_class("apprentice")
		character.unlock_class("rogue")
		character.unlock_class("druid")
		character.unlock_class("assassin")
		character.unlock_class("ruler")
		character.unlock_class("watchdog")
		character.unlock_class("director")
		character.unlock_class("trainer")
		character.unlock_class("thief")
		character.unlock_class("engineer")
		#character.travel.location = 'L4'
		#character.travel.area = 'plains'
		variables.dungeon_encounter_chance = 1
		var bow = globals.CreateGearItem("bow", {WeaponHandle = 'wood', BowBase = 'obsidian'})
		globals.AddItemToInventory(bow)
		character.equip(bow)
		character.set_slave_category('master')
		character.statlist.negative_sex_traits = ['dislike_missionary']
		character.statlist.unlocked_sex_traits = [
			'submissive',
			'pushover',
			'bottle_fairy',
			'dominant',
			'sadist',
			'desired',
			'curious',
			'life_power'
		]
		#character.armor = 135
		#character.set_stat('wits', 20)
		character.set_stat('consent', 100)
		character.set_stat('charm_factor', 5)
		character.set_stat('physics_factor', 5)
		character.set_stat('wits_factor', 5)
		character.set_stat('food_love', "meat")
		character.set_stat('food_hate', ["grain"])
		#character.unlock_class("worker")
		character.mp = 50
		character.unlock_class("sadist")
	#		character.unlock_class("caster")
		for i in Skilldata.Skilllist:
			if Skilldata.Skilllist[i].type != 'social':
				continue
			character.skills.social_skills.append(i)
		character.is_players_character = true
		globals.impregnate(character, character)
		#character.get_stat('pregnancy').duration = 2

		character = ResourceScripts.scriptdict.class_slave.new()
		character.create('HalfkinCat', 'male', 'random')
		character.set_stat("penis_virgin", false)
		character.set_stat('consent', 100)
		character.statlist.negative_sex_traits = ['dislike_missionary']
		characters_pool.move_to_state(character.id)
		#character.unlock_class("attendant")
		character.add_trait('core_trait')
		character.set_slave_category('servant')
		character.set_stat('obedience', 100)
		character.set_stat('lust', 50)
		character.is_players_character = true
		character = ResourceScripts.scriptdict.class_slave.new()
		character.create('HalfkinCat', 'random', 'random')
		characters_pool.move_to_state(character.id)

		ResourceScripts.game_globals.date = 7
		ResourceScripts.game_globals.hour = 5

		character.set_stat('obedience', 100)
		#character.fear = 25
		#character.base_exp = 99
		character.set_stat('charm_factor', 5)
		character.set_stat('physics_factor', 5)
		character.set_stat('wits_factor', 5)
		character.set_stat('sexuals_factor', 5)
		character.set_stat('charm', 100)
		character.set_stat('physics', 100)
		character.set_stat('consent', 100)

		var character2 = ResourceScripts.scriptdict.class_slave.new()
		character.set_stat('food_love', "meat")
		character.set_stat('food_hate', ["grain"])
		character2.create('HalfkinCat', 'random', 'random')
		character2.set_stat('charm', 0)
		character2.set_stat('physics', 0)
		character2.set_stat('wits', 0)
		character2.set_stat('sexuals', 0)
		var text = ''
		for i in races.tasklist.values():
			for k in i.production.values():
				var value = character.get_progress_task(i.code, k.code, true) / k.progress_per_item
				if Items.materiallist.has(k.item):
					pass

				else:
					pass

		var base_price = 0
		var output_price = 0
		for i in Items.recipes.values():
			base_price = 0
			output_price = 0
			for k in i.materials:
				base_price += Items.materiallist[k].price * i.materials[k]
			for k in i.items:
				base_price += Items.itemlist[k].price * i.items[k]

			if Items.materiallist.has(i.resultitem):
				output_price = Items.materiallist[i.resultitem].price * i.resultamount
				if base_price != 0:
					text += (
						Items.materiallist[i.resultitem].name
						+ ": Cost - "
						+ str(base_price)
						+ ", Return - "
						+ str(output_price)
						+ "\n"
					)
			else:
				output_price = Items.itemlist[i.resultitem].price * i.resultamount
				if base_price != 0:
					text += (
						Items.itemlist[i.resultitem].name
						+ ": Cost - "
						+ str(base_price)
						+ ", Return - "
						+ str(output_price)
						+ "\n"
					)

		character.set_stat('loyalty', 95)
		character.set_stat('authority', 100)
		character.set_stat('submission', 95)
		yield(get_tree(),'idle_frame')
		character.xp_module.base_exp = 1000
		character.mp = 10
		character.hp = 95
		#character.exhaustion = 1000
		character.add_trait('core_trait')
		character.set_slave_category('slave')
		character.is_players_character = true

		globals.common_effects(
			[
				{code = 'make_story_character', value = 'Daisy'},
				{
					code = 'unique_character_changes',
					value = 'daisy',
					args = [
						{code = 'sexuals_factor', value = 1, operant = "+"},
						{code = 'sextrait', value = 'submissive', operant = 'add'},  #for sextrait/add setting, trait is appended to character's traits
						{code = 'submission', operant = '+', value = 50},
						{code = 'obedience', operant = '+', value = 30},
						# {code = 'tag', operant = 'remove', value = 'no_sex'},
					]
				}
			]
		)
		ResourceScripts.game_res.money = 80000
		for i in Items.materiallist:
			ResourceScripts.game_res.materials[i] = 200
		ResourceScripts.game_res.materials.bandage = 0
		globals.AddItemToInventory(globals.CreateGearItem("handcuffs", {}))
		globals.AddItemToInventory(globals.CreateGearItem("pet_suit", {}))
		globals.AddItemToInventory(globals.CreateGearItem("tail_plug", {}))
		globals.AddItemToInventory(globals.CreateGearItem("maid_dress", {}))
		globals.AddItemToInventory(globals.CreateGearItem("craftsman_suit", {}))
		globals.AddItemToInventory(globals.CreateGearItem("worker_outfit", {}))
		globals.AddItemToInventory(globals.CreateGearItem("lacy_underwear", {}))
		globals.AddItemToInventory(globals.CreateGearItem("animal_gloves", {}))
		globals.AddItemToInventory(globals.CreateGearItem("amulet_of_recognition", {}))
		globals.AddItemToInventory(globals.CreateUsableItem("alcohol"))
		globals.AddItemToInventory(globals.CreateUsableItem("exp_scroll", 4))
		globals.AddItemToInventory(globals.CreateUsableItem("writ_of_exemption", 3))
		globals.AddItemToInventory(globals.CreateUsableItem("lifegem", 5))
		globals.AddItemToInventory(globals.CreateUsableItem("energyshard", 2))
		globals.AddItemToInventory(globals.CreateUsableItem("strong_pheromones", 3))
		globals.AddItemToInventory(globals.CreateUsableItem("majorus_potion", 3))
		globals.AddItemToInventory(globals.CreateUsableItem("majorus_potion", 3))
		globals.AddItemToInventory(
			globals.CreateGearItem("axe", {ToolHandle = 'wood', ToolBlade = 'obsidian'})
		)
		globals.AddItemToInventory(globals.CreateGearItem("club", {WeaponMace = 'stone'}))
		globals.AddItemToInventory(
			globals.CreateGearItem("spear", {WeaponHandle = 'wood', Blade = 'obsidian'})
		)
		globals.AddItemToInventory(
			globals.CreateGearItem("pickaxe", {ToolHandle = 'wood', ToolBlade = 'obsidian'})
		)
		globals.AddItemToInventory(
			globals.CreateGearItem("hammer", {ToolHandle = 'wood', ToolBlade = 'obsidian'})
		)
		
		
		globals.AddItemToInventory(
			globals.CreateGearItem("fishingtools", {ToolHandle = 'wood', ToolClothwork = 'cloth'})
		)
		
		globals.AddItemToInventory(
			globals.CreateGearItem("hunt_knife", {ToolHandle = 'wood', ToolBlade = 'obsidian'})
		)
		globals.AddItemToInventory(
			globals.CreateGearItem("legs_base_metal", {ArmorBaseHeavy = 'mithril', ArmorTrim = 'wood'})
		)
		globals.AddItemToInventory(
			globals.CreateGearItem("chest_base_metal", {ArmorBaseHeavy = 'mithril', ArmorTrim = 'wood'})
		)
		globals.AddItemToInventory(
			globals.CreateGearItem(
				"chest_base_cloth", {ArmorBaseCloth = 'clothsilk', ArmorTrim = 'wood'}
			)
		)
		ResourceScripts.game_progress.show_tutorial = true
		ResourceScripts.game_progress.active_quests.append(
			{code = 'election_global_quest', stage = 'stage1'}
		)
		
		character.mp = 10
		var tmp = {}
		tmp.oral = 70
		tmp.anal = 90
		tmp.petting = 100
		#character.set_stat('sex_skills', tmp)
		input_handler.active_location = ResourceScripts.game_world.areas.plains.locations[ResourceScripts.game_world.areas.plains.locations.keys()[4]]  #[state.areas.plains.locations.size()-1]]
		input_handler.active_area = ResourceScripts.game_world.areas.plains
		
		for i in ResourceScripts.game_world.areas.plains.factions.values():
			i.reputation = 500
			i.totalreputation += 500

		# character = ResourceScripts.scriptdict.class_slave.new()
		# character.create('Fairy', 'futa', 'random')
		# characters_pool.move_to_state(character.id)
		# character = ResourceScripts.scriptdict.class_slave.new()
		# character.create('Fairy', 'futa', 'random')
		# characters_pool.move_to_state(character.id)
		# character = ResourceScripts.scriptdict.class_slave.new()
		# character.create('Fairy', 'futa', 'random')
		# characters_pool.move_to_state(character.id)
		# character = ResourceScripts.scriptdict.class_slave.new()
		# character.create('Fairy', 'futa', 'random')
		# characters_pool.move_to_state(character.id)
		# character = ResourceScripts.scriptdict.class_slave.new()
		# character.create('Fairy', 'futa', 'random')
		# characters_pool.move_to_state(character.id)
		# character = ResourceScripts.scriptdict.class_slave.new()
		# character.create('Fairy', 'futa', 'random')
		# characters_pool.move_to_state(character.id)
		# character = ResourceScripts.scriptdict.class_slave.new()
		# character.create('Fairy', 'futa', 'random')
		# characters_pool.move_to_state(character.id)
		# character = ResourceScripts.scriptdict.class_slave.new()
		# character.create('Fairy', 'futa', 'random')
		# characters_pool.move_to_state(character.id)
		# character = ResourceScripts.scriptdict.class_slave.new()
		# character.create('Fairy', 'futa', 'random')
		# characters_pool.move_to_state(character.id)
		# character = ResourceScripts.scriptdict.class_slave.new()
		# character.create('Fairy', 'futa', 'random')
		# characters_pool.move_to_state(character.id)
		# character = ResourceScripts.scriptdict.class_slave.new()
		# character.create('Fairy', 'futa', 'random')
		# characters_pool.move_to_state(character.id)
		
		character = ResourceScripts.scriptdict.class_slave.new()
		yield(get_tree(), 'idle_frame')
		input_handler.add_random_chat_message(character2, 'hire')
