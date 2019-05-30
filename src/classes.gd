extends Node

var professions = {
	master = {
		code = 'master',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Master.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [{code = 'global_profession_limit', name = 'master', value = 1}],
		reqs = [{code = 'global_profession_limit', name = 'master', value = 1}],
		statchanges = [],
		traits = ['master_effect'], #150% effect from social skills
		skills = ['praise', 'warn', 'reward','punish'],
		combatskills = [],
	},
	ruler = {
		code = 'ruler',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['social'],
		showupreqs = [{code = 'global_profession_limit', name = 'ruler', value = 1}],
		reqs = [{code = 'has_profession', value = 'master'}],
		statchanges = [],
		traits = [],
		skills = ['publichumiliation','publicsexhumiliation','publicexecution'],
		combatskills = ['inspire'],
	},
	watchdog = {
		code = 'watchdog',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Watchdog.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'loyal', operant = 'gte', value = 20}],
		statchanges = [{brave_factor = 1}],
		traits = [],
		skills = ['praise', 'punish', 'warn'],
		combatskills = [],
	},
	sadist = {
		code = 'sadist',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['social'],
		showupreqs = [],
		reqs = [],
		statchanges = [],
		traits = [],
		skills = ['abuse'],
		combatskills = [],
	},
	headgirl = {
		code = 'headgirl',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Headman.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'loyal', operant = 'gte', value = 40}],
		statchanges = [],
		traits = [],
		skills = ['praise', 'reward', 'warn', 'punish'],
		combatskills = [],
	},
	director = {
		code = 'director',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['social'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'loyal', operant = 'gte', value = 75},{code = 'has_profession', value = 'headgirl'}],
		statchanges = [],
		traits = [],
		skills = ['publichumiliation','publicsexhumiliation','publicexecution'],
		combatskills = [],
	},
	trainer = {
		code = 'trainer',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Trainer.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [],
		reqs = [{code = 'has_any_profession', value = ['master', 'watchdog']},{code = 'stat', type = 'physics', operant = 'gte', value = 2}],
		statchanges = [],
		traits = [],
		skills = ['discipline','publichumiliation','publicsexhumiliation'],
		combatskills = ["command"], 
	},
	worker = {
		code = 'worker',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Worker.png"),
		tags = [],
		categories = ['labor'],
		reqs = [],
		showupreqs = [],
		statchanges = [],
		traits = ['worker_trait'],
		skills = [],
		combatskills = [],
	},
	foreman = {
		code = 'foreman',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [{code = 'has_profession', value = 'worker'}, {code = 'stat', type = 'physics', operant = 'gte', value = 3}],
		statchanges = [{physics_bonus = 15}],
		traits = ['foreman_trait'],
		skills = ['hardwork'],
		combatskills = [],
	},
	hunter = {
		code = 'hunter',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Hunter.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 1}],
		statchanges = [],
		traits = ['hunter_trait', 'ranged_weapon_mastery'],
		skills = [],
		combatskills = ['trap'], 
	},
	smith = {
		code = 'smith',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Blacksmith.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 2}],
		statchanges = [{physics_bonus = 10}],
		traits = ['smith_trait'],#smith assignement speed +100%
		skills = [],
		combatskills = ['weapon_refine'],
	},
	chef = {
		code = 'chef',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Chef.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'wits', operant = 'gte', value = 2}],
		statchanges = [],
		traits = ['chef_trait'],
		skills = [],
		combatskills = [],
	},
	attendant = {
		code = 'attendant',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Attendant.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 1}],
		statchanges = [],
		traits = ['attendant_trait'],
		skills = [],
		combatskills = [],
	},
	alchemist = {
		code = 'alchemist',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Alchemist.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'wits', operant = 'gte', value = 3}],
		statchanges = [{wits_bonus = 15}],
		traits = ['alchemist_trait'],
		skills = [],
		combatskills = ['acid_bomb','fire_bomb'],
	},
	cattle = {
		code = 'cattle',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Cattle.png"),
		tags = [],
		categories = ['sexual'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'brave_factor', operant = 'lte', value = 3}],
		statchanges = [],
		traits = ['cattle_trait'], 
		skills = [],
		combatskills = [],
	},
	breeder = {
		code = 'breeder',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Breeder.png"),
		tags = [],
		categories = ['sexual'],
		showupreqs = [],
		reqs = [{code = 'has_profession', value = 'cattle'}],
		statchanges = [{sexuals_bonus = 20}],
		traits = ['breeder_trait'],
		skills = [],
		combatskills = [],
	},
	harlot = {
		code = 'harlot',
		name = '',
		descript = '',
		icon = load('res://assets/images/iconsclasses/Whore.png'),
		tags = [],
		categories = ['social', 'sexual'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'sexuals_factor', operant = 'gte', value = 2}],
		statchanges = [{sexuals_bonus = 10}],
		traits = ['harlot_trait'], 
		skills = ['rewardsex'],
		combatskills = ['distract'], 
	},
	geisha = {
		code = 'geisha',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Geisha.png"),
		tags = [],
		categories = ['social', 'sexual'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'sexuals', operant = 'gte', value = 2}, {code = 'stat', type = 'charm', operant = 'gte', value = 2},{code = 'has_profession', value = 'harlot'}],
		statchanges = [{charm_bonus = 15}],
		traits = [],
		skills = [],
		combatskills = [],
	},
	succubus = {
		code = 'succubus',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Succubus.png"),
		tags = [],
		categories = ['social', 'sexual'],
		showupreqs = [{code = 'race', operant = 'neq', value = 'demon'}],
		reqs = [{code = 'stat', type = 'sexuals', operant = 'gte', value = 3},{code = 'stat', type = 'charm', operant = 'gte', value = 2},{code = 'has_profession', value = 'harlot'},{code = 'race', operant = 'neq', value = 'Demon'}],
		statchanges = [{charm_bonus = 25}],
		traits = ['succubus_trait'],
		skills = ['seduce','drain'],
		combatskills = ['attract'],
	},
	true_succubus = {
		code = 'true_succubus',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/True_Succubus.png"),
		tags = [],
		categories = ['social', 'sexual'],
		showupreqs = [{code = 'race', operant = 'eq', value = 'demon'}],
		reqs = [{code = 'stat', type = 'sexuals', operant = 'gte', value = 3},{code = 'stat', type = 'charm', operant = 'gte', value = 2},{code = 'has_profession', value = 'harlot'},{code = 'race', operant = 'eq', value = 'Demon'}],
		statchanges = [{charm_bonus = 25}],
		traits = ['succubus_trait'],
		skills = ['seduce','greatseduce','drain'],
		combatskills = ['attract'],#debuff: enemy damage -30%, enemy hitrate -20 for 3 turns
	},
	pet = {
		code = 'pet',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Pet.png"),
		tags = [],
		categories = ['social','sexual'],
		showupreqs = [{code = 'race_is_beast',value = false}],
		reqs = [{code = 'stat', type = 'brave_factor', operant = 'lte', value = 3},{code = 'gear_equiped', value = 'pet_suit'}, {code = 'race_is_beast',value = false}],
		statchanges = [{charm_bonus = 10}],
		traits = ['pet_trait'],
		skills = ['serve','rewardsex'],
		combatskills = ['distract'],
	},
	petbeast = {
		code = 'petbeast',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Pet.png"),
		tags = [],
		categories = ['social', 'sexual'],
		showupreqs = [{code = 'race_is_beast',value = true}],
		reqs = [{code = 'stat', type = 'brave_factor', operant = 'lte', value = 3}, {code = 'race_is_beast',value = true}],
		statchanges = [{charm_bonus = 10}],
		traits = ['pet_trait'],
		skills = ['serve','rewardsex'],
		combatskills = ['distract'],
	},
	sextoy = {
		code = 'sextoy',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Sex_Toy.png"),
		tags = [],
		categories = ['sexual'],
		showupreqs = [],
		reqs = [{code = 'has_profession', value = 'harlot'},{code = 'has_profession', value = 'pet'}, {code = 'stat', type = 'sexuals', operant = 'gte', value = 4}],
		statchanges = [{sexuals_bonus = 30}],
		traits = ['sextoy_trait'],
		skills = [],
		combatskills = ['enthral'], 
	},
	dancer = {
		code = 'dancer',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['social','sexual'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'charm', operant = 'gte', value = 1},{code = 'stat', type = 'physics', operant = 'gte', value = 2}],
		statchanges = [{charm_bonus = 15}],
		traits = [],
		skills = ['charm'],
		combatskills = ['distract'], 
	},
	maid = {
		code = 'maid',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Maid.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [],
		statchanges = [{charm_bonus = 10}, {tame_factor = 1}],
		traits = [],
		skills = ['serve'],
		combatskills = [],
	},
	fighter = {
		code = 'fighter',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Fighter.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics_factor', operant = 'gte', value = 2}],
		statchanges = [{physics_bonus = 10}],
		traits = ['weapon_mastery','medium_armor'],
		skills = [],
		combatskills = ['double_attack'], 
	},
	knight = {
		code = 'knight',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Knight.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 3},{code = 'has_profession', value = 'fighter'}],
		statchanges = [{hp = 40},{armor = 10}],
		traits = ['medium_armor','heavy_armor'],
		skills = [],
		combatskills = ['slash', 'protect'],
	},
	dragonknight = {
		code = 'dragonknight',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Dragon_Knight.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [{code = 'race', operant = 'eq', value = 'Dragonkin'}],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 4},{code = 'has_profession', value = 'fighter'},{code = 'race', operant = 'eq', value = 'Dragonkin'}],
		statchanges = [{hp = 25}, {physics_bonus = 20}, {resistfire = 75}],
		traits = ['heavy_armor'],
		skills = [],
		combatskills = ['slash','dragonmight','charge'],#increases damage and armor by 25% until end of battle. Once in 2 days
	},
	berserker = {
		code = 'berserker',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['combat'],
		showupreqs = [{code = 'race', operant = 'eq', value = 'Orc'}],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 2},{code = 'has_profession', value = 'fighter'},{code = 'race', operant = 'eq', value = 'Orc'}],
		statchanges = [{hp = 20}, {physics_bonus = 10}],
		traits = ['medium_armor'],
		skills = [],
		combatskills = ['rage_strike'], #deals bonus damage depending on health missing
	},
	apprentice = {
		code = 'apprentice',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Apprentice.png"),
		tags = [],
		categories = ['combat','magic'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'magic_factor', operant = 'gte', value = 2}],
		statchanges = [{wits_bonus = 10}],
		traits = ['magic_tools'],
		skills = [],
		combatskills = ['magic_arrow','lesser_heal'],
	},
	caster = {
		code = 'caster',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Caster.png"),
		tags = [],
		categories = ['combat','magic'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'wits', operant = 'gte', value = 2},{code = 'has_profession', value = 'apprentice'}],
		statchanges = [{magic_factor = 1}],
		traits = [],
		skills = ['shackles'],
		combatskills = ['blizzard','barrier'],
	},
	healer = {
		code = 'healer',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['combat','magic'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 2},{code = 'has_profession', value = 'apprentice'}],
		statchanges = [{physics_bonus = 10}],
		traits = [],
		skills = ['innervate'],
		combatskills = ['mass_lesser_heal','bless'],
	},
	dominator = {
		code = 'dominator',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Dominator.png"),
		tags = [],
		categories = ['social','magic'],
		showupreqs = [],
		reqs = [{code = 'has_profession', value = 'caster'},{code = 'stat', type = 'wits', operant = 'gte', value = 4}],
		statchanges = [{charm_bonus = 20}],
		traits = [],
		skills = ['innervate','greatshackles','mindcontrol'],
		combatskills = [],
	},
	druid = {
		code = 'druid',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['magic', 'combat'],
		showupreqs = [{code = 'one_of_races', value = ['Elf','DarkElf','Drow','Dryad']}],
		reqs = [{code = 'has_profession', value = 'apprentice'},{code = 'stat', type = 'magic_factor', operant = 'gte', value = 3}, {code = 'one_of_races', value = ['Elf','Dark Elf','Drow','Dryad']}],
		statchanges = [{wits_bonus = 20}],
		traits = [],
		skills = [],
		combatskills = ['mass_lesser_heal','entangle'],
	},
	bloodmage = {
		code = 'bloodmage',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Blood_Mage.png"),
		tags = [],
		categories = ['combat','magic'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 3},{code = 'has_profession', value = 'caster'}],
		statchanges = [{hp = 25}],
		traits = [],
		skills = [],
		combatskills = ['blood_magic', 'blood_explosion'],#sacrifice 10% health to get 3x mana from it, 3 charges per day | sacrifice 75% health to deal 2x weapon spell damage to all enemies, usable once a day, can't use if health <= 75%
	},
	valkyrie = {
		code = 'valkyrie',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['combat'],
		showupreqs = [{code = 'race', operant = 'eq', value = 'Seraph'}],
		reqs = [{code = 'has_profession', value = 'fighter'},{code = 'race', operant = 'eq', value = 'Seraph'}],
		statchanges = [],
		traits = ['medium_armor'],
		skills = [],
		combatskills = ['charge','fly_evasion'],
	},
	souleater = {
		code = 'souleater',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['social'],
		showupreqs = [],
		reqs = [{code = 'has_profession', value = 'dominator'},{code = 'stat', type = 'magic_factor', operant = 'gte', value = 5}],
		statchanges = [],
		traits = [],
		skills = ['consume_soul'],
		combatskills = ['drain_mana'],#steals some mana from enemy
	},
	necromancer = {
		code = 'necromancer',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['social','magic'],
		showupreqs = [],
		reqs = [{code = 'has_profession', value = 'caster'},{code = 'stat', type = 'magic_factor', operant = 'gte', value = 4}],
		statchanges = [{mpmax = 15}],
		traits = [],
		skills = ['make_undead'],
		combatskills = ['decay'],#deals earth damage to all enemies
	},
	archer = {
		code = 'archer',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics_factor', operant = 'gte', value = 2}],
		statchanges = [{hitrate = 10}],
		traits = ['ranged_weapon_mastery'],
		skills = [],
		combatskills = ['serrated_shot'],#cause bleeding
	},
	sniper = {
		code = 'sniper',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 3},{code = 'has_profession', value = 'archer'}],
		statchanges = [{hitrate = 25}],
		traits = ['medium_armor'],
		skills = [],
		combatskills = ['disruption_shot'],#dispells 1 buff from target and silences it for 3 turns
	},
	rogue = {
		code = 'rogue',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['combat', 'social'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 1}, {code = 'stat', type = 'wits', operant = 'gte', value = 2}],
		statchanges = [{evasion = 10}],
		traits = ['lockpicking', 'trap_detection','medium_armor','weapon_mastery'], #allows lockpicking chests and trap detect actions in events
		skills = [],
		combatskills = ['bleeding_strike','hide'],
	},
	assassin = {
		code = 'assassin',
		name = '',
		descript = '',
		icon = null,
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics_factor', operant = 'gte', value = 3},{code = 'has_profession', value = 'rogue'}],
		statchanges = [{speed = 10, evasion = 25}],
		traits = [],
		skills = [],
		combatskills = ['assassinate'], 
	},
	
	
	
}



