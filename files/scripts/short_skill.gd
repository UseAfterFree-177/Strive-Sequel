extends Reference
class_name S_Skill

var code
var template

var type

var is_drain = false
var ability_type
var tags
var value = []
var long_value = []
var damagestat = []
var receiver = []
var manacost
var energycost
var goldcost
var target_range
var target_number
var damage_type
var damagesrc
var repeat

var chance
var evade
var critchance
var armor_p
var caster
var target
var hit_res

var effects = []
var process_value

func _init():
	caster = null
	target = null
	target_range = 'any'
	target_number = 'single'
	damage_type = 'direct'
	goldcost = 0
	pass

func clone():
	return dict2inst(inst2dict(self))



func createfromskill(s_code):
	template = Skilldata.skilllist[s_code]
	code = s_code
	type = template.type
	ability_type = template.ability_type
	tags = template.tags.duplicate()
	manacost = template.manacost
	energycost = template.energycost
	if template.has('goldcost'):
		goldcost = template.goldcost
	if template.has('target_range'):
		target_range = template.target_range
	if template.has('target_number'):
		target_number = template.target_number
	if template.has('damage_type'):
		damage_type = template.damage_type
	
	if typeof(template.value[0]) == TYPE_ARRAY:
		long_value = template.value.duplicate()
		damagestat = template.damagestat.duplicate()
	else:
		long_value.push_back(template.value.duplicate())
		if template.has('damagestat'):
			damagestat.push_back(template.damagestat)
		else:
			damagestat.push_back('hp')
	if template.has('receiver'):
		if typeof(template.receiver) == TYPE_ARRAY:
			receiver = template.receiver.duplicate()
		else:
			for i in range(long_value.size()):
				receiver.push_back(template.receiver)
	else:
		for i in range(long_value.size()):
			receiver.push_back('target')

	for e in template.effects:
		var eff = effects_pool.e_createfromtemplate(e, self)
		apply_effect(effects_pool.add_effect(eff))
	if template.has('repeat'):
		repeat = template.repeat
	else:
		repeat = 1
	if template.has('is_drain'):
		is_drain = true
	
#	if template.keys().has('chance'):
#		chance = template.chance
#	else:
#		chance = caster.hitrate
#	if template.keys().has('critchance'):
#		critchance = template.critchance
#	else:
#		critchance = caster.critchance
#	if template.keys().has('evade'):
#		evade = template.evade
#	else:
#		evade = target.evasion
#	if template.keys().has('armor_p'):
#		armor_p = template['armor_p']
#	else:
#		armor_p = caster.armorpenetration

func process_check(check:Array):
	var op1 = check[0]
	var op2 = check[2]
	if typeof(op1) == TYPE_STRING:
		op1 = get(op1)
	if typeof(op2) == TYPE_STRING && check[1] != 'has':
		op2 = get(op2)
	return input_handler.operate(check[1], op1, op2)
	pass

func setup_caster(c):
	caster = c
	if type == 'combat':
		chance = caster.hitrate
		critchance = caster.critchance
		armor_p = caster.armorpenetration
	else:
		chance = 100
		critchance = 0
		armor_p = 0

func setup_target(t):
	target = t
	if type == 'combat':
		evade = target.evasion
	else:
		evade = 0

func setup_final():
	if template.keys().has('chance'):
		chance = template.chance
		if typeof(chance) == TYPE_ARRAY:
			chance = input_handler.calculate_number_from_string_array(chance, caster, target)
	if template.keys().has('evade'):
		evade = template.evade
		if typeof(evade) == TYPE_ARRAY:
			evade = input_handler.calculate_number_from_string_array(evade, caster, target)
	if template.keys().has('armor_p'):
		armor_p = template.armor_p
		if typeof(armor_p) == TYPE_ARRAY:
			armor_p = input_handler.calculate_number_from_string_array(armor_p, caster, target)
	if template.keys().has('critchance'):
		critchance = template.critchance
		if typeof(critchance) == TYPE_ARRAY:
			critchance = input_handler.calculate_number_from_string_array(critchance, caster, target)


func hit_roll():
	if type == 'social':
		hit_res = variables.RES_HIT
		return
	var prop = chance - evade
	if prop < randf()*100 && caster.combatgroup != target.combatgroup:
		hit_res = variables.RES_MISS
	elif critchance < randf()*100 || caster.combatgroup == target.combatgroup:
		hit_res = variables.RES_HIT
	else:
		hit_res = variables.RES_CRIT

func apply_atomic(tmp):
	match tmp.type:
		'stat_add':
			if tmp.stat == 'value':
				for i in range(value.size()): 
					if damagestat[i] in variables.dmg_mod_list:
						value[i] += tmp.value
				pass
			else: set(tmp.stat, get(tmp.stat) + tmp.value)
		'stat_mul':
			if tmp.stat == 'value':
				for i in range(value.size()): 
					if damagestat[i] in variables.dmg_mod_list:
						value[i] *= tmp.value
				pass
			else: set(tmp.stat, get(tmp.stat) * tmp.value)
		'stat_set':
			if tmp.stat == 'value':
				for i in range(value.size()): 
					if damagestat[i] in variables.dmg_mod_list:
						value[i] = tmp.value
				pass
			else: set(tmp.stat, tmp.value)

#old code
#func apply_effect(code, trigger):
#	var tmp = Effectdata.effect_table[code]
#	var rec
#	var res = true
#	if tmp.trigger != trigger: return
#	for cond in tmp.conditions:
#		match cond.target:
#			'skill':
#				match cond.check:
#					'type': res = res and (skilltype == cond.value)
#					'tag': res = res and tags.has(cond.value)
#					'result': res = res and (hit_res & cond.value != 0)
#			'caster':
#				res = res and input_handler.requirementcombatantcheck(cond.value, caster)
#			'target':
#				res = res and input_handler.requirementcombatantcheck(cond.value, target)
#			'chance':
#				res = res and (randf()*100 < cond.value)
#	if !res: return
#	for ee in tmp.effects:
#			var eee
#			if typeof(ee) == TYPE_STRING: eee = Effectdata.atomic[ee].duplicate()
#			else: eee = ee.duplicate()
#			#convert effect to constant form
#			if eee.type == 'skill':
#				eee.type = eee.new_type
#				eee.value = get(eee.value) * eee.mul
#			if eee.type == 'caster':
#				eee.type = eee.new_type
#				eee.value = caster.get(eee.value) * eee.mul
#			if eee.type == 'target':
#				eee.type = eee.new_type
#				eee.value = target.get(eee.value) * eee.mul
#
#			match eee.target:
#				'caster':
#					rec = caster
#				'target':
#					rec = target
#				'skill':
#					rec = self
#			rec.apply_atomic(eee)

func apply_effect(eff):
	var obj = effects_pool.get_effect_by_id(eff)
	match obj.template.type:
		'trigger':
			obj.set_args('skill', self)
			effects.push_back(obj.id)
			obj.apply()
			pass
		'oneshot':
			obj.applied_obj = self
			obj.apply()
			pass


func remove_effects():
	for e in effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.remove()
		pass

func process_event(ev):
	for e in effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.set_args('skill', self)
		eff.process_event(ev)
	# NB !! move this part to combat
#	if caster != null:
#		for eff in caster.triggered_effects:
#			var obj = effects_pool.get_effect_by_id(eff)
#			if !eff.req_skill: continue
#			obj.set_args('skill', self)
#			obj.process_event(ev)

#	if target != null:
#		for eff in target.triggered_effects:
#			var obj = effects_pool.get_effect_by_id(eff)
#			if !eff.req_skill: continue
#			obj.set_args('skill', self)
#			obj.process_event(ev)


func resolve_value(check_m):
	value.resize(long_value.size())
	for i in range(long_value.size()):
		var endvalue = input_handler.calculate_number_from_string_array(long_value[i], caster, target)
		if !(variables.dmg_mod_list.has(damagestat[i])): 
			value[i] = endvalue
			continue
		var rangetype
		if target_range == 'weapon':
			if caster.gear.rhand == null:
				rangetype = 'melee'
			else:
				var weapon = state.items[caster.gear.rhand]
				rangetype = weapon.weaponrange
		if rangetype == 'melee' && input_handler.FindFighterRow(caster) == 'backrow' && !check_m:
			endvalue /= 2
		value[i] = endvalue
	process_value = value[0]

func calculate_dmg():
	if damage_type == 'weapon':
		damagesrc = variables.S_PHYS
	elif damage_type == 'fire':
		damagesrc = variables.S_FIRE
	elif damage_type == 'water':
		damagesrc = variables.S_WATER
	elif damage_type == 'air':
		damagesrc = variables.S_AIR
	elif damage_type == 'earth':
		damagesrc = variables.S_EARTH
	if hit_res == variables.RES_CRIT:
		for i in range(value.size()): 
			if variables.dmg_mod_list.has(damagestat[i]):
				value[i] *= caster.critmod
	var reduction = 0
	if ability_type == 'skill':
		reduction = max(0, target.armor - armor_p)
	elif ability_type == 'spell':
		reduction = max(0, target.mdef)
	if !tags.has('noreduce'):#tag for all reduction-ignoring skills i.e heals and others
		for i in range(value.size()): 
			if variables.dmg_mod_list.has(damagestat[i]):
				 value[i] *= (float(100 - reduction)/100.0)
	if ['fire','water','air','earth'].has(damage_type):
		for i in range(value.size()): 
			if variables.dmg_mod_list.has(damagestat[i]):
				 value[i] *= ((100 - target['resist' + damage_type])/100.0)
	for v in value: v = round(v)
