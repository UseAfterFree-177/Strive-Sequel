extends Control
#warning-ignore-all:function_conflicts_variable

var parser = load("res://src/sexdescriptions.gd").new()

var participants = []
var givers = []
var takers = []
var turns = 0
var actions = []
var ongoingactions = []
var location
var selectmode = 'normal'
var npcs = []
var aiobserve = false #True - player will not be picked by AI

var takercategories = ['cunnilingus','rimjob','handjob','titjob','tailjob','blowjob']
var analcategories = ['assfingering','rimjob','missionaryanal','doggyanal','lotusanal','revlotusanal','doubledildoass','inerttaila','analvibrator','enemaplug','insertinturnsass']
var punishcategories = []#globals.punishcategories
var penetratecategories = ['missionary','missionaryanal','doggy','doggyanal','lotus','lotusanal','revlotus','revlotusanal','doubledildo','doubledildoass','inserttailv','inserttaila','tribadism','frottage']


var filter = ['nosehook','relaxinginsense','facesit','afacesit','grovel','enemaplug']

var statuseffects = ['tied', 'subdued', 'drunk', 'resist', 'sexcrazed']


var statsicons = {
lub1 = load("res://assets/images/sexicons/lub1.png"),
lub2 = load("res://assets/images/sexicons/lub2.png"),
lub3 = load("res://assets/images/sexicons//lub3.png"),
lub4 = load("res://assets/images/sexicons/lub4.png"),
lub5 = load("res://assets/images/sexicons/lub5.png"),
lust1 = load("res://assets/images/sexicons/lust1.png"),
lust2 = load("res://assets/images/sexicons/lust2.png"),
lust3 = load("res://assets/images/sexicons//lust3.png"),
lust4 = load("res://assets/images/sexicons/lust4.png"),
lust5 = load("res://assets/images/sexicons/lust5.png"),
sens1 = load("res://assets/images/sexicons/sens1.png"),
sens2 = load("res://assets/images/sexicons/sens2.png"),
sens3 = load("res://assets/images/sexicons/sens3.png"),
sens4 = load("res://assets/images/sexicons/sens4.png"),
sens5 = load("res://assets/images/sexicons/sens5.png"),
stress1 = load("res://assets/images/gui/obed_bad.png"),
stress2 = load("res://assets/images/gui/obed_med.png"),
stress3 = load("res://assets/images/gui/obed_good.png")
}


var selectedcategory = 'caress'
var categories = {caress = [], fucking = [], tools = [], SM = [], humiliation = [], other = []}

var secondactorcounter = {}

class member:
	var name
	var person
	var mood
	var submission
	var loyalty
	var lust = 0 setget lust_set
	var sens = 0 setget sens_set
	var sensmod = 1.0
	var lewd = 0 setget lewd_set
	var lewdmod = 1.0
	var role
	var sex
	var orgasms = 0
	var lastaction
	var request
	var requestsdone = 0
	
	var number = 0
	var sceneref
	
	var horny = 0 setget horny_set
	var hornymod = 1.0
	
	
	var svagina = 0
	var smouth = 0
	var sclit = 0
	var sbreast = 0
	var spenis = 0
	var sanus = 0
	var activeactions = []
	
	var performed_actions = {}
	
	var orgasm = false
	
	var effects = []
	
	var subduedby = []
	var subduing
	
	var energy = 100
	
	var sex_traits = []
	
	
	var vagina
	var penis
	var clit
	var breast
	var feet
	var acc1
	var acc2
	var acc3
	var acc4
	var acc5
	var acc6
	var mouth
	var anus
	var tail
	var strapon
	var nipples
	var posh1
	var mode = 'normal'
	var limbs = true
	var consent = true
	var npc = false
	
	
	var actionshad = {addtraits = [], removetraits = [], samesex = 0, samesexorgasms = 0, oppositesex = 0, oppositesexorgasms = 0, punishments = 0, group = 0}
	
	func lust_set(value):
		lust = min(value, 1000)
	
	func sens_set(value):
		var change = value - sens
		sens += change*sensmod
		if sens >= 1000:
			if ((lastaction.givers.has(self) && lastaction.scene.givertags.has('noorgasm')) || (lastaction.takers.has(self) && lastaction.scene.takertags.has('noorgasm'))):
				return
			sens = 0
			orgasm()
	
	func lewd_set(value):
		var change = value - lewd
		lewd += change*lewdmod
	
	func horny_set(value):
		var change = value - horny
		horny += change*hornymod
	
	func orgasm():
		var text = ''
		orgasm = true
		if person.sexexp.orgasms.has(lastaction.scene.code):
			person.sexexp.orgasms[lastaction.scene.code] += 1
		else:
			person.sexexp.orgasms[lastaction.scene.code] = 1
		for k in lastaction.givers + lastaction.takers:
			if self != k:
				if person.sexexp.orgasmpartners.has(k.person.id):
					person.sexexp.orgasmpartners[k.person.id] += 1
				else:
					person.sexexp.orgasmpartners[k.person.id] = 1
		
		var scene
		var temptext = ''
		var penistext = ''
		var vaginatext = ''
		var anustext = ''
		orgasms += 1
		person.metrics.orgasm += 1
		if sceneref.participants.size() == 2 && person.professions.has("master"):
			if person.traits.has("Monogamous") && (sceneref.participants[0].person.professions.has("master") || sceneref.participants[1].person.professions.has("master")):
				person.loyal += rand_range(1.4,5.6)
			else:
				person.loyal += rand_range(1,4)
		elif person.professions.has("master"):
			person.loyal += rand_range(1,2)
		#anus in use, find scene
		if anus != null:
			scene = anus
			for i in scene.givers:
				globals.addrelations(person, i.person, rand_range(30,50))
			#anus in giver slot
			if scene.givers.find(self) >= 0:
				if randf() < 0.4:
					anustext = "[name1] feel[s/1] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him1] and [his1]"
				else:
					anustext = "[names1]"
				if scene.scene.takerpart == 'penis':
					anustext += " [anus1] {^squeezes:writhes around:clamps down on} [names2] [penis2] as [he1] reach[es/1] {^climax:orgasm}."
				else:
					anustext += " [anus1] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he1] reach[es/1] {^climax:orgasm}."
				anustext = sceneref.decoder(anustext, [self], scene.takers)
			#anus is in taker slot
			elif scene.takers.find(self) >= 0:
				if randf() < 0.4:
					anustext = "[name2] feel[s/2] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him2] and [his2]"
				else:
					anustext = "[names2]"
				if scene.scene.giverpart == 'penis':
					anustext += " [anus2] {^squeezes:writhes around:clamps down on} [names1] [penis1] as [he2] reach[es/2] {^climax:orgasm}."
				else:
					anustext += " [anus2] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he2] reach[es/2] {^climax:orgasm}."
				anustext = sceneref.decoder(anustext, scene.givers, [self])
			#no default conditon
		#vagina present
		if person.vagina != 'none':
			#vagina in use, find scene
			if vagina != null:
				scene = vagina
				for i in scene.givers:
					globals.addrelations(person, i.person, rand_range(30,50))
				#vagina in giver slot
				if scene.givers.find(self) >= 0:
					if randf() < 0.4:
						vaginatext = "[name1] feel[s/1] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him1] and [his1]"
					else:
						vaginatext = "[names1]"
					if scene.scene.takerpart == 'penis':
						vaginatext += " [pussy1] {^squeezes:writhes around:clamps down on} [names2] [penis2] as [he1] reach[es/1] {^climax:orgasm}."
					else:
						vaginatext += " [pussy1] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he1] reach[es/1] {^climax:orgasm}."
					vaginatext = sceneref.decoder(vaginatext, [self], scene.takers)
				#vagina is in taker slot
				elif scene.takers.find(self) >= 0:
					if randf() < 0.4:
						vaginatext = "[name2] feel[s/2] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him2] and [his2]"
					else:
						vaginatext = "[names2]"
					if scene.scene.giverpart == 'penis':
						vaginatext += " [pussy2] {^squeezes:writhes around:clamps down on} [names1] [penis1] as [he2] reach[es/2] {^climax:orgasm}."
					else:
						vaginatext += " [pussy2] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he2] reach[es/2] {^climax:orgasm}."
					vaginatext = sceneref.decoder(vaginatext, scene.givers, [self])
				#no default conditon
		#penis present
		if person.penis_size != 'none':
			#penis in use, find scene
			if penis != null:
				scene = penis
				for i in scene.takers:
					globals.addrelations(person, i.person, rand_range(30,50))
				#penis in giver slot
				if scene.givers.find(self) >= 0:
					if randf() < 0.4:
						penistext = "[name1] feel[s/1] {^a wave of:an intense} {^pleasure:euphoria} {^run through:course through:building in} [his1] [penis1] and [his1]"
					else:
						penistext = "[name1] {^thrust:jerk}[s/1] [his1] hips forward and a {^thick :hot :}{^jet:load:batch} of"
					if scene.scene.takerpart == '':
						penistext += " {^semen:seed:cum} {^pours onto:shoots onto:falls to} the {^ground:floor} as [he1] ejaculate[s/1]."
					elif ['anus','vagina','mouth'].has(scene.scene.takerpart):
						if scene.scene.get('takerpart2') && scene.scene.givers[1] == self:
							temptext = scene.scene.takerpart2.replace('anus', '[anus2]').replace('vagina','[pussy2]')
						else:
							temptext = scene.scene.takerpart.replace('anus', '[anus2]').replace('vagina','[pussy2]')
							if scene.scene.takerpart == 'vagina':
								for i in scene.takers:
									if sceneref.impregnationcheck(i.person, person) == true:
										globals.impregnate(i.person, person)
						penistext += " {^semen:seed:cum} {^pours:shoots:pumps:sprays} into [names2] " + temptext + " as [he1] ejaculate[s/1]."
					elif scene.scene.takerpart == 'nipples':
						penistext += " {^semen:seed:cum} fills [names2] hollow nipples. "
					elif scene.scene.takerpart == 'penis':
						penistext += " {^semen:seed:cum} {^pours:shoots:sprays}, covering [names2] [penis2]. "
					penistext = sceneref.decoder(penistext, [self], scene.takers)
				#penis in taker slot
				elif scene.takers.find(self) >= 0:
					if randf() < 0.4:
						penistext = "[name2] feel[s/2] {^a wave of:an intense} {^pleasure:euphoria} {^run through:course through:building in} [his2] [penis2] and [his2]"
					else:
						penistext = "[name2] {^thrust:jerk}[s/2] [his2] hips forward and a {^thick :hot :}{^jet:load:batch} of"
					if scene.scene.code in ['handjob','titjob']:
						penistext += " {^sticky:white:hot} {^semen:seed:cum} {^sprays onto:shoots all over:covers} [names1] face[/s1] as [he2] ejaculate[s/2]."
					elif scene.scene.code == 'tailjob':
						penistext += " {^sticky:white:hot} {^semen:seed:cum} {^sprays onto:shoots all over:covers} [names1] tail[/s1] as [he2] ejaculate[s/2]."
					elif scene.scene.giverpart == '':
						penistext += " {^semen:seed:cum} {^pours onto:shoots onto:falls to} the {^ground:floor} as [he2] ejaculate[s/2]."
					elif scene.scene.giverpart == 'penis':
						penistext += " {^semen:seed:cum} {^pours:shoots:sprays}, covering [names1] [penis1]. "
					elif ['anus','vagina','mouth'].has(scene.scene.giverpart):
						temptext = scene.scene.giverpart.replace('anus', '[anus1]').replace('vagina','[pussy1]')
						penistext += " {^semen:seed:cum} {^pours:shoots:pumps:sprays} into [names1] " + temptext + " as [he2] ejaculate[s/2]."
						if scene.scene.giverpart == 'vagina':
							for i in scene.givers:
								if sceneref.impregnationcheck(i.person, person) == true:
									globals.impregnation(i.person, person)
					penistext = sceneref.decoder(penistext, scene.givers, [self])
			#orgasm without penis, secondary ejaculation
			else:
				if randf() < 0.4:
					penistext = "[name2] {^twist:quiver:writhe}[s/2] in {^pleasure:euphoria:ecstacy} as"
				else:
					penistext = "[name2] {^can't hold back any longer:reach[es/2] [his2] limit} and"
				penistext += " {^a jet of :a rope of :}{^semen:cum} {^fires:squirts:shoots} from {^the tip of :}[his2] {^neglected :throbbing ::}[penis2]."
				penistext = sceneref.decoder(penistext, null, [self])
		if vaginatext != '' || anustext != '' || penistext != '':
			text  += vaginatext + " " + anustext + " " + penistext
		#final default condition
		else:
			if randf() < 0.4:
				temptext = "[name2] feel[s/2] {^a sudden :an intense ::}{^jolt of electricity:heat:wave of pleasure} and [his2]"
			else:
				temptext = "[names2]"
			temptext += " {^entire :whole :}body {^twists:quivers:writhes} in {^pleasure:euphoria:ecstacy} as [he2] reach[es/2] {^climax:orgasm}."
			text += sceneref.decoder(temptext, null, [self])
		
		
		if lastaction.scene.code in sceneref.punishcategories && lastaction.takers.has(self):
			if randf() >= 0.85 || person.effects.has("entranced"):
				actionshad.addtraits.append("Masochist")
	#	if member.lastaction.scene.code in punishcategories && member.lastaction.givers.has(member) && member.person.asser >= 60:
	#		if randf() >= 0.85 || member.person.effects.has("entranced"):
	#			member.actionshad.addtraits.append("Dominant")
		if lastaction.scene.code in sceneref.analcategories && (lastaction.takers.has(self) || lastaction.scene.code == 'doubledildoass'):
			if randf() >= 0.85 || person.effects.has('entranced'):
				actionshad.addtraits.append("Enjoys Anal")
		if sceneref.isencountersamesex(lastaction.givers, lastaction.takers, self) == true:
			actionshad.samesexorgasms += 1
		else:
			actionshad.oppositesexorgasms += 1
		
		
		#return 
		yield(sceneref.get_tree().create_timer(0.1), "timeout")
		sceneref.get_node("Panel/sceneeffects").bbcode_text += "[color=#ff5df8]" + text + "[/color]\n"
	
	
	func actioneffect(values, scenedict):
		var sensinput = 0
		var hornyinput = 0
		var sens_mod = 1
		var horny_mod = 1
		
		lastaction = scenedict
		person.sexuals += 0.05
		if values.has('sens'):
			sensinput = values.sens
		if values.has('horny'):
			hornyinput = values.horny
		
		if horny < 100:
			sens_mod -= 0.5
		
		
		
		if performed_actions.has(scenedict.scene.code):
			sens_mod -= 0.05*performed_actions[scenedict.scene.code]
			performed_actions[scenedict.scene.code] += 1
		else:
			performed_actions[scenedict.scene.code] = 1
		
		if sceneref.isencountersamesex(scenedict.givers, scenedict.takers, self) == true && sex_traits.has("bisexual") == false:
			sens_mod -= 0.33
			horny_mod -= 0.33
		
		if scenedict.scene.code in globals.punishcategories:
			if scenedict.givers.has(self):
				person.asser += rand_range(1,2)
			else:
				person.asser -= rand_range(1,2)
		
		var position
		var seek_group
		var self_group
		if scenedict.givers.has(self):
			self_group = 'giver'
			seek_group = 'taker'
		else:
			self_group = 'taker'
			seek_group = 'giver'
		var partner_skill = 0
		for i in scenedict[seek_group+'s']:
			if i.person.sexuals + i.person.sexuals_bonus > partner_skill:
				partner_skill = i.person.sexuals + i.person.sexuals_bonus
			if i.person.traits.has("undead") && sex_traits.has('omnisexual') == false:
				sens_mod -= 0.5
				horny_mod -= 0.5
			for k in i.sex_traits:
				var trait = Traitdata.sex_traits[k]
				if trait.trigger_side != 'partner' || checkreqs(trait.reqs, seek_group, scenedict) == false :
					continue
				for j in trait.effects:
					match j.effect:
						'sens_bonus':
							input_handler.math(j.operant, sens_mod, j.value)
						'horny_bonus':
							input_handler.math(j.operant, horny_mod, j.value)
		
		sens_mod += partner_skill/200
		
		
		
		if values.has('tags'):
			if values.tags.has('punish'):
				if (person.obedience < 90 || mode == 'forced') && (!person.traits.has('Masochist') && !person.traits.has('Likes it rough') && !person.traits.has('Sex-crazed')):
					for i in scenedict.givers:
						globals.addrelations(person, i.person, -rand_range(5,10))
					person.obedience += values.obed
					person.stress += values.stress
					if person.effects.has("captured") && randf() >= values.obed/2:
						person.effects.captured.duration -= 1
				else:
					if person.asser < 35 && randf() < 0.1:
						actionshad.addtraits.append('Likes it rough')
					if !person.traits.has('Masochist') && !person.traits.has('Sex-crazed'):
						if values.has('stress') == false:
							values.stress = rand_range(2,6)
						person.stress += values.stress
			if values.tags.has('group'):
				actionshad.group += 1
		
		
		for i in sex_traits:
			var trait = Traitdata.sex_traits[i]
			if trait.trigger_side != 'self' || checkreqs(trait.reqs, self_group, scenedict) == false:
				continue
			
			for k in trait.effects:
				match k.effect:
					'sens_bonus':
						input_handler.math(k.operant, sens_mod, k.value)
					'horny_bonus':
						input_handler.math(k.operant, horny_mod, k.value)
			
		
#		if values.has('obed') && values.obedience > 0 && effects.has('resist'):
#			if person.obedience >= 90 && person.professions.has("master"):
#				var text = ''
#				text += "\n[color=green]Afterward, {^[name2] seems to have:it looks as though [name2] [has2]} {^learned [his2] lesson:reformed [his2] rebellious ways:surrendered} and shows {^complete:total} {^submission:obedience:compliance}"
#				if person.traits.find("Masochist") >= 0:
#					text += ", but there is also {^an unusual:a strange} {^flash:hint:look} of desire in [his2] eyes"
#				text += '. [/color]'
#				#yield(sceneref.get_tree().create_timer(0.1), "timeout")
#				effects.erase('resist')
#				sceneref.get_node("Panel/sceneeffects").bbcode_text += sceneref.decoder(text, scenedict.givers, scenedict.takers) + '\n'
		#sceneref.get_node("Panel/sceneeffects").bbcode_text += str(sens_mod*100) + "%"
		self.sens += sensinput*max(0.1, sens_mod)
		self.horny += hornyinput*max(0.1, horny_mod)
	
	func checkreqs(reqs, group, scene):
		var check = true
		for i in reqs:
			if i.has('orflag'):
				check = check or valuecheck(i, group, scene)
			else:
				check = check and valuecheck(i, group, scene)
			if check == false:
				break
		return check
	
	func valuecheck(dict, group, scene):#effect_exists action_tag action_effect_tag
		match dict.code:
			'effect_exists':
				return effects.has(dict.value)
			'action_tag':
				return scene.scene.get(group+'tags').has(dict.value)
			'partner_check':
				return false
	

func dog():
	var person = globals.newslave(globals.allracesarray[rand_range(0,globals.allracesarray.size())], 'adult', 'male')
	var newmember = member.new()
	newmember.sceneref = self
	person.obedience = 90
	person.lewdness = 70
	person.penistype = 'canine'
	person.name = "Dog " + str(secondactorcounter.dog)
	person.penis_size = input_handler.weightedrandom([['average',1],['big',1]])
	person.asser = rand_range(65, 100)
	person.unique = 'dog'
	person.imageportait = null
	for i in categories.fucking:
		person.sexexp.actions[i.code] = 15
	newmember.loyalty = person.loyal
	newmember.submission = person.obedience
	newmember.person = person
	newmember.sex = person.sex
	newmember.name = person.name_short()
	newmember.lewd = 100
	newmember.limbs = false
	participants.append(newmember)

func horse():
	var person = globals.newslave(globals.allracesarray[rand_range(0,globals.allracesarray.size())], 'adult', 'male')
	var newmember = member.new()
	newmember.sceneref = self
	person.obedience = 90
	person.lewdness = 70
	person.penistype = 'equine'
	person.asser = rand_range(65, 100)
	person.name = "Horse " + str(secondactorcounter.horse)
	person.height = 'tall'
	person.penis_size = 'big'
	person.unique = 'horse'
	person.imageportait = null
	for i in categories.fucking:
		person.sexexp.actions[i.code] = 15
	newmember.loyalty = person.loyal
	newmember.submission = person.obedience
	newmember.person = person
	newmember.sex = person.sex
	newmember.name = person.name_short()
	newmember.lewd = 100
	newmember.limbs = false
	participants.append(newmember)


func _ready():
	for i in globals.dir_contents('res://src/actions'):
		if i.find('.remap') >= 0:
			continue
		var newaction = load(i).new()
		categories[newaction.category].append(newaction)
	for i in get_node("Panel/HBoxContainer").get_children():
		i.connect("pressed",self,'changecategory',[i.get_name()])
	
	filter = []#globals.state.actionblacklist
	
	var i = 4
	if globals.CurrentScene == null:
		globals.AddItemToInventory(globals.CreateUsableItem("alcohol"))
		globals.AddItemToInventory(globals.CreateUsableItem("aphrodisiac"))
		while i > 0:
			i -= 1
			createtestdummy()
		turns = 20
		createtestdummy('resist')
		changecategory('caress')
		clearstate()
		
		rebuildparticipantslist()

func add_portrait_to_text(member):
	var newimage = Image.new()
	if !File.new().file_exists(member.person.imageportait):
		return
	newimage.load(member.person.imageportait)
	var subimage = ImageTexture.new()
	subimage.create_from_image(newimage)
	subimage.set_size_override(Vector2(24,24))
	$Panel/sceneeffects.add_image(subimage)

func _input(event):
	if !event is InputEventKey || is_visible_in_tree() == false:
		return
	var dict = {49 : 1, 50 : 2, 51 : 3, 52 : 4,53 : 5,54 : 6,55 : 7,56 : 8, 16777351 :1, 16777352 : 2, 16777353 : 3, 16777354 : 4, 16777355 : 5, 16777356: 6, 16777357: 7, 16777358: 8}
	if event.scancode in dict:
		var key = dict[event.scancode]
		if event.is_action_pressed(str(key)) == true && participants.size() >= key:
			if !givers.has(participants[key-1]) && !takers.has(participants[key-1]):
				$Panel/givetakepanel/givercontainer.get_child(key).emit_signal("pressed")
			else:
				$Panel/givetakepanel/receivercontainer.get_child(key).emit_signal("pressed")
	if event.is_action_pressed("F") && $Panel/passbutton.disabled == false:
		_on_passbutton_pressed()

var dummycounter = 0

func createtestdummy(type = 'normal'):
	var person = Slave.new()
	person.create('random', 'random', 'random')
	var newmember = member.new()
	newmember.sceneref = self
	person.mods['hollownipples'] = 'hollownipples'
	#person.sex = 'male'
#	if type == 'resist':
#		person.consent = false
#	if participants.size() > 0:
#		person.sex = 'female'
#		globals.connectrelatives(participants[0].person, person, 'father')
	
#	newmember.loyalty = person.loyal
	newmember.submission = person.obedience
	newmember.person = person
	newmember.sex = person.sex
	newmember.name = person.get_short_name()
	newmember.lewd = 100
	newmember.number = dummycounter
	newmember.sex_traits = ['skilled_petting']
	dummycounter += 1
	
#	if person.consent == false && person.professions.has("master"):
#		newmember.effects.append('forced')
#	if person.obedience < 80 && person.professions.has("master"):
#		newmember.effects.append('resist')
	
	participants.append(newmember)


func startsequence(actors):
	participants.clear()
	show()
	secondactorcounter.clear()
	$Panel/sceneeffects.clear()
	get_node("Control").hide()
	for person in actors:
		var newmember = member.new()
		newmember.sceneref = self
#		for i in actors:
#			if person != i:
#				if person.sexexp.watchers.has(i.id):
#					person.sexexp.watchers[i.id] += 1
#				else:
#					person.sexexp.watchers[i.id] = 1
		#erson.lastinteractionday = globals.resources.day
		newmember.loyalty = person.loyal
		newmember.submission = person.obedience
		newmember.person = person
		newmember.sex = person.sex
		newmember.lust = person.lust*10
		newmember.sens = 0
		newmember.name = person.get_short_name()
		newmember.sex_traits = person.sex_traits
#		newmember.svagina = person.sensvagina
#		newmember.smouth = person.sensmouth
#		newmember.spenis = person.senspenis
#		newmember.sanus = person.sensanal
		newmember.lewd = 100
#		newmember.person.metrics.sex += 1
		participants.append(newmember)
#		if person.obedience < 80 && person.professions.has("master"):
#			newmember.effects.append('resist')
		if person.traits.has("Sex-crazed"):
			newmember.effects.append("sexcrazed")
	$Panel/aiallow.pressed = aiobserve
	get_node("Panel/sceneeffects").set_bbcode("You bring selected participants into your bedroom. ")
	
	var counter = 0
	for i in participants:
		#i.person.attention = 0
		i.number = counter
		counter += 1
	turns = variables.timeforinteraction
	changecategory('caress')
	clearstate()
	rebuildparticipantslist()


func clearstate():
	givers.clear()
	takers.clear()
	if givers.size() >= 1:
		givers.append(participants[0])

func changecategory(name):
	selectedcategory = name
	for i in get_node("Panel/HBoxContainer").get_children():
		if i.get_name() != name: i.set_pressed(false) 
		else: i.set_pressed(true)
	rebuildparticipantslist()

func rebuildparticipantslist():
	var newnode
	var effects
	if selectmode == 'ai':
		clearstate()
	for i in get_node("Panel/ScrollContainer/VBoxContainer").get_children() + get_node("Panel/GridContainer/GridContainer").get_children() + get_node("Panel/givetakepanel/givercontainer").get_children() + get_node("Panel/givetakepanel/receivercontainer").get_children() + $Panel/GridContainer2/GridContainer.get_children():
		if !i.get_name() in ['Panel', 'Button']:
			i.visible = false
			i.queue_free()
	for i in participants:
		newnode = get_node("Panel/ScrollContainer/VBoxContainer/Panel").duplicate()
		newnode.visible = true
		get_node("Panel/ScrollContainer/VBoxContainer").add_child(newnode)
		newnode.get_node("name").set_text(i.person.translate('[name]'))
		newnode.get_node("name").connect("pressed",self,"slavedescription",[i])
		newnode.set_meta("person", i)
		newnode.get_node("container/sex").set_texture(globals.sexicons[i.person.sex])
		newnode.get_node("container/sex").set_tooltip(i.person.sex)
		newnode.get_node('container/arousal').value = i.sens
		newnode.get_node("portrait").texture = globals.loadimage(i.person.icon_image)
		newnode.get_node("portrait").connect("mouse_entered",self,'showbody',[i])
		newnode.get_node("portrait").connect("mouse_exited",self,'hidebody')
		newnode.get_node("container/items").connect("pressed", self, "open_item_list", [i])
		
		if i.request != null:
			newnode.get_node('container/desire').show()
			newnode.get_node('container/desire').hint_tooltip = i.person.translate(requests[i.request])
		
		if i.horny >= 100:
			newnode.get_node("container/horny").show()
		
		for k in i.effects:
			newnode.get_node('container/' + k).visible = true
		
#		if ai.has(i):
#			newnode.get_node('name').set('custom_colors/font_color', Color(1,0.2,0.8))
#			newnode.get_node('name').hint_tooltip = 'Leads'
		
		newnode = get_node("Panel/givetakepanel/givercontainer/Button").duplicate()
		get_node("Panel/givetakepanel/givercontainer").add_child(newnode)
		if givers.find(i) >= 0:
			newnode.set_pressed(true)
		newnode.visible = true
		newnode.text = i.person.translate('[name]')
		newnode.set_meta("person", i)
		newnode.connect("pressed",self,'switchsides',[newnode, 'give'])
		newnode = get_node("Panel/givetakepanel/receivercontainer/Button").duplicate()
		get_node("Panel/givetakepanel/receivercontainer").add_child(newnode)
		if takers.find(i) >= 0:
			newnode.set_pressed(true)
		newnode.visible = true
		newnode.text = i.person.translate('[name]')
		newnode.set_meta("person", i)
		newnode.connect("pressed",self,'switchsides',[newnode, 'take'])
		
	var text = ''
	
	#check for double dildo scenes between participants
	var doubledildo = doubledildocheck()
	var actionarray = []
	
	
	for i in categories:
		for k in categories[i]:
			actionarray.append(k)
	
	
	actionarray.sort_custom(self, 'sortactions')
	
	var showactions = true
	var actionreplacetext = ''
	
	for i in givers:
		if i.effects.has('tied') :
			showactions = false
			actionreplacetext = i.person.translate("[name] is tied and can't act.")
		elif i.subduedby.size() > 0:
			showactions = false
			actionreplacetext = i.person.translate("[name] is struggling and can't act.")
		elif i.effects.has('resist'):
			showactions = false
			actionreplacetext = i.person.translate("[name] resists and won't follow any orders.")
		elif i.subduing != null && ((takers.size() > 0 && takers[0] != i.subduing) || takers.size() > 1 ) :
			showactions = false
			actionreplacetext = i.person.translate("[name] is busy holding down ") + i.subduing.person.translate("[name] \nand can only act on $him. ")
	
	var array = []
	var bottomrow =  ['rope', 'subdue', 'strapon']
	
	if showactions == true:
		for i in actionarray:
			i.givers = givers
			i.takers = takers
			var result = checkaction(i, doubledildo)
			if result[0] == 'false' || i.code in ['wait'] || (selectedcategory != i.category && !i.code in bottomrow ):
				continue
			if i.code in bottomrow :
				newnode = get_node("Panel/GridContainer2/GridContainer/Button").duplicate()
				get_node("Panel/GridContainer2/GridContainer").add_child(newnode)
			else:
				newnode = get_node("Panel/GridContainer/GridContainer/Button").duplicate()
				get_node("Panel/GridContainer/GridContainer").add_child(newnode)
			newnode.visible = true
			newnode.set_text(i.getname())
			newnode.hint_tooltip = i.getname()
			if result[0] == 'disabled':
				newnode.disabled = true
				newnode.hint_tooltip += ' - ' + result[1]
			
			newnode.connect("pressed",self,'startscene',[i])
			if i.canlast == true && newnode.disabled == false:
				newnode.get_node("continue").visible = true
				newnode.get_node("continue").connect("pressed",self,'startscenecontinue',[i])
			for j in ongoingactions:
				if j.scene.code == i.code && j.givers == i.givers && j.takers == i.takers:
					newnode.get_node("continue").pressed = true
		if selectedcategory == 'caress' && givers.size() >= 1 && givers[0].person.professions.has("master") == false && selectmode != 'ai':
			newnode = get_node("Panel/GridContainer2/GridContainer/Button").duplicate()
			get_node("Panel/GridContainer2/GridContainer").add_child(newnode)
			newnode.visible = true
			if givers.size() < 2:
				newnode.set_text(givers[0].person.translate("Let [name] Lead"))
			else:
				newnode.set_text("Let Selected Lead")
			newnode.connect("pressed",self,'activateai')
		elif selectmode == 'ai':
			newnode = get_node("Panel/GridContainer/GridContainer/Button").duplicate()
			get_node("Panel/GridContainer/GridContainer").add_child(newnode)
			newnode.visible = true
			newnode.set_text("Stop")
			newnode.connect("pressed",self,'activateai')
	else:
			newnode = Label.new()
			get_node("Panel/GridContainer/GridContainer").add_child(newnode)
			newnode.visible = true
			#newnode.disabled = true
			newnode.set_text(actionreplacetext)
	$Panel/GridContainer/GridContainer.move_child($Panel/GridContainer/GridContainer/Button, $Panel/GridContainer/GridContainer.get_child_count()-1)
	$Panel/GridContainer2/GridContainer.move_child($Panel/GridContainer2/GridContainer/Button, $Panel/GridContainer2/GridContainer.get_child_count()-1)
	for i in givers:
		text += '[color=yellow]' + i.name + '[/color], '
	if givers.size() == 0:
		text += '[...] '
	text += 'will do it ... to '
	for i in takers:
		text += '[color=aqua]' + i.name + '[/color], '
	if takers.size() == 0:
		text += "[...]"
	else:
		text = text.substr(0, text.length() -2)+ '. '
	text += "\n\n"
	for i in ongoingactions:
		text += decoder(i.scene.getongoingname(i.givers,i.takers), i.givers, i.takers) + ' [url='+str(ongoingactions.find(i))+'][Interrupt][/url]\n'
	
	if givers.size() == 0 && selectmode != 'ai':
		get_node("Panel/passbutton").set_disabled(true)
	else:
		get_node("Panel/passbutton").set_disabled(false)
	
	if selectmode == 'ai':
		$Panel/passbutton.set_text("Observe")
	else:
		$Panel/passbutton.set_text("Pass")
	
	get_node("TextureFrame/Label").set_text(str(turns))
	
	get_node("Panel/sceneeffects1").set_bbcode(text)
	
	#globals.state.actionblacklist = filter
	
	if turns == 0:
		endencounter()

var itemusemember

func open_item_list(member):
	itemusemember = member
	globals.ItemSelect(self, 'sex_use', 'use_item')

func use_item(item):
	var effect = Items.itemlist[item.itembase].interaction_effect
	item.amount -= 1
	call(effect, itemusemember)
	rebuildparticipantslist()


var categoriesorder = ['caress', 'fucking', 'tools', 'SM', 'humiliation']

func sortactions(first, second):
	
	if categoriesorder.find(first.category) == categoriesorder.find(second.category):
		if first.get('order') != null:
			if second.get('order') != null:
				if first.order >= second.order:
					return false
				else:
					return true
			else:
				return true
		
		return false
	else:
		return categoriesorder.find(first.category) < categoriesorder.find(second.category)

var requests = {
pet = "[name] wishes to be touched.",
petgive = '[name] wishes to touch.',
fuck = '[name] wishes to be penetrated.',
fuckgive = '[name] wishes to penetrate.',
pussy = "[name] wishes to have [his] pussy used.",
penis = '[name] wishes to use [his] penis.',
anal = '[name] wishes to have [his] ass used.',
punish = '[name] wishes to be punished.',
humiliate = '[name] wishes to be humiliated.',
group = '[name] wishes to have multiple partners.'

}



func generaterequest(member):
	var rval = []
	
	for i in requests:
		rval.append(i)
	
	if member.person.vaginal_virgin == true:
		rval.erase('fuck')
	if member.person.penis_size == 'none':
		rval.erase('penis')
	if member.person.penis_size == 'none' && member.strapon == null:
		rval.erase('fuckgive')
	if member.person.vagina == 'none':
		rval.erase('pussy')
	if member.person.traits.has('Dominant'):
		rval.erase('humiliate')
	if !member.person.traits.has('Likes it rough') && !member.person.traits.has('Masochist'):
		rval.erase('punish')
	if member.person.traits.has('Monogamous') || participants.size() == 2 || (!member.person.traits.has('Fickle') && member.lewd < 50):
		rval.erase('group')
	
	
	
	rval = rval[randi()%rval.size()]
	
	$Panel/sceneeffects.bbcode_text += ("[color=#f4adf4]Desire: " + member.person.translate(requests[rval]) + '[/color]\n')
	
	member.request = rval

func checkrequest(member):
	
	if member.request == null:
		return false
	
	var conditionsatisfied = false
	
	var lastaction = member.lastaction
	
	match member.request:
		'pet':
			if lastaction.takers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('pet'):
				conditionsatisfied = true
		'petgive':
			if lastaction.givers.has(member) && lastaction.scene.get('givertags') != null && lastaction.scene.givertags.has('pet'):
				conditionsatisfied = true
		'fuck':
			if lastaction.takers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('penetration'):
				conditionsatisfied = true
		'fuckgive':
			if lastaction.givers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('penetration'):
				conditionsatisfied = true
		'pussy':
			if lastaction.scene.get('givertags') != null && (lastaction.scene.givertags.has('vagina') || lastaction.scene.takertags.has('vagina')) :
				conditionsatisfied = true
		'penis':
			if lastaction.scene.get('givertags') != null && (lastaction.scene.givertags.has('penis') || lastaction.scene.takertags.has('penis')) :
				conditionsatisfied = true
		'anal':
			if lastaction.scene.get('givertags') != null && (lastaction.scene.givertags.has('anal') || lastaction.scene.takertags.has('anal')) :
				conditionsatisfied = true
		'punish':
			if lastaction.takers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('punish'):
				conditionsatisfied = true
		'humiliate':
			if lastaction.takers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('shame'):
				conditionsatisfied = true
		'group':
			if (lastaction.givers.has(member) && lastaction.takers.size() > 1) || (lastaction.takers.has(member) && lastaction.givers.size() > 1):
				conditionsatisfied = true
	
	
	if conditionsatisfied == true:
		member.request = null
		member.requestsdone += 1
		#$Panel/sceneeffects.bbcode_text += '[color=green]Wish satisfied.[/color]\n'
		member.sens += 350
	return conditionsatisfied

var ai = []

func activateai():
	for i in givers:
		if i.submission < 10 || i.consent == false:
			$Control/Panel/RichTextLabel.bbcode_text = i.person.translate('[name] refuses to participate. ')
			return
		elif i.effects.has('tied') || i.subduedby.size() > 0:
			$Control/Panel/RichTextLabel.bbcode_text = i.person.translate("[name] is immobile and can't do anything. ")
	ai.clear()
	if selectmode != 'ai':
		selectmode = 'ai'
		for i in givers:
			if i.person.professions.has('master') == false:
				ai.append(i)
	else:
		selectmode = 'normal'
	rebuildparticipantslist()


func doubledildocheck():
	var doubledildo = false
	var givercheck = false
	var takercheck = false
	
	for scene in ongoingactions:
		if scene.scene.code in ['doubledildo','doubledildoass','tribadism','frottage']:
			for i in givers:
				if scene.givers.has(i) || scene.takers.has(i):
					givercheck = true
			for i in takers:
				if scene.givers.has(i) || scene.takers.has(i):
					takercheck = true
		if givercheck && takercheck:
			doubledildo = true
			break
		else:
			givercheck = false
			takercheck = false
	return doubledildo

func checkaction(action, doubledildo):
	action.givers = givers
	action.takers = takers
	var disabled = false
	var hint_tooltip = ''
	if action.requirements() == false || filter.has(action.code):
		return ['false']
	elif doubledildo == true && action.category in ['caress','fucking'] && !action.code in ['doubledildo','doubledildoass','tribadism','frottage']:
		return ['false']
	if action.category in ['SM','tools','humiliation']:
		var valid = true
		for k in givers+takers:
			if k.limbs == false:
				valid = false
				break
		if valid == false:
			return ['false']
#	for k in givers:
#		if action.giverconsent != 'any' && ( k.person.obedience < 20) && !k.person.traits.has('Masochist') && !k.person.traits.has('Likes it rough') :
#			disabled = true
#			hint_tooltip = k.person.translate("[name] refuses to perform this action (low obedience)")
#			continue
#		elif action.giverconsent == 'advanced' && k.lust < 50:
#			disabled = true
#			hint_tooltip = k.person.translate("[name] refuses to perform this action (low lewdness)")
#			continue
#	for k in takers:
#		if k.person.professions.has("master") == true:
#			continue
#		if action.takerconsent != 'any' && (k.person.obedience < 80) && !k.person.traits.has('Masochist') && !k.person.traits.has('Likes it rough')  :
#			disabled = true
#			hint_tooltip = k.person.translate("[name] refuses to perform this action (low obedience)")
#			continue
#		elif action.takerconsent == 'advanced' && k.lust < 50:
#			disabled = true
#			hint_tooltip = k.person.translate("[name] refuses to perform this action (low lewdness)")
#			continue
	if disabled == true:
		return ['disabled',hint_tooltip]
	else:
		return ['allowed']


func slavedescription(member):
	return
	if !member.person.unique in ['dog','horse']:
		get_parent().popup(member.person.make_description())

var nakedspritesdict = [] #globals.gallery.nakedsprites

func showbody(i):
	if globals.loadimage(i.person.body_image) != null:
		$Panel/bodyimage.visible = true
		$Panel/bodyimage.texture = globals.loadimage(i.person.body_image)

func hidebody():
	$Panel/bodyimage.visible = false


func switchsides(panel, side):
	var person = panel.get_meta('person')
	givers.erase(person)
	takers.erase(person)
	if person.role == side:
		person.role = 'none'
	else:
		person.role = side
	if person.role == 'give':
		givers.append(person)
	elif person.role == 'take':
		takers.append(person)
	rebuildparticipantslist()

func startscene(scenescript, cont = false, pretext = ''):
	var textdict = {mainevent = pretext, repeats = '', orgasms = '', speech = ''}
	var effects
	scenescript.givers = givers
	scenescript.takers = takers
	turns -= 1
	
	for i in givers + takers:
		if i.effects.has('forced') && scenescript.code != 'subdue':
			var result = resistattempt(i)
			textdict.mainevent += result.text
			if result.consent == false:
				get_node("Panel/sceneeffects").bbcode_text += (textdict.mainevent + "\n" + textdict.repeats)
				rebuildparticipantslist()
				return
	
	for i in givers + takers:
		if isencountersamesex(givers,takers,i) == true:
			i.actionshad.samesex += 1
		else:
			i.actionshad.oppositesex += 1
		if i.person.sexexp.actions.has(scenescript.code):
			i.person.sexexp.actions[scenescript.code] += 1
		else:
			i.person.sexexp.actions[scenescript.code] = 1
		for k in givers + takers:
			if k != i:
				if i.person.sexexp.partners.has(k.person.id):
					i.person.sexexp.partners[k.person.id] += 1
				else:
					i.person.sexexp.partners[k.person.id] = 1
	
	for i in participants:
		i.orgasm = false
		if !givers.has(i) && !takers.has(i):
			if i.person.sexexp.seenactions.has(scenescript.code):
				i.person.sexexp.seenactions[scenescript.code] += 1
			else:
				i.person.sexexp.seenactions[scenescript.code] = 1
	
	
	
	#temporary support for scenes converted to centralized output and those not
	#should be unified in the future
	var centralized = false
	if scenescript.has_method('initiate'):
		textdict.mainevent += decoder(scenescript.initiate(), givers, takers)
	else:
		centralized = true
		textdict.mainevent += output(scenescript, scenescript.initiate, givers, takers) + output(scenescript, scenescript.ongoing, givers, takers)
		
	
	if centralized == false:
		if scenescript.has_method('reaction'):
			for i in takers:
				textdict.mainevent += '\n' + decoder(scenescript.reaction(i), givers, [i])
	elif scenescript.reaction != null:
			for i in takers:
				textdict.mainevent += '\n' + output(scenescript, scenescript.reaction, givers, [i])
	
	#remove virginity if relevant
	if scenescript.virginloss == true:
		for i in givers:
			if scenescript.giverpart == 'vagina':
				i.person.vaginal_virgin = false
			elif scenescript.giverpart == 'anus':
				i.person.anal_virgin = false
		for i in takers:
			if scenescript.takerpart == 'vagina':
				i.person.vaginal_virgin = false
			elif scenescript.takerpart == 'anus':
				i.person.anal_virgin = false
	
	
	
	var dict = {scene = scenescript, takers = [] + takers, givers = [] + givers}
	
	for i in givers:
		if scenescript.giverpart != '':
			#print(i.name + " " + str(i[scenescript.giverpart]) + str(scenescript.giverpart))
			if i[scenescript.giverpart] != null:
				stopongoingaction(i[scenescript.giverpart])
			i[scenescript.giverpart] = dict
	
	for i in takers:
		if scenescript.takerpart != '':
			if i[scenescript.takerpart] != null:
				stopongoingaction(i[scenescript.takerpart])
			i[scenescript.takerpart] = dict
	
	if scenescript.get('takerpart2'):
		givers[1][scenescript.giverpart] = dict
		for i in takers:
			if i[scenescript.takerpart2] != null:
				stopongoingaction(i[scenescript.takerpart2])
			i[scenescript.takerpart2] = dict
	
	for i in givers: 
		if scenescript.has_method('givereffect'):
			effects = scenescript.givereffect(i)
			i.actioneffect(effects, dict)
		
	for i in takers:
		if scenescript.has_method('takereffect'):
			effects = scenescript.takereffect(i)
			i.actioneffect(effects, dict)
	
	
	
	
	if scenescript.code in ['strapon', 'rope', 'subdue']:
		cont = true
	#to make action switch on that hole even if they comes from another body part
	if scenescript.code in ['doubledildo','doubledildoass','tribadism']:
		for i in ongoingactions.duplicate():
			if i.scene.category == 'fucking' && (i.givers.has(givers[0]) || i.takers.has(givers[0]) || i.givers.has(takers[0]) || i.takers.has(takers[0])):
				if i.givers == givers && i.takers == takers:
					stopongoingaction(i)
	if scenescript.code in ['cunnilingus','rimjob','facesit','afacesit','massagefoot','lickfeet']:
		for i in ongoingactions.duplicate():
			if i.scene.category == 'fucking' && (i.givers.has(givers[0]) || i.takers.has(givers[0]) || i.givers.has(takers[0]) || i.takers.has(takers[0])):
				if i.givers == givers && i.takers == takers:
					if i.scene.code != 'strapon':
						stopongoingaction(i)
	if scenescript.category == 'fucking':
		for i in ongoingactions.duplicate():
			if i.scene.code in ['cunnilingus','rimjob','facesit','afacesit','massagefoot','lickfeet'] && (i.givers.has(givers[0]) || i.takers.has(givers[0]) || i.givers.has(takers[0]) || i.takers.has(takers[0])):
				if i.givers == givers && i.takers == takers:
					stopongoingaction(i)
	if scenescript.code == 'grovel':
		for i in ongoingactions.duplicate():
			if i.scene.code in ['facesit','afacesit'] && (i.givers.has(givers[0]) || i.takers.has(givers[0]) || i.givers.has(takers[0]) || i.takers.has(takers[0])):
				if i.givers == givers && i.takers == takers:
					stopongoingaction(i)
	if scenescript.code in ['facesit','afacesit']:
		for i in ongoingactions.duplicate():
			if i.scene.code == 'grovel' && (i.givers.has(givers[0]) || i.takers.has(givers[0]) || i.givers.has(takers[0]) || i.takers.has(takers[0])):
				if i.givers == givers && i.takers == takers:
					stopongoingaction(i)
	if scenescript.code == 'rope':
		for i in takers:
			var cleararray = []
			for k in i.activeactions:
				if k.scene.code == 'subdue':
					cleararray.append(k)
			for k in cleararray:
				stopongoingaction(k)
	
	
	
	var sceneexists = false
	var temptext = ''
	for i in ongoingactions:
		temptext = ''
		if i.givers == givers && i.takers == takers && i.scene == scenescript:
			sceneexists = true
		elif i.scene.has_method('getongoingdescription'):
			temptext = decoder(i.scene.getongoingdescription(i.givers, i.takers), i.givers, i.takers)
		else:
			temptext = output(i.scene, i.scene.ongoing, i.givers, i.takers)
		if temptext != '':
			textdict.repeats += '\n' + temptext
	textdict.repeats = textdict.repeats.replace("[color=yellow]", '').replace('[color=aqua]', '').replace('[/color]','')
	
	
	for i in ongoingactions:
		for k in i.givers + i.takers:
			k.person.sexexp.actions[i.scene.code] += 1
			for j in i.givers + i.takers:
				if j != k:
					if k.person.sexexp.partners.has(j.person.id):
						k.person.sexexp.partners[j.person.id] += 1
					else:
						k.person.sexexp.partners[j.person.id] = 1
		for k in participants:
			if !i.givers.has(k) && !i.takers.has(k):
				if k.person.sexexp.seenactions.has(i.scene.code):
					k.person.sexexp.seenactions[i.scene.code] += 1
				else:
					k.person.sexexp.seenactions[i.scene.code] = 1
		if i.scene.has_method("givereffect"):
			for member in i.givers:
				effects = i.scene.givereffect(member)
				for i in effects:
					if i in ['sens','horny']:
						effects[i] = effects[i]/2
				member.actioneffect(effects, i)
		if i.scene.has_method("takereffect"):
			for member in i.takers:
				effects = i.scene.takereffect(member)
				for i in effects:
					if i in ['sens','horny']:
						effects[i] = effects[i]/2
				member.actioneffect(effects, i)
	
	
	var request
	
	for i in participants:
		if i in givers+takers:
			i.lastaction = dict
			request = checkrequest(i)
			if request == true:
				textdict.orgasms += decoder("[color=aqua]Desire fullfiled! [name1] grows lewder and more sensitive. [/color]\n", [i], [i])
		else:
			for j in ongoingactions:
				if i in j.givers + j.takers:
					i.lastaction = j
		if not i.lastaction in ongoingactions:
			i.lastaction = null
		
		for k in i.sex_traits:
			if Traitdata.sex_traits[k].trigger_side == 'everyone_turn':
				for j in k.effects:
					call(j.code, i)
	
	if cont == true && sceneexists == false: 
		ongoingactions.append(dict)
		for i in givers + takers:
			i.activeactions.append(dict)
	else:
		for i in givers:
			if scenescript.giverpart != '':
				i[scenescript.giverpart] = null
		for i in takers:
			if scenescript.takerpart != '':
				i[scenescript.takerpart] = null
	
	var x = (givers.size()+takers.size())/2
	
	while x > 0:
		if randf() < 0.3: #0.3
			var charspeech = characterspeech(dict)
			if charspeech.text != '':
				textdict.speech += charspeech.character.name + ': ' + decoder(charspeech.text, [charspeech.character], [charspeech.partner]) + '\n'
		x -= 1
	
	
	var text = textdict.mainevent + "\n" + textdict.repeats + '\n' + textdict.speech + textdict.orgasms
	
	get_node("Panel/sceneeffects").bbcode_text += '\n' + text
	
	
	
	var temparray = []
	
	for i in participants:
		if i.person.professions.has("master") || i.person.unique in ['dog','horse'] || i.effects.has('forced'):
			continue
		temparray.append(i)
	
	
	if randf() < 0.15 && temparray.size() > 0:
		generaterequest(temparray[randi()%temparray.size()])
	
	rebuildparticipantslist()

func lewdness_aura(caster):
	for i in participants:
		if i != caster:
			i.horny += 5
			i.sens += 50

func characterspeech(scene, details = []):
	var character
	var partner
	var text = ''
	
	#who speaks
	
	var array = []
	for i in scene.takers+scene.givers:
		if i.person.professions.has('master') == false:
			array.append(i)
	
	var partnerside
	
	character = array[randi()%array.size()]
	
	if character in scene.takers:
		partnerside = 'givers'
	else:
		partnerside = 'takers'
	
	partner = scene[partnerside][0]
	
	array.clear() #array will serve as speech selector
	var preventrest = true
	var dict = {}
	var prevailing_lines = ['mute', 'silence', 'orgasm', 'resistorgasm', 'pain', 'painlike', 'resist', 'blowjob']
	
	
	
	if character.person.traits.has('Mute'):
		dict.mute = [speechdict.mute, 1]
	if character.person.traits.has('Sex-crazed'):
		dict.sexcrazed = [speechdict.sexcrazed, 1]
	if character.person.traits.has('Enjoys Anal'):
		dict.sexcrazed = [speechdict.enjoysanal, 1]
	if character.person.traits.has('Likes it rough'):
		dict.sexcrazed = [speechdict.rough, 1]
#	if character.person.rules.silence == true:
#		dict.silence = [speechdict.silence, 1]
	if character.effects.has('forced'):
		dict.resist = [speechdict.resist, 1]
		if scene.scene.code in ['missionaryanal', 'doggyanal', 'lotusanal','revlotusanal', 'inserttaila', 'insertinturnsass']  && partnerside == 'givers':
			dict.analrape = [speechdict.analrape, 1]
	if character.orgasm == true:
		if character.effects.has('forced'):
			dict.resistorgasm = [speechdict.resistorgasm, 1]
		else:
			dict.orgasm = [speechdict.orgasm, 1]
	if scene.scene.code in ['blowjob'] && partnerside == 'takers':
		dict.mouth = [speechdict.blowjob, 1]
	if scene.scene.code in ['blowjob','spitroast'] && partnerside == 'givers':
		dict.mouth = [speechdict.blowjobtake, 1]
	if scene.scene.code in ['missionary', 'doggy', 'lotus', 'revlotus', 'inserttailv', 'insertinturns'] && partnerside == 'givers':
		dict.vagina = [speechdict.vagina, 1]
	if scene.scene.code in ['missionaryanal', 'doggyanal', 'lotusanal','revlotusanal', 'inserttaila', 'insertinturnsass'] && partnerside == 'givers':
		dict.anal = [speechdict.anal, 1]
	if (!character.person.traits.has('Lesbian') && !character.person.sex_traits.has("bisexual")) && character.sex != 'male' && partner.sex != 'male' && partnerside == 'givers':
		dict.nonlesbian = [speechdict.nonlesbian, 1]
	if scene.scene.get("takertags") && scene.scene.takertags.has("pain") && partnerside == 'givers' && !character.person.traits.has('Likes it rough') && !character.person.traits.has("Masochist"):
		dict.pain = [speechdict.pain, 2.5]
	if scene.scene.get("takertags") && scene.scene.takertags.has("pain") && partnerside == 'givers' && (character.person.traits.has('Likes it rough') || character.person.traits.has("Masochist")) && !character.effects.has('resist'):
		dict.painlike = [speechdict.painlike, 2.5]
	
	
	dict.moans = [speechdict.moans, 0.25]
	for i in prevailing_lines:
		if dict.has(i):
			var temp = dict[i].duplicate()
			dict.clear() 
			dict[i] = temp
			break
	for i in dict.values():
		array.append(i)
	text = input_handler.weightedrandom(array)
	if text != null:
		text = text[randi()%text.size()]
	
	if text == null:
		text = ''
	
	if partner.person.professions.has("master") || character.person.traits.has("Monogamous"):
		text = text.replace('[name2]', character.person.masternoun)
	else:
		text = text.replace('[name2]', partner.name)
	
	
	
	
	return {text = '[color=lime]' + text + '[/color]', character = character, partner = partner}

var speechdict = {
resist = ["Stop it!", "No... I don't want to!", "Why are you doing this...", "You, bastard...", "Let me go!"],
resistorgasm = ["Ahh-hh... No...", "*Sob* why... this feels so good...", "No, Please stop, before I... Ahh... No *sob*"],
mute = ['...', '...!', '......', '*gasp*'],
blowjob = ["Does it feel good? *slurp*", "Mh-m... this smell...", "Does this feel good, [name2]?", "You like my mouth, [name2]?"],
blowjobtake = ["Like my cock, [name2]?" , "Yes, suck it, dear...", "Mmmm, suck it like that."],
inexperienced = ["I've never done this...", "What's this?", "Not so fast, [name2], I'm new to this..."],
#virgin = ["Aaah! My first time...", "My first time...", "My first time... you took it..."],
vagina = ["Ah! Yes! Fuck my pussy!", "Yes, fill me up, [name2]!", "More, give me more, [name2]!", "Ah, this is so good, [name2]..."],
anal = ["My {^ass:butt}... feels good...", "Ah... My {^ass:butt}...", "Keep {^fucking:ravaging:grinding} my {^ass:butt}, [name2]..."],
orgasm = ["Cumming, I'm cumming!..", "Ah, Ahh, AAAHH!","[name2], please hold me, I'm cumming!"],
analrape = ["Stop! Where are you putting it!?", "No, please, not there!", "No, not my {^ass:butt}... I beg you..."],
sexcrazed = ["Your {^dick:cock:penis}... Yes...", "Give me your {^dick:cock:penis}, [name2]... I need it", "Fuck me, [name2], I begging you!.."],
nonlesbian = ["No, we shouldn't...", "No, we are both girls...","[name2], Ah, stop, I'm not into girls..."],
enjoysanal = ["Please, put my {^butt:ass} into a good use, [name2]...", "I want it in my {^butt:ass}..."],
rough = ["[name2], do me harder...", "Yes... Please, abuse me!"],
pain = ["Ouch! It hurts...", "Please, no more...", "*sob*", 'It hurts...', '[name2], please, stop...'],
painlike = ["Umh... Yes, hit me harder...", "Yes, [name2], punish me...", "Ah... this strings... nicely..."],
silence = ['Mmhmm...', '*gasp*', 'Mhm!!'],
moans = ["Ah...", "Oh...", "Mmmh...", "[name2]..."]

}


func triggerorgasm(i):
	var text = ''
	if i.person.sexexp.orgasms.has(i.lastaction.scene.code):
		i.person.sexexp.orgasms[i.lastaction.scene.code] += 1
	else:
		i.person.sexexp.orgasms[i.lastaction.scene.code] = 1
	for k in i.lastaction.givers + i.lastaction.takers:
		if i != k:
			if i.person.sexexp.orgasmpartners.has(k.person.id):
				i.person.sexexp.orgasmpartners[k.person.id] += 1
			else:
				i.person.sexexp.orgasmpartners[k.person.id] = 1
	text += '\n' + orgasm(i)
	return text

#Effects: pleasure, excitement, pain, deviancy, obedience 

func startscenecontinue(scenescript):
	startscene(scenescript, true)


var sexdict = load("res://src/newsexdictionary.gd").new()

#centralized output processing
#category currently assumed to be 'fucking', will expland with further conversions
func output(scenescript, valid_lines, givers, takers):
	var shared_lines = sexdict.shared_lines
	var giverpart = scenescript.giverpart
	var takerpart = scenescript.takerpart
	var act_lines = scenescript.act_lines
	var links = sexdict.linksets[scenescript.linkset]
	#internal
	var linearray = []
	var output = ''
	var virginpart = null
	var virginsource = null
	var link = null
	#checks
	var checks = {
		code = scenescript.code,
		link = null,
		orifice = 'insert',
		consent = true,
		virgin = true,
		parallel = true if scenescript.rotation1.x == scenescript.rotation2.x else false,
		facing = true if scenescript.rotation1.w == 0.0 && scenescript.rotation2.w == 0.0 else false,
		arousal = 1,
		lust = 1,
	}
	
	#link with ongoingactions
	if givers[0][giverpart] != null:
		if givers[0][giverpart].scene.code in links:
			link = givers[0][giverpart].scene
			for i in givers:
				if i[giverpart] != givers[0][giverpart]:
					link = null
					break
			for i in takers:
				if i[takerpart] != givers[0][giverpart]:
					link = null
					break
	#link with lastaction if ongoing fails
	if link == null && givers[0].lastaction != null:
		if givers[0].lastaction.scene.code in links:
			link = givers[0].lastaction.scene
			for i in givers+takers:
				if i.lastaction != givers[0].lastaction:
					link = null
					break
	#gather orifice info from link
	if link != null:
		checks.link = link.code
		if scenescript.virginloss == true && link.virginloss == true:
			if checks.code == link.code:
				checks.orifice = 'same'
			elif 'vagina' in [scenescript.giverpart] + [scenescript.takerpart] && 'vagina' in [link.giverpart] + [link.takerpart]:
				checks.orifice = 'shift'
			elif 'anus' in [scenescript.giverpart] + [scenescript.takerpart] && 'anus' in [link.giverpart] + [link.takerpart]:
				checks.orifice = 'shift'
			else:
				checks.orifice = 'swap'
	#virginity assignments
	if giverpart == 'penis':
		if takerpart == 'vagina':
			virginpart = 'vaginal_virgin'
			virginsource = takers
		elif takerpart == 'anus':
			virginpart = 'anal_virgin'
			virginsource = takers
	elif takerpart == 'penis':
		if giverpart == 'vagina':
			virginpart = 'vaginal_virgin'
			virginsource = givers
		elif giverpart == 'anus':
			virginpart = 'anal_virgin'
			virginsource = givers
	#assign virginity check
	for i in virginsource:
		if i.person[virginpart] == false:
			checks.virgin = false
	#assign consent
	for i in takers:
		if i.mode == 'forced' || i.effects.has('resist'):
			checks.consent = false
	#based on screen values, subject to adjustment
	if takers.size() == 1:
		checks.arousal = int(clamp(ceil(takers[0].sens/200), 1, 5))
		checks.lust = int(clamp(ceil(takers[0].lust/200), 1, 5))
	
	#build the output
	var drop = false
	for i in valid_lines:
		linearray = []
		if i in act_lines:
			for j in act_lines[i]:
				drop = false
				for k in act_lines[i][j].conditions:
					if checks.has(k) && !act_lines[i][j].conditions[k].has(checks[k]):
						drop = true
						break
				if drop == false:
					linearray += act_lines[i][j].lines
		if i in shared_lines:
			for j in shared_lines[i]:
				drop = false
				for k in shared_lines[i][j].conditions:
					if checks.has(k) && !shared_lines[i][j].conditions[k].has(checks[k]):
						drop = true
						break
				if drop == false:
					linearray += shared_lines[i][j].lines
		if linearray.size() > 0:
			output += linearray[randi()%linearray.size()]
	
	
	
	return decoder(output, givers, takers)

func orgasm(member):
	#member.lust -= max(300, member.lust/2)
	var scene
	var text
	var temptext = ''
	var penistext = ''
	var vaginatext = ''
	var anustext = ''
	member.orgasms += 1
	member.person.metrics.orgasm += 1
	if participants.size() == 2 && member.person.professions.has('master') == false:
		member.person.loyal += rand_range(1,4)
	elif member.person.professions.has('master') == false:
		member.person.loyal += rand_range(1,2)
	#anus in use, find scene
	if member.anus != null:
		scene = member.anus
		for i in scene.givers:
			globals.addrelations(member.person, i.person, rand_range(30,50))
		#anus in giver slot
		if scene.givers.find(member) >= 0:
			if randf() < 0.4:
				anustext = "[name1] feel[s/1] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him1] and [his1]"
			else:
				anustext = "[names1]"
			if scene.scene.takerpart == 'penis':
				anustext += " [anus1] {^squeezes:writhes around:clamps down on} [names2] [penis2] as [he1] reach[es/1] {^climax:orgasm}."
			else:
				anustext += " [anus1] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he1] reach[es/1] {^climax:orgasm}."
			anustext = decoder(anustext, [member], scene.takers)
		#anus is in taker slot
		elif scene.takers.find(member) >= 0:
			if randf() < 0.4:
				anustext = "[name2] feel[s/2] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him2] and [his2]"
			else:
				anustext = "[names2]"
			if scene.scene.giverpart == 'penis':
				anustext += " [anus2] {^squeezes:writhes around:clamps down on} [names1] [penis1] as [he2] reach[es/2] {^climax:orgasm}."
			else:
				anustext += " [anus2] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he2] reach[es/2] {^climax:orgasm}."
			anustext = decoder(anustext, scene.givers, [member])
		#no default conditon
	#vagina present
	if member.person.vagina != 'none':
		#vagina in use, find scene
		if member.vagina != null:
			scene = member.vagina
			for i in scene.givers:
				globals.addrelations(member.person, i.person, rand_range(30,50))
			#vagina in giver slot
			if scene.givers.find(member) >= 0:
				if randf() < 0.4:
					vaginatext = "[name1] feel[s/1] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him1] and [his1]"
				else:
					vaginatext = "[names1]"
				if scene.scene.takerpart == 'penis':
					vaginatext += " [pussy1] {^squeezes:writhes around:clamps down on} [names2] [penis2] as [he1] reach[es/1] {^climax:orgasm}."
				else:
					vaginatext += " [pussy1] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he1] reach[es/1] {^climax:orgasm}."
				vaginatext = decoder(vaginatext, [member], scene.takers)
			#vagina is in taker slot
			elif scene.takers.find(member) >= 0:
				if randf() < 0.4:
					vaginatext = "[name2] feel[s/2] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him2] and [his2]"
				else:
					vaginatext = "[names2]"
				if scene.scene.giverpart == 'penis':
					vaginatext += " [pussy2] {^squeezes:writhes around:clamps down on} [names1] [penis1] as [he2] reach[es/2] {^climax:orgasm}."
				else:
					vaginatext += " [pussy2] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he2] reach[es/2] {^climax:orgasm}."
				vaginatext = decoder(vaginatext, scene.givers, [member])
			#no default conditon
	#penis present
	if member.person.penis_size != 'none':
		#penis in use, find scene
		if member.penis_size != null:
			scene = member.penis
			for i in scene.takers:
				globals.addrelations(member.person, i.person, rand_range(30,50))
			#penis in giver slot
			if scene.givers.find(member) >= 0:
				if randf() < 0.4:
					penistext = "[name1] feel[s/1] {^a wave of:an intense} {^pleasure:euphoria} {^run through:course through:building in} [his1] [penis1] and [his1]"
				else:
					penistext = "[name1] {^thrust:jerk}[s/1] [his1] hips forward and a {^thick :hot :}{^jet:load:batch} of"
				if scene.scene.takerpart == '':
					penistext += " {^semen:seed:cum} {^pours onto:shoots onto:falls to} the {^ground:floor} as [he1] ejaculate[s/1]."
				elif ['anus','vagina','mouth'].has(scene.scene.takerpart):
					if scene.scene.get('takerpart2') && scene.scene.givers[1] == member:
						temptext = scene.scene.takerpart2.replace('anus', '[anus2]').replace('vagina','[pussy2]')
					else:
						temptext = scene.scene.takerpart.replace('anus', '[anus2]').replace('vagina','[pussy2]')
						if scene.scene.takerpart == 'vagina':
							for i in scene.takers:
								if impregnationcheck(i.person, member.person) == true:
									globals.impregnation(i.person, member.person)
					penistext += " {^semen:seed:cum} {^pours:shoots:pumps:sprays} into [names2] " + temptext + " as [he1] ejaculate[s/1]."
				elif scene.scene.takerpart == 'nipples':
					penistext += " {^semen:seed:cum} fills [names2] hollow nipples. "
				elif scene.scene.takerpart == 'penis':
					penistext += " {^semen:seed:cum} {^pours:shoots:sprays}, covering [names2] [penis2]. "
				penistext = decoder(penistext, [member], scene.takers)
			#penis in taker slot
			elif scene.takers.find(member) >= 0:
				if randf() < 0.4:
					penistext = "[name2] feel[s/2] {^a wave of:an intense} {^pleasure:euphoria} {^run through:course through:building in} [his2] [penis2] and [his2]"
				else:
					penistext = "[name2] {^thrust:jerk}[s/2] [his2] hips forward and a {^thick :hot :}{^jet:load:batch} of"
				if scene.scene.code in ['handjob','titjob']:
					penistext += " {^sticky:white:hot} {^semen:seed:cum} {^sprays onto:shoots all over:covers} [names1] face[/s1] as [he2] ejaculate[s/2]."
				elif scene.scene.code == 'tailjob':
					penistext += " {^sticky:white:hot} {^semen:seed:cum} {^sprays onto:shoots all over:covers} [names1] tail[/s1] as [he2] ejaculate[s/2]."
				elif scene.scene.giverpart == '':
					penistext += " {^semen:seed:cum} {^pours onto:shoots onto:falls to} the {^ground:floor} as [he2] ejaculate[s/2]."
				elif scene.scene.giverpart == 'penis':
					penistext += " {^semen:seed:cum} {^pours:shoots:sprays}, covering [names1] [penis1]. "
				elif ['anus','vagina','mouth'].has(scene.scene.giverpart):
					temptext = scene.scene.giverpart.replace('anus', '[anus1]').replace('vagina','[pussy1]')
					penistext += " {^semen:seed:cum} {^pours:shoots:pumps:sprays} into [names1] " + temptext + " as [he2] ejaculate[s/2]."
					if scene.scene.giverpart == 'vagina':
						for i in scene.givers:
							if impregnationcheck(i.person, member.person) == true:
								globals.impregnation(i.person, member.person)
				penistext = decoder(penistext, scene.givers, [member])
		#orgasm without penis, secondary ejaculation
		else:
			if randf() < 0.4:
				penistext = "[name2] {^twist:quiver:writhe}[s/2] in {^pleasure:euphoria:ecstacy} as"
			else:
				penistext = "[name2] {^can't hold back any longer:reach[es/2] [his2] limit} and"
			penistext += " {^a jet of :a rope of :}{^semen:cum} {^fires:squirts:shoots} from {^the tip of :}[his2] {^neglected :throbbing ::}[penis2]."
			penistext = decoder(penistext, null, [member])
	if vaginatext != '' || anustext != '' || penistext != '':
		text = vaginatext + " " + anustext + " " + penistext
	#final default condition
	else:
		if randf() < 0.4:
			temptext = "[name2] feel[s/2] {^a sudden :an intense ::}{^jolt of electricity:heat:wave of pleasure} and [his2]"
		else:
			temptext = "[names2]"
		temptext += " {^entire :whole :}body {^twists:quivers:writhes} in {^pleasure:euphoria:ecstacy} as [he2] reach[es/2] {^climax:orgasm}."
		text = decoder(temptext, null, [member])
	
	
	if member.lastaction.scene.code in punishcategories && member.lastaction.takers.has(member):
		if randf() >= 0.85 || member.person.effects.has("entranced"):
			member.actionshad.addtraits.append("Masochist")
#	if member.lastaction.scene.code in punishcategories && member.lastaction.givers.has(member) && member.person.asser >= 60:
#		if randf() >= 0.85 || member.person.effects.has("entranced"):
#			member.actionshad.addtraits.append("Dominant")
	if member.lastaction.scene.code in analcategories && (member.lastaction.takers.has(member) || member.lastaction.scene.code == 'doubledildoass'):
		if randf() >= 0.85 || member.person.effects.has('entranced'):
			member.actionshad.addtraits.append("Enjoys Anal")
	if isencountersamesex(member.lastaction.givers, member.lastaction.takers, member) == true:
		member.actionshad.samesexorgasms += 1
	else:
		member.actionshad.oppositesexorgasms += 1
	
	
	return "[color=#ff5df8]" + text + "[/color]"

func impregnationcheck(person1, person2):
	var valid = true
	if person1.unique in ['dog','horse'] || person2.unique in ['dog','horse']:
		valid = false
	return valid
	

func isencountersamesex(givers, takers, actor = null):
	var actorpos = ''
	var samesex = false
	if givers.size() == 0 || takers.size() == 0:
		return false
	var giverssex = givers[0].sex
	var takerssex = takers[0].sex
	if givers.has(actor):
		actorpos = 'giver'
	elif takers.has(actor):
		actorpos = 'taker'
	
	if (actorpos == 'giver' && ((actor.sex == 'male' && takerssex == 'male') || (actor.sex in ['female','futa'] && takerssex in ['female','futa']))) || (actorpos == 'taker' && ((actor.sex == 'male' && giverssex == 'male') || (actor.sex in ['female','futa'] && giverssex in ['female','futa']))) :
		samesex = true
	return samesex


func decoder(text, tempgivers, temptakers):
	return parser.decoder(text, tempgivers, temptakers)


func _on_sceneeffects1_meta_clicked( meta ):
	stopongoingaction(meta, true)

func stopongoingaction(meta, rebuild = false):
	var action
	if typeof(meta) == TYPE_STRING:
		action = ongoingactions[int(meta)]
	elif typeof(meta) == TYPE_DICTIONARY:
		action = meta
	for i in action.givers:
		if action.scene.giverpart != '':
			i[action.scene.giverpart] = null
	for i in action.takers:
		if action.scene.takerpart != '':
			i[action.scene.takerpart] = null
		if action.scene.get("takerpart2"):
			i[action.scene.takerpart2] = null
	if action.scene.code == 'strapon' && action.givers[0]['penis'] != null:
		stopongoingaction(action.givers[0]['penis'])
	if action.scene.code == 'rope':
		for i in action.takers:
			i.effects.erase('tied')
	if action.scene.code == 'subdue':
		var erasearray = []
		for taker in action.takers:
			for giver in action.givers:
				giver.subduing = null
				erasearray.append(giver)
			for giver in erasearray:
				taker.subduedby.erase(giver)
	for i in action.givers + action.takers:
		i.activeactions.erase(action)
	ongoingactions.erase(action)
	if rebuild == true:
		rebuildparticipantslist()



func _on_passbutton_pressed():
	if selectmode == 'normal':
		startscene(categories.other[0])
	else:
		askslaveforaction(ai[rand_range(0, ai.size())])

func _on_stopbutton_pressed():
	endencounter()

func endencounter():
	var text = ''
	for i in participants:
		i.person.lastsexday = state.date
		
		i.person.lust += i.orgasms*5*i.person.sexuals_factor
		i.person.obedience += i.orgasms*10
		i.person.loyal += i.orgasms
		
		text += i.person.translate("[name]: Orgasms - ") + str(i.orgasms) 
		
		text += "; Lust gained: " +  str(i.orgasms*5*i.person.sexuals_factor)
		if i.orgasms > 0:
			text += "; Obedience gained: " + str(i.orgasms*10)
			#Add 10% all productivity bonus
			#i.person.add_effect()
		
#		for trait in i.actionshad.addtraits:
#			i.person.add_trait(trait)
#
#		if i.actionshad.samesex > i.actionshad.oppositesex && i.actionshad.samesexorgasms > 0:
#			if !i.person.traits.has("Bisexual") && !i.person.traits.has("Homosexual") && (randf() >= 0.5 || i.person.effects.has('entranced')):
#				i.person.add_trait("Bisexual")
#			elif i.person.traits.has("Bisexual") && (randf() >= 0.5 || i.person.effects.has('entranced')) && max(0.2,i.actionshad.samesex)/max(0.2, i.actionshad.oppositesex) > 4 :
#				i.person.trait_remove("Bisexual")
#				i.person.add_trait('Homosexual')
#		if i.actionshad.samesex < i.actionshad.oppositesex && i.actionshad.oppositesexorgasms > 0:
#			if (i.person.traits.has("Bisexual") || i.person.traits.has("Homosexual")) && (randf() >= 0.5 || i.person.effects.has('entranced')):
#				if i.person.traits.has("Bisexual") && (randf() >= 0.5 || i.person.effects.has('entranced')) && max(0.2,i.actionshad.oppositesex)/max(0.2, i.actionshad.samesex) > 4:
#					i.person.trait_remove("Bisexual")
#				else:
#					i.person.trait_remove("Homosexual")
#					i.person.add_trait("Bisexual")
#		if i.actionshad.group*0.01 > randf():
#			i.person.trait_remove("Monogamous")
#			i.person.add_trait("Fickle")
		
		text += "\n"
	
	
	ongoingactions.clear()
	
	get_node("Control").show()
	get_node("Control/Panel/RichTextLabel").set_bbcode(text)

func mformula(gain, mana):
    return mana + gain * max(0, mana/(mana-300)+1)



func askslaveforaction(chosen):
	#choosing target
	var targets = []
	clearstate()
	var chosensex = chosen.person.sex
	var debug = ""
	var group = false
	var target
	
	
	
	
	
	
	debug += 'Chosing targets... \n'
	
	for i in participants:
		if i != chosen:
			if i.person.professions.has("master") && aiobserve == true:
				continue
			debug += i.name
			var value = 10
			if chosen.person.traits.has("Monogamous") && i.person.professions.has('master') == false:
				value = 0
			elif chosen.person.traits.has("Fickle") || chosen.person.traits.has('Slutty'):
				value = 25
			if chosen.person.traits.has('Devoted') && i.person.professions.has("master"):
				value += 50
			
			if i.npc == true && chosen.npc == true:
				value -= 50
			
			if chosen.person.sexexp.orgasms.has(i.person.id):
				value += chosen.person.sexexp.orgasms[i.person.id]*4
			if chosen.person.sexexp.watchers.has(i.person.id):
				value += (chosen.person.sexexp.watchers[i.person.id]-1)*2
			if chosen.person.sexexp.partners.has(i.person.id):
				value += chosen.person.sexexp.partners[i.person.id]/0.2
			if isencountersamesex([chosen], [i], chosen) && chosen.person.traits.has('Bisexual') == false && chosen.person.traits.has('Homosexual') == false:
				value = max(value/5,1)
			elif isencountersamesex([chosen], [i], chosen) == false && chosen.person.traits.has('Homosexual'):
				value = max(value/5,1)
			debug += " - " + str(value) + '\n'
			value = min(value, 120)
			if value > 0:
				targets.append([i, value])
	target = input_handler.weightedrandom(targets)
	debug += 'final target - ' + target.name
	
	
	
	
	
	debug += '\nChosing dom: \n'
	var dom = [['giver',40],['taker', 10]]
	
	if target.person.sex != chosen.person.sex && chosen.person.sex == 'female' && (chosen.person.asser < 75 || !chosen.person.traits.has("Dominant")):
		dom[0][1] = 0
	
	if chosen.person.asser >= 75:
		dom[1][1] = 0
	elif chosen.person.asser <= 25:
		dom[0][1] = 0
	debug += str(dom) + "\n"
	dom = input_handler.weightedrandom(dom)
	
	debug += 'final dom: ' + dom + '\n'
	
	var groupchosen = [chosen] 
	var grouptarget = [target]
	
	if participants.size() >= 3:
		if randf() >= 0.5 && chosen.person.traits.has("Monogamous") == false:
			group = true
	var freeparticipants = []
	
	if group == true:
		debug += "Group action attempt:\n"
		for i in participants:
			if i.person.professions.has("master") && aiobserve == true:
				continue
			if i != chosen && i != target && randf() >= 0.5:
				freeparticipants.append(i)
		
		while freeparticipants.size() > 0:
			var targetgroup
			var newparticipant = freeparticipants[randi()%freeparticipants.size()]
			var samesex = isencountersamesex([newparticipant], [chosen], chosen)
			if chosen.person.traits.has("Bisexual"):
				targetgroup = 'any'
			elif (chosen.person.traits.has("Homosexual") && samesex) || !samesex:
				targetgroup = 'target'
			elif chosen.person.traits.has("Homosexual"):
				targetgroup = 'any'
			else:
				targetgroup = 'chosen'
			if (targetgroup == 'any' && randf() >= 0.5) || targetgroup == 'chosen':
				groupchosen.append(newparticipant)
			else: 
				grouptarget.append(newparticipant)
			
			freeparticipants.erase(newparticipant)
	
	#choosing action
	var chosenpos = ''
	var actions = []
	var chosenaction = null
	debug += 'chosing action: \n' 
	for i in categories:
		for j in categories[i]:
			clearstate()
			debug += j.code + ": "
			if j.code == 'wait':
				continue
			if j.code in takercategories:
				if dom == 'taker':
					givers += groupchosen
					takers += grouptarget
				else:
					takers += groupchosen
					givers += grouptarget
			else:
				if dom == 'taker':
					takers += groupchosen
					givers += grouptarget
				else:
					givers += groupchosen
					takers += grouptarget
			var result = checkaction(j, doubledildocheck())
			if result[0] == 'allowed':
				var value = 0
				if chosen.person.sexexp.actions.has(j.code):
					value += chosen.person.sexexp.actions[j.code]/2
				if chosen.person.sexexp.orgasms.has(j.code):
					value += chosen.person.sexexp.orgasms[j.code]*4
				if chosen.person.sexexp.seenactions.has(j.code):
					value += chosen.person.sexexp.seenactions[j.code]/10
				
				if i in ['caress','fucking']:
					value += 10
				
				if !chosen.person.traits.has("Enjoys Anal") && j.code in analcategories:
					if chosenpos == 'giver' && !takercategories.has(j.code):
						value -= 5
					elif chosenpos == 'taker' && takercategories.has(j.code):
						value -= 5
				
				
				
				if chosen.person.traits.has('Masochist') && j.code in punishcategories && chosenpos == 'taker':
					value *= 2.5
				if chosen.person.traits.has('Dominant') && j.code in punishcategories && chosenpos == 'giver':
					value *= 2.5
				if target.submission < 20  && j.code in punishcategories && chosenpos == 'giver':
					value *= 3
				if chosen.person.penis_size == 'none' && dom == 'giver' && j.code == 'strapon':
					value *= 10
				if chosen.person.traits.has("Pervert") && ((givers.has(chosen) && j.giverconsent == 'advanced') || (takers.has(chosen) && j.takerconsent == 'advanced')):
					value += 15
				
				if chosen.person.vaginal_virgin == true && j.category == 'fucking' && !j.code in analcategories:
					value -= 25
				if chosen.person.anal_virgin == true && j.category == 'fucking' && j.code in analcategories:
					value -= 25
				
				if j.category == 'fucking':
					value += max(turns, 15)
				
				if j.code in ['tribadism','doubledildo','doubledildoass','frottage'] && (chosen.strapon != null || target.strapon != null):
					value = 0
				
				debug += str(value) + '\n'
				if value >= 0:
					actions.append([j, value])
	if actions.size() == 0:
		actions.append([categories.other[0], 1])
	chosenaction = input_handler.weightedrandom(actions)
	clearstate()
	if chosenaction.code in takercategories:
		if dom == 'taker':
			givers = groupchosen
			takers = grouptarget
		else:
			takers = groupchosen
			givers = grouptarget
	else:
		if dom == 'taker':
			takers = groupchosen
			givers = grouptarget
		else:
			givers = groupchosen
			takers = grouptarget
	var cont = false
	chosenaction.givers = givers
	chosenaction.takers = takers
	var text = '[color=green][name1] initiates ' + chosenaction.getname() + ' with [name2].[/color]\n\n'
	if chosenaction.canlast == true && randf() >= 0.2:
		cont = true
	$PopupPanel/RichTextLabel.bbcode_text = debug
	#$PopupPanel.popup()
	startscene(chosenaction, cont, decoder(text, groupchosen, grouptarget))

func _on_finishbutton_pressed():
	ai.clear()
	for i in participants:
		if i.npc == false:
			for k in participants:
				if k.npc == true:
					i.person.sexexp.watchers.erase(k.person.id)
					i.person.sexexp.partners.erase(k.person.id)
					i.person.sexexp.orgasms.erase(k.person.id)
	selectmode = 'normal'
	hide()


func _on_blacklist_pressed():
	$blacklist.visible = true
	for i in $blacklist/ScrollContainer/VBoxContainer.get_children():
		if i.get_name() != 'CheckBox':
			i.visible = false
			i.queue_free()
	for i in categories.values():
		for j in i:
			if j.code == 'wait':
				continue
			var node = $blacklist/ScrollContainer/VBoxContainer/CheckBox.duplicate()
			j.givers = [participants[0]]
			$blacklist/ScrollContainer/VBoxContainer.add_child(node)
			node.visible = true
			node.text = j.getname(1)
			node.set_pressed(!filter.has(j.code))
			node.set_meta("action", j)
			node.connect("toggled", self, 'toggleaction', [node])

func toggleaction(button, node):
	var action = node.get_meta('action')
	if filter.has(action.code):
		filter.erase(action.code)
	else:
		filter.append(action.code)
	node.set_pressed(!filter.has(action.code))

func _on_closeblacklist_pressed():
	$blacklist.visible = false
	rebuildparticipantslist()




func _on_debug_pressed():
	$PopupPanel.popup()


func _on_aiallow_pressed():
	aiobserve = $Panel/aiallow.pressed

func resistattempt(member):
	var result = {text = '', consent = true}
	var resistwill = 0
	var resiststrength = member.person.sstr + 1
	var subdue = 0
	if member.consent == false:
		resistwill += 100
	if member.person.obedience < 80:
		resistwill += 100-member.person.obed
	
	resistwill -= member.person.loyal/3
	if member.person.traits.has("Likes it rough"):
		resistwill -= member.lewd/1.5
	else:
		resistwill -= member.lewd/2
	
	
	if member.effects.has('drunk'):
		resistwill /= 3
	elif member.effects.has('sexcrazed'):
		resistwill = 0
	if member.effects.has('tied'):
		resiststrength = 0
		
		result.text += '[name1] is powerless to resist, as [his1] limbs are restricted by rope.\n'
	
	
	for i in member.subduedby:
		subdue += i.person.sstr + 1
	
	if resistwill > 0:
		if resiststrength >= subdue && resiststrength != 0:
			result.consent = false
			result.text += '[name1] resists the attempt with brute force.\n'
			member.person.obedience -= rand_range(4,8)
		else:
			if !member.person.traits.has("Likes it rough") && !member.person.traits.has("Sex-crazed") && !(member.person.traits.has("Submissive") && member.person.loyal >= 40):
				member.person.conf -= rand_range(2,4)
				member.person.cour -= rand_range(2,4)
			
			if member.subduedby.size() == 0:
				result.text += '[name1] tries to struggle, but [his1] strength is not enough to fight back...\n'
			else:
				result.text += "[name1]'s attempts to resist are stopped by being held by [name2]. \n"
			
	else:
		member.effects.erase('resist')
		result.text += '[name1] no longer fights back.\n'
	
	result.text = decoder(result.text, [member], member.subduedby)
	return result





func alcohol(member):
	var text = "\n" + member.name + " has drank an alcoholic bevarage. "
	if member.effects.has("drunk") == false:
		member.sensmod += 0.2
		member.hornymod += 0.5
		member.horny += 10
		member.effects.append('drunk')
		text += "It made [him] slightly more horny and sensitive. "
	else:
		text += "But it seems [he] is already tipsy. "
	$Panel/sceneeffects.bbcode_text += member.person.translate(text)

func aphrodisiac(member):
	member.horny += 100
	var text = "\n" + member.name + " has used an aphrodisiac. [His] breath grew slower and heavier. "
	$Panel/sceneeffects.bbcode_text += member.person.translate(text)
	

func sensetivity_pot(member):
	member.sensmod += 1
	member.lewdmod += 0.2
	var text = "\n" + member.name + " has used an sensitivity potion. [His] body became more responsive. "
	$Panel/sceneeffects.bbcode_text += member.person.translate(text)



