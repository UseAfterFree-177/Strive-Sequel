extends Reference

var parent

var base_exp = 0 setget base_exp_set
var professions = []

var sleep = ''
var work = ''
var previous_work = ''
var workproduct = null
var work_rules = {ration = false, shifts = false, constrain = false}
var messages = []

func base_exp_set(value):
	if value >= get_next_class_exp() && base_exp < get_next_class_exp():
		input_handler.add_random_chat_message(parent, 'exp_for_level')
		input_handler.ActivateTutorial("levelup")
	base_exp = value

#professions
func get_next_class_exp():
#	var professions = parent.get_stat('professions')
	var currentclassnumber = professions.size()
	var growth_factor = parent.get_stat('growth_factor')
	if professions.has("master"): currentclassnumber -= 1
	var exparray
	var value = 0
	if currentclassnumber < growth_factor * variables.class_cap_per_growth + variables.class_cap_basic:
		exparray = variables.soft_level_reqs
		if exparray.size()-1 < abs(growth_factor * variables.class_cap_per_growth + variables.class_cap_basic):
			value = exparray[exparray.size()-1]
		else:
			value = exparray[currentclassnumber]
	else:
		exparray = variables.hard_level_reqs
		if exparray.size()-1 < abs(growth_factor * variables.class_cap_per_growth + variables.class_cap_basic - currentclassnumber):
			value = exparray[exparray.size()-1]
		else:
			value = exparray[abs(growth_factor * variables.class_cap_per_growth + variables.class_cap_basic - currentclassnumber)]
	return value

func get_class_list(category, person):
	var array = []
	for i in Skilldata.professions.values():
		if (category != 'any' && i.categories.has(category) == false) || professions.has(i.code) == true:
			continue
		if parent.checkreqs(i.reqs, true) == true:
			array.append(i)
	return array

func unlock_class(prof, satisfy_progress_reqs = false):
	prof = Skilldata.professions[prof]
	if satisfy_progress_reqs == true:
		for i in prof.reqs:
			if i.code == 'stat' && i.stat in ['physics','wits','charm','sexuals']:
				self.set(i.stat, i.value)
	if professions.has(prof.code):
		return "Already has this profession"
	professions.append(prof.code)
	parent.add_stat_bonuses(prof.statchanges)
	for i in prof.skills:
		parent.learn_skill(i)
	for i in prof.combatskills:
		parent.learn_c_skill(i)
	for i in prof.traits:
		parent.add_trait(i)
	parent.recheck_effect_tag('recheck_class')

func check_skill_prof(skill):
	for i in professions:
		var tempprof = Skilldata.professions[i]
		if tempprof.skills.has(skill):
			return true
	return false

#tasks
func assign_to_task(taskcode, taskproduct, iterations = -1):
	#remove existing work
	remove_from_task()
	if taskcode == '':
		work = ''
		return
	var task = races.tasklist[taskcode]
	#check if task is existing and add slave to it if it does
	var taskexisted = false
	for i in game_party.active_tasks:
		if i.code == taskcode && i.product == taskproduct:
			taskexisted = true
			i.workers.append(self.id)
			work = i.code
	
	workproduct = taskproduct
	if taskexisted == true:
		return
	#make new task if it didn't exist
	var dict = {code = taskcode, product = taskproduct, progress = 0, threshhold = task.production[taskproduct].progress_per_item, workers = [], iterations = iterations, messages = [], mod = task.mod}
	dict.workers.append(self.id)
	work = taskcode
	game_party.active_tasks.append(dict)
	game_party.emit_signal("task_added")

func remove_from_task(remember = false):
	if work != '':
		for i in game_party.active_tasks:
			if i.code == work:
				i.workers.erase(self.id)
	if remember == true && work != 'travel':
		previous_work = work
	work = ''

func return_to_task():
	assign_to_task(previous_work, workproduct)
	previous_work = ''

func get_work():
	return work

func work_tick():
	var currenttask
	for i in game_party.active_tasks:
		if i.workers.has(self.id):
			currenttask = i
	
	if currenttask == null:
		work = ''
		parent.rest_tick()
		return
	
	if parent.statlist.is_uncontrollable() && !parent.has_profession('master'):
		if !messages.has("refusedwork"):
			globals.text_log_add('work', parent.get_short_name() + ": Refused to work")
			messages.append("refusedwork")
		return
	if parent.get_stat('obedience') > 0: #new work stat. If <= 0 and loyal/sub < 100, refuse to work
		parent.add_stat('obedience', -1)
		messages.erase("refusedwork")
	
	if parent.get_static_effect_by_code("work_rule_ration") != null:
		parent.food.food_consumption_rations = true
	
	if ['smith','alchemy','tailor','cooking'].has(currenttask.product):
		if game_res.craftinglists[currenttask.product].size() <= 0:
			if currenttask.messages.has('notask') == false:
				globals.text_log_add('crafting', parent.get_short_name() + ": No craft task for " + currenttask.product.capitalize() + ". ")
				currenttask.messages.append('notask')
			parent.rest_tick()
			return
		else:
			var craftingitem = game_res.craftinglists[currenttask.product][0]
			currenttask.messages.erase("notask")
			if craftingitem.resources_taken == false:
				if globals.check_recipe_resources(craftingitem) == false:
					if currenttask.messages.has('noresources') == false:
						globals.text_log_add('crafting', parent.get_short_name() + ": Not Enough Resources for craft. ")
						currenttask.messages.append("noresources")
					parent.rest_tick()
					return
				else:
					globals.spend_resources(craftingitem)
					currenttask.messages.erase("noresources")
			work_tick_values(currenttask)
			craftingitem.workunits += races.get_progress_task(self, currenttask.code, currenttask.product)#
			make_item_sequence(currenttask, craftingitem)
	elif currenttask.product == 'building':
		if game_res.selected_upgrade.code == '':
			parent.rest_tick()
			if messages.has("noupgrade") == false:
				globals.text_log_add('upgrades', parent.get_short_name() + ": No task or upgrade selected for building. ")
				messages.append("noupgrade")
			return
		else:
			messages.erase('noupgrade')
			work_tick_values(currenttask)
			game_res.upgrade_progresses[game_res.selected_upgrade.code].progress += races.get_progress_task(self, currenttask.code, currenttask.product, true)#*(productivity/100)
			if game_res.upgrade_progresses[game_res.selected_upgrade.code].progress >= upgradedata.upgradelist[game_res.selected_upgrade.code].levels[game_res.selected_upgrade.level].taskprogress:
				if game_res.upgrades.has(game_res.selected_upgrade.code):
					game_res.upgrades[game_res.selected_upgrade.code] += 1
				else:
					game_res.upgrades[game_res.selected_upgrade.code] = 1
				input_handler.emit_signal("UpgradeUnlocked", upgradedata.upgradelist[game_res.selected_upgrade.code])
				globals.text_log_add('upgrades',"Upgrade finished: " + upgradedata.upgradelist[game_res.selected_upgrade.code].name)
				game_res.upgrade_progresses.erase(game_res.selected_upgrade.code)
				game_res.selected_upgrade.code = ''
	else:
		work_tick_values(currenttask)
		currenttask.progress += races.get_progress_task(self, currenttask.code, currenttask.product, true)#*(get_stat('productivity')*get_stat(currenttask.mod)/100)
		while currenttask.threshhold <= currenttask.progress:
			currenttask.progress -= currenttask.threshhold
			if races.tasklist[currenttask.code].production[currenttask.product].item == 'gold':
				game_res.money += 1
			else:
				game_res.materials[races.tasklist[currenttask.code].production[currenttask.product].item] += 1

func work_tick_values(currenttask):
	var workstat = races.tasklist[currenttask.code].workstat
	if !parent.has_status('no_working_bonuses'): 
		set(workstat, get(workstat) + 0.06)
		base_exp += 1

func make_item_sequence(currenttask, craftingitem):
	if craftingitem.workunits >= craftingitem.workunits_needed:
		globals.make_item(craftingitem)
		if Items.recipes[craftingitem.code].resultitemtype != 'material' && randf() < 0.25:
			input_handler.get_person_for_chat(currenttask.workers, 'item_created')
		craftingitem.workunits -= craftingitem.workunits_needed
		if craftingitem.repeats != 0:
			if globals.check_recipe_resources(craftingitem) == true:
				globals.spend_resources(craftingitem)
				if craftingitem.workunits >= craftingitem.workunits_needed:
					make_item_sequence(currenttask, craftingitem)
			else:
				if currenttask.messages.has('noresources') == false:
					globals.text_log_add('crafting', parent.get_short_name() + ": " + "Not Enough Resources for craft. ")
					currenttask.messages.append("noresources")
