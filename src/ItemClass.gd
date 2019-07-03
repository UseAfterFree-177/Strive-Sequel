extends Reference
class_name Item

var name = ""
var id
var itembase
var code
var icon
var description
var stackable = false
var inventory

#Useable data
var amount = 1 setget amount_set
var useeffects
var useskill

#Gear Data
var type
var itemtype
var geartype
var subtype
var durability
var maxdurability
var price
var bonusstats = {} #bonus stats apply to chars
var parts = {}
var effects = []
var task
var owner = null
var partcolororder
var broken = false
var tags = []
var materials = []
var weaponrange
var multislots = []
var slots = []
var hitsound
var interaction_use = false


func CreateUsable(ItemName = '', number = 1):
	type = 'usable'
	itembase = ItemName
	code = ItemName
	stackable = true
	amount = number
	var itemtemplate = Items.itemlist[ItemName]
	if itemtemplate.icon != null:
		icon = itemtemplate.icon.get_path()
	name = itemtemplate.name
	if itemtemplate.has("interaction_effect"):
		interaction_use = true
	itemtype = 'usable'
	description = itemtemplate.descript
	#itemtype = itemtemplate.itemtype
#	useeffects = itemtemplate.useeffects
#	useskill = itemtemplate.useskill
#	description = itemtemplate.description

func amount_set(value):
	amount = value
	if amount <= 0:
		inventory.erase(id)

func UseItem(user = null, target = null):
	var finaltarget
	for i in effects:
		var effect = Effectdata.effects[i]
		if i.taker == 'caster':
			if user == null:
				return
			finaltarget = user
		elif i.taker == 'target':
			if target == null:
				return
			finaltarget = target
		Effectdata.call(effect.effect, finaltarget, effect.value)

func CreateGear(ItemName = '', dictparts = {}):
	var mode = 'normal'
	if dictparts.size() == 0:
		mode = 'simple'
	itembase = ItemName
	bonusstats = {damage = 0, damagemod = 1, armor = 0, armorpenetration = 0, evasion = 0, hitrate = 0, hpmax = 0, hpmod = 0, manamod = 0, speed = 0, resistfire = 0, resistearth = 0, resistair = 0, resistwater = 0, mdef = 0}
	stackable = false
	type = 'gear'
	var itemtemplate = Items.itemlist[ItemName]
	var tempname = itemtemplate.name
	
	if mode == 'simple':
		name = itemtemplate.name
		description = itemtemplate.descript
	
	
	geartype = itemtemplate.geartype
	if itemtemplate.has('weaponrange'):
		weaponrange = itemtemplate.weaponrange
	itemtype = itemtemplate.itemtype
	
	for i in itemtemplate.basestats:
		if bonusstats.has(i):
			bonusstats[i] += itemtemplate.basestats[i]
	
	
	if itemtemplate.has('effects'):
		for e in itemtemplate.effects:
			effects.push_back(e)
	
	
	tags = itemtemplate.tags
	if itemtemplate.has('multislots'):
		multislots = itemtemplate.multislots
	if itemtemplate.has('hitsound'):
		hitsound = itemtemplate.hitsound
	slots = itemtemplate.slots
	if mode == 'normal':
		parts = dictparts.duplicate()
		durability = itemtemplate.basedurability
		partcolororder = itemtemplate.partcolororder
	
		var parteffectdict = {}
		for i in parts:
			var material = Items.materiallist[parts[i]]
			var materialeffects = material['parts'][i]
			materials.append(material.code)
			globals.AddOrIncrementDict(parteffectdict, materialeffects)
		if parteffectdict.has('durabilitymod'):
			durability *= parteffectdict.durabilitymod
		for i in parteffectdict:
			if self.get(i) != null && i != 'effects':
				#self[i] += parteffectdict[i]
				set(i, get(i)+parteffectdict[i])
			elif bonusstats.has(i):
				bonusstats[i] += parteffectdict[i]
			elif i == 'effects':
				for k in parteffectdict[i]:
					effects.append(k)
		for i in itemtemplate.basemods:
			if bonusstats.has(i):
				bonusstats[i] *= itemtemplate.basemods[i]
	
	
	if itemtemplate.icon != null:
		if itemtemplate.has("alticons"):
			var alticon = false
			for i in itemtemplate.alticons.values():
				if i.materials.has(parts[i.part]):
					icon = i.icon.get_path()
					if i.has('altname'):
						tempname = i.altname
					alticon = true
			if alticon == false:
				icon = itemtemplate.icon.get_path()
		else:
			icon = itemtemplate.icon.get_path()
	
	
	
	if mode == 'normal':
		durability = round(durability)
		maxdurability = round(durability)
		if dictparts.size() == itemtemplate.parts.size():
			name = Items.materiallist[dictparts[itemtemplate.partmaterialname]].adjective.capitalize() + ' ' + tempname
		else:
			name = tempname
	
	bonusstats.damage = ceil(bonusstats.damage * bonusstats.damagemod)
	bonusstats.erase('damagemod')
	
	

func substractitemcost():
	var itemtemplate = Items.itemlist[itembase]
	for i in parts:
		state.materials[parts[i]] -= itemtemplate.parts[i]

func set_icon(node):
	var icon_texture
	if ResourcePreloader.new().has_resource(icon) == false:
		icon_texture = globals.loadimage(icon)
	else:
		icon_texture = load(icon)
	
	if node.get_class() == "TextureButton":
		node.texture_normal = icon_texture
	else:
		node.texture = icon_texture
	if parts.size() > 0:
		var shader = load("res://files/ItemShader.tres").duplicate()
		if node.material != shader:
			node.material = shader
		else:
			shader = node.material
		for i in parts:
			var part = 'part' +  str(partcolororder[i]) + 'color'
			var color = Items.materiallist[parts[i]].color
			node.material.set_shader_param(part, color)



func tooltiptext():
	var text = ''
	text += '[center]' + name + '[/center]\n' 
	if description != null:
		text += description + "\n"
	if itemtype in ['armor','weapon','tool']:
		#text += 'Durability: ' + str(durability) + '/' + str(maxdurability)
		text += "\n\n"
		for i in bonusstats:
			if bonusstats[i] != 0:
				var value = bonusstats[i]
				var change = ''
				if i in ['hpmod', 'manamod']:
					value = value*100
				text += Items.stats[i] + ': {color='
				if value > 0:
					change = '+'
					text += 'green|'
				else:
					text += 'red|'
				value = str(value)
				if i in ['hpmod', 'manamod']:
					value = change + value + '%'
				text += value + '}\n'
		text += tooltipeffects()
	elif itemtype == 'usable':
		text += '\n\n' + tr("INPOSESSION") + ': ' + str(amount)
	
	text = globals.TextEncoder(text)
	return text

func tooltipeffects():
	var text = ''
	for i in effects:
		text += "{color=" + Effectdata.effects[i].textcolor + '|' + Effectdata.effects[i].descript
		text += '}\n'
	return text

func tooltip(targetnode):
	var node = input_handler.GetItemTooltip()
	var data = {text = tooltiptext(), icon = load(icon), item = self, price = str(calculateprice())}
	
	node.showup(targetnode, data, 'gear')


func repairwithmaterials():
	var materialsdict = counterepairmaterials()
	
	durability = maxdurability
	
	for i in materialsdict:
		state.materials[i] -= materialsdict[i]

func canrepairwithmaterials(): #checks if item can be repaired at present state and returns the problem
	var canrepair = true
	var text = ''
	var materialsdict = counterepairmaterials()
	
	for i in materialsdict:
		if state.materials[i] < materialsdict[i]:
			canrepair = false
			text += tr("NOTENOUGH") + ' [color=yellow]' + Items.materiallist[i].name + '[/color]'
	
	if effects.has('brittle'):
		canrepair = false
		text = tr("CANTREPAIREFFECT")
	
	var returndict = {canrepair = canrepair, text = text}
	
	return returndict

func calculatematerials():
	var itemtemplate = Items.itemlist[itembase] #item base for item parts amount
	var materialsdict = {} #total materials used in creation
	#collecting parts info
	for i in parts:
		if materialsdict.has(parts[i]):
			materialsdict[parts[i]] += itemtemplate.parts[i]
		else:
			materialsdict[parts[i]] = itemtemplate.parts[i]
	return materialsdict

func counterepairmaterials():
	var requiredmaterialsdict = calculatematerials()
	var itemtemplate = Items.itemlist[itembase] 
	
	#calculating total resource needs
	var multiplier = 0
	match itemtemplate.repairdifficulty: #0.5, 0.65, 0.8
		'easy':
			multiplier = variables.RepairCostMultiplierEasy
		'medium':
			multiplier = variables.RepairCostMultiplierMedium
		'hard':
			multiplier = variables.RepairCostMultiplierHard
	if effects.has('natural'): #0.15
		multiplier -= variables.ItemEffectNaturalMultiplier
	
	var durabilitymultiplier = 1 - durability/maxdurability
	
	for i in requiredmaterialsdict:
		requiredmaterialsdict[i] *= multiplier * durabilitymultiplier
		requiredmaterialsdict[i] = ceil(requiredmaterialsdict[i])
	
	
	return requiredmaterialsdict

func calculateprice():
	var price = 0
	if itemtype == 'usable':
		price = Items.itemlist[itembase].price
	else:
		var materialsdict = calculatematerials()
		for i in materialsdict:
			price += Items.materiallist[i].price*materialsdict[i]
	return price

