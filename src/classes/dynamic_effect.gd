extends base_effect
class_name dynamic_effect
#this is satic effect type that is always applied but self atomic effect values are not fixed on applying but are depending on state of applied character
#can be used 'as is' or as proxy effect to add triggered effects
#sub-effects dependin on args may have unexpected behviour
#be aware of possible infinite loops of rechhecking (f.e. 'if stat > X another_stat += Y' may be safe and may be not and 'if stat > X stat += Y' is always broken)


func _init(caller).(caller):
	pass

func apply():
	is_applied = true
	recheck()

func remove():
	if !is_applied: return
	.remove()
	for e in sub_effects:
		var t = effects_pool.get_effect_by_id(e)
		t.remove()
	sub_effects.clear()
	is_applied = false

func serialize():
	var tmp = .serialize()
	tmp['type'] = 'dynamic'
	return tmp


func recheck():
	if !is_applied: return
	var tres = false
	var obj = get_applied_obj()
	var old_args = args.duplicate()
	calculate_args()
	for i in range(args.size()):
		if args[i] == null:
			args[i] = old_args[i]
			continue
		if args[i] != old_args[i]: 
			tres = true
			break
	if tres:
		atomic.clear()
		for a in template.atomic:
			var tmp := atomic_effect.new(a, id)
			tmp.resolve_template()
			#tmp.apply_template(obj)
			obj.apply_atomic(tmp.template)
			atomic.push_back(tmp.template)
		sub_effects.clear()
		for e in template.sub_effects:
			var tmp = effects_pool.e_createfromtemplate(e, id)
			#tmp.calculate_args()
			sub_effects.push_back(effects_pool.add_effect(tmp))
			pass
		for eff in sub_effects:
			obj.apply_effect(eff)
		setup_siblings()
		buffs.clear()
		for e in template.buffs:
			var tmp = Buff.new(id)
			tmp.createfromtemplate(e)
			tmp.calculate_args()
			buffs.push_back(tmp)


