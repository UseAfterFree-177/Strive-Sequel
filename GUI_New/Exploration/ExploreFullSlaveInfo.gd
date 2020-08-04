extends Panel

onready var GUIWorld = input_handler.get_spec_node(input_handler.NODE_GUI_WORLD, null, false)

onready var Info = $ExploreSlaveInfoModule
onready var SummaryModule = $ExploreSlaveSummaryModule
onready var BodyModule = $SlaveBodyModule
var submodules = []


func _ready():
	GUIWorld.add_close_button(self)
	$PurchaseButton.connect("pressed", self, "hire_sell")
	var base_stats_container = SummaryModule.get_node("VBoxContainer2/TextureRect2")
	for i in SummaryModule.get_node("base_stats").get_children():
		globals.connecttexttooltip(i, statdata.statdata[i.name].descript)
	for i in SummaryModule.get_node("factors").get_children():
		globals.connecttexttooltip(i, statdata.statdata[i.name].descript)
	globals.connecttexttooltip(SummaryModule.get_node("VBoxContainer2/TextureRect2/Exp"), statdata.statdata["base_exp"].descript)
	SummaryModule.get_node("VBoxContainer2/TextureRect4/NextClassExp").hint_tooltip = tr("NEXTCLASSEXP")# + str(person.get_next_class_exp())

	for i in base_stats_container.get_children():
		if i.name == "Exp":
			continue
		globals.connecttexttooltip(i, statdata.statdata[i.name].descript)
		
func update_purchase_btn():
	$PurchaseButton/Label.text = get_parent().hiremode.capitalize()


func hire_sell():
	if get_parent().hiremode == "hire":
		hire_character()
	else:
		sell_slave()


func show_summary(person):
	$Price.text = str(person.calculate_price())
	get_parent().submodules.append(self)
	# input_handler.ClearContainer(BodyModule.get_node("professions"))
	SummaryModule.get_node("Portrait").texture = person.get_icon()
	SummaryModule.get_node("sex").texture = images.icons[person.get_stat('sex')]
	SummaryModule.get_node("Name/name").text = person.get_short_name()
	SummaryModule.get_node("VBoxContainer2/TextureRect3/BaseExp").text = str(floor(person.get_stat("base_exp")))
	SummaryModule.get_node("VBoxContainer2/TextureRect4/NextClassExp").text = str(person.get_next_class_exp())
	
	for i in SummaryModule.get_node("base_stats").get_children():
		i.max_value = person.get_stat(i.name+'max')
		if i.name != 'lust': i.value = person.get_stat(i.name)
		else:i.value = person.get_stat(i.name)
		i.get_node("Label").text = str(floor(i.value)) + "/" + str(floor(i.max_value))

	for i in SummaryModule.get_node("factors").get_children():
		# if i.name in ['food_consumption', 'base_exp']:
		if i.name in ['base_exp']:
			# i.get_node("Label").text = str(floor(person.get_stat(i.name)))
			continue
		if input_handler.globalsettings.factors_as_words:
			i.get_node("Label").text = ResourceScripts.descriptions.factor_descripts[int(floor(person.get_stat(i.name)))]
			i.get_node("Label").set("custom_colors/font_color", variables.hexcolordict['factor'+str(int(floor(person.get_stat(i.name))))]) 
		else:
			i.get_node("Label").text = str(floor(person.get_stat(i.name)))
			i.get_node("Label").set("custom_colors/font_color", Color(1,1,1))

	for i in ['physics','wits','charm','sexuals']:
		if i != 'sexuals':
			SummaryModule.get_node("VBoxContainer2/TextureRect3/" + i).text = str(floor(person.get_stat(i) + person.get_stat(i+'_bonus'))) 
			SummaryModule.get_node("VBoxContainer2/TextureRect4/" + i + '2').text = str(person.get_stat(i+'_factor') * 20)
		else:
			SummaryModule.get_node("VBoxContainer2/TextureRect3/" + i).text = str(floor(person.get_stat(i) + person.get_stat(i+'_bonus')))
			SummaryModule.get_node("VBoxContainer2/TextureRect4/"+ i + '2').text = '100'
	
	# $factors/base_exp/Label.hint_tooltip = tr("NEXTCLASSEXP") + str(person.get_next_class_exp())
	# for i in person.xp_module.professions:
	# 	var newnode = input_handler.DuplicateContainerTemplate(BodyModule.get_node("professions"))
	# 	var prof = classesdata.professions[i]
	# 	var name = ResourceScripts.descriptions.get_class_name(prof, person)
	# 	newnode.get_node("Label").text = name
	# 	newnode.get_node("TextureRect").rect_size = Vector2(86,86)
	# 	newnode.get_node("TextureRect").texture = prof.icon
	# 	newnode.connect('signal_RMB_release', GUIWorld, 'show_class_info', [prof.code, person])
	# 	var temptext = "[center]"+ResourceScripts.descriptions.get_class_name(prof,person) + "[/center]\n"+ResourceScripts.descriptions.get_class_bonuses(person, prof) + ResourceScripts.descriptions.get_class_traits(person, prof)
	# 	temptext += "\n\n{color=aqua|" + tr("CLASSRIGHTCLICKDETAILS") + "}"
	# 	globals.connecttexttooltip(newnode, temptext)
	Info.update()
	BodyModule.update()


func _on_Button_pressed():
	# var person = get_parent().person_to_hire
	for i in get_parent().submodules:
		print(i.name)
	print("Current Scene:" + str(GUIWorld.CurrentScene.name))
#	print("Previous Scene:" + str(GUIWorld.PreviousScene.name))

func hire_character():
	var person = get_parent().person_to_hire
	if ResourceScripts.game_party.characters.size() >= ResourceScripts.game_res.get_pop_cap():
		if ResourceScripts.game_res.get_pop_cap() < variables.max_population_cap:
			input_handler.SystemMessage("You don't have enough rooms")
		else:
			input_handler.SystemMessage("Population limit reached")
		return
	ResourceScripts.game_res.money -= person.calculate_price()
	input_handler.PlaySound("money_spend")
	person.set_stat('is_hirable', false)
	ResourceScripts.game_party.add_slave(person)
	hide()
	
	if input_handler.scene_characters.has(person):
		input_handler.scene_characters.erase(person)
		input_handler.get_spec_node(input_handler.NODE_DIALOGUE).update_scene_characters()
	
	if input_handler.active_faction.has('slaves'):
		input_handler.active_faction.slaves.erase(person.id)
	
	# if input_handler.exploration_node.get_node("ExploreHireModule").is_visible_in_tree() == true:
	# 	input_handler.exploration_node.faction_hire()
	
	if person.get_stat('hire_scene') != '':
		input_handler.active_character = person
		input_handler.scene_characters.append(person)
		input_handler.interactive_message(person.get_stat('hire_scene'), '', {})
	GUIWorld.set_current_scene(GUIWorld.gui_data["EXPLORATION"].main_module)
	get_parent().Hire.hire()
	get_parent().Navigation.show()

func sell_slave():
	var selectedperson = get_parent().person_to_hire
	input_handler.get_spec_node(input_handler.NODE_CONFIRMPANEL, [self, 'sell_slave_confirm', selectedperson.translate("Sell [name]?")])


func sell_slave_confirm():
	var selectedperson = get_parent().person_to_hire
	ResourceScripts.game_res.money += round(selectedperson.calculate_price()/2)
	ResourceScripts.game_party.remove_slave(selectedperson)
	get_parent().active_faction.slaves.append(selectedperson.id)
	selectedperson.is_players_character = false
	input_handler.PlaySound("money_spend")
	input_handler.slave_list_node.rebuild()
	get_parent().faction_sellslaves() ### TEMPORARY
	get_parent().Navigation.show()
	self.hide()
