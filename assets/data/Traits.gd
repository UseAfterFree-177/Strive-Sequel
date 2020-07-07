extends Node

var traits = {
	core_trait = {#adds core effects
		code = 'core',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['test_combat_start'],
	}, 
	
	'master' : {#150% effect from social skills
		code = 'master',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_master']#,'test_recast'],
	}, 
	'director' : {#150% effect from social skills
		code = 'director',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_master']#,'test_recast'],
	}, 
	'slave' : {#slave class trait
		code = 'slave',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_slave']
	},
	servant = {#servant class trait
		code = 'servant',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = []
	},
	worker = {
		code = 'worker',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_worker'],
	}, 
	foreman = {
		code = 'foreman',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_foreman'],
	}, 
	hunter= {
		code = 'hunter',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_hunter'],
	}, 
	smith = {
		code = 'smith',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_smith'],
	}, 
	engineer = {
		code = 'engineer',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_engi'],
	}, 
	chef = {
		code = 'chef',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_chef'],
	}, 
	attendant = {#item usage in combat takes no turn
		code = 'attendant',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_attendant'],
	}, 
	alchemist = {#+100% alchemy production, potions restore 25% more
		code = 'alchemist',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_alchemist','e_tr_potion'],
	}, 
	witcrit = {#+crit
		code = 'witcrit',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_witcrit'],
	},
	valkyrie_spear = {
		code = 'valkyrie_spear',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['valkyrie_spear_bonus'],
	},
	autohide = {
		code = 'autohide',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_hide'],
	},
	farmer = {#+50% farm production
		code = 'farmer',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_cattle'],
	}, 
	breeder = {#+100% farm production, allows breeding with any race, -30% pregnancy duration
		code = 'breeder',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_breeder'],
	}, #second and third effects need to be hardcoded
	harlot = {#+50% gold from prostitution
		code = 'harlot',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_harlot'],
	}, 
	succubus = {#+100% exp from prostitution
		code = 'succubus',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = [],
	}, #hardcoded
	pet = {#+25% gold from prostitution
		code = 'pet',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_pet'],
	},
	sextoy = {#+50% gold from prostitution
		code = 'sextoy',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = ['e_tr_harlot'],
	},
	
	#exploration related traits
	#needs to hardcode most of traits
	medium_armor = {#removes penalty from medium armor
		code = 'medium_armor',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = [],
	}, 
	heavy_armor = {#removes penalty from heavy armor
		code = 'heavy_armor',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = [],
	}, 
	lockpicking = { #allows to pick locks on random events
		code = 'lockpicking',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = [],
	},
	trap_detection = { #allows to detect traps on random events
		code = 'trap_detection',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = [],
	},
	magic_tools = {
		code = 'magic_tools',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = [],
	}, #allows to equip magic rods and staves
	weapon_mastery = {#allows to equip combat weapons
		code = 'weapon_mastery',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = [],
	}, 
	ranged_weapon_mastery = {#allows to equip ranged combat weapons
		code = 'ranged_weapon_mastery',
		name = '',
		descript = '',
		visible = false,
		icon = null,
		effects = [],
	}, 
	undead = {
		code = 'undead',
		name = '',
		descript = '',
		icon = null,
		visible = true,
		effects = [],
	},
	stealth = {
		code = 'staelth',
		name = '',
		descript = '',
		icon = null,
		visible = false,
		effects = ['e_tr_hide'],
	},
}

var sex_traits = { #only for interaction tab
	dislike_petting = {
		code = "dislike_petting",
		name = "",
		descript = "",
		starting = false,
		random_generation = true,
		acquire_reqs = [],
		negative = true,
		reqs = [{code = "action_type", value = ["caress","fondletits","kiss"]}],
		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}],
	},
	dislike_fingering = {
		code = "dislike_fingering",
		name = "",
		descript = "",
		starting = false,
		random_generation = true,
		acquire_reqs = [],
		negative = true,
		reqs = [{code = "action_type", value = ["fingering","assfingering","vibrator",'analvibrator']}],
		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
	},
	dislike_tits = {
		code = "dislike_tits",
		name = "",
		descript = "",
		starting = false,
		random_generation = true,
		acquire_reqs = [],
		negative = true,
		reqs = [{code = "action_type", value = ["titjob","fondletits","sucknipple",'nipplefuck']}],
		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
	},
	dislike_oral = {
		code = "dislike_oral",
		name = "",
		descript = "",
		starting = false,
		random_generation = true,
		acquire_reqs = [],
		negative = true,
		reqs = [{code = "action_type", value = ["blowjob","cunnilingus","rimjob",'deepthroat']}],
		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
	},
	dislike_missionary = {
		code = "dislike_missionary",
		name = "",
		descript = "",
		starting = false,
		random_generation = true,
		acquire_reqs = [],
		negative = true,
		reqs = [{code = "action_type", value = ["missionary","missionaryanal","kiss",'fondletits']}],
		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
	},
	dislike_doggy = {
		code = "dislike_doggy",
		name = "",
		descript = "",
		starting = false,
		random_generation = true,
		acquire_reqs = [],
		negative = true,
		reqs = [{code = "action_type", value = ["doggy","doggyanal","doubledildo",'doubledildoass','grovel']}],
		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
	},
	dislike_sitting = {
		code = "dislike_sitting",
		name = "",
		descript = "",
		starting = false,
		random_generation = true,
		acquire_reqs = [],
		negative = true,
		reqs = [{code = "action_type", value = ["lotus",'lotusanal','revlotus','revlotusanal','facesit','afacesit','tribadism','frottage']}],
		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
	},
	dislike_riding = {
		code = "dislike_riding",
		name = "",
		descript = "",
		starting = false,
		random_generation = true,
		acquire_reqs = [],
		negative = true,
		reqs = [{code = "action_type", value = ["ontop",'ontopanal']}],
		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
	},
	dislike_group = {
		code = "dislike_group",
		name = "",
		descript = "",
		starting = false,
		random_generation = true,
		acquire_reqs = [],
		negative = true,
		reqs = [{code = "action_type", value = ["doublepen",'spitroast','spitroastass','insertinturns','insertinturnsass']}],
		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
	},
	dislike_bdsm = {
		code = "dislike_bdsm",
		name = "",
		descript = "",
		starting = false,
		random_generation = true,
		acquire_reqs = [],
		negative = true,
		reqs = [{code = "action_type", value = ["spanking",'whipping','nippleclap','clitclap','ringgag','blindfold','nosehook','facesit','afacesit']}],
		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
	},
	dislike_tail = {
		code = "dislike_tail",
		name = "",
		descript = "",
		starting = false,
		random_generation = true,
		acquire_reqs = [],
		negative = true,
		reqs = [{code = "action_type", value = ["tailjob",'earjob','inserttailv','inserttaila']}],
		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
	},
	
	
	bisexual = {
		code = "bisexual",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "same_sex_orgasms", operant = "gte", value = 2}],
		reqs = [],
		effects = [],
	},
	open_minded = {
		code = "open_minded",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "diff_body_orgasm", operant = "gte", value = 2}]}],
		reqs = [],
		effects = [],
	},
	deviant = {
		code = "deviant",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "deviant_orgasms", operant = "gte", value = 2}]}],
		reqs = [],
		effects = [],
	},
	group = {
		code = "group",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "orgasm_partners", operant = "gte", value = 2}]}],
		reqs = [],
		effects = [],
	},
	shameless = {
		code = "shameless",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "orgasm_with_watcher", operant = "gte", value = 3}]}],
		reqs = [],
		effects = [],
	},
	anal = {
		code = "anal",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "orgasm_tags", flag = "only", value = "anal"}]}],
		reqs = [],
		effects = [],
	},
	breasts = {
		code = "breasts",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "orgasm_tags", flag = "only", value = "tits"}]}],
		reqs = [{code = "action_tag", value = "tits"}],
		effects = [{effect = 'sens_bonus', operant = "+", value = 0.5, trigger = 'action_self'},{effect = 'horny_bonus', operant = "+", value = 0.5, trigger = 'action_self'}],
	},
	masochist = {
		code = "masochist",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "mazo_actions", operant = "gte", value = 10}]}],
		reqs = [{code = "action_tag", value = "punish"}],
		effects = [{effect = 'sens_bonus', operant = "+", value = 0.5, trigger = 'action_self'}],
	},
	sadist = {
		code = "sadist",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "punish_actions", operant = "gte", value = 10}]}],
		reqs = [{code = "action_partner_tag", value = "punish"}],
		effects = [{effect = 'sens_bonus', operant = "+", value = 0.5, trigger = 'action_self'}],
	},
	dominant = {
		code = "dominant",
		name = "",
		descript = "",
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "dominant", operant = "gte", value = 3}]}],
		starting = true,
		random_generation = true,
		negative = false,
		reqs = [{code = "action_tag", value = "dom"}],
		effects = [{effect = 'sens_bonus', operant = "+", value = 0.2, trigger = 'action_self'}],
	},
	submissive = {
		code = "submissive",
		name = "",
		descript = "",
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "orgasm_effects", flag = "any", value = ["subdued", "tied"]}]}],
		starting = true,
		random_generation = true,
		negative = false,
		reqs = [{code = "action_tag", value = "sub"}],
		effects = [{effect = 'sens_bonus', operant = "+", value = 0.2, trigger = 'action_self'}],
	},
	nymphomania = {
		code = "nymphomania",
		name = "",
		descript = "",
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "orgasms", operant = "gte", value = 5}]}],
		starting = true,
		random_generation = true,
		negative = false,
		reqs = [],
		effects = [{effect = 'maximize_hornyness', trigger = 'start'}],
	},
	hypersensitive = {
		code = "hypersensitive",
		name = "",
		descript = "",
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "aphrodisiac_orgasms", operant = "gte", value = 2}]}],
		starting = true,
		random_generation = true,
		negative = false,
		reqs = [],
		effects = [{effect = 'can_orgasm_regardless', trigger = 'orgasm'}],
	},
	lewdness_aura = {
		code = "lewdness_aura",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [],
		reqs = [],
		effects = [{effect = 'lewdness_aura', trigger = 'end_turn'}],
	},
	bottle_fairy = {
		code = "bottle_fairy",
		name = "",
		descript = "",
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "drunk_orgasm", operant = "gte", value = 2}]}],
		starting = true,
		random_generation = true,
		negative = false,
		reqs = [{code = 'effect_exists', value = 'tipsy', orflag = true},{code = 'effect_exists', value = 'drunk', orflag = true}],
		effects = [{effect = 'sens_bonus', operant = '+', value = 0.3, trigger = 'action_self'}],
	},
	irresistible = {
		code = "irresistible",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "new_consented_partners", operant = "gte", value = 3}]}],
		reqs = [],
		effects = [{effect = 'consent', operant = "+", value = 10, trigger = 'consent_check_partner'}],
	},
	bedroom_prodidgy = {
		code = "bedroom_prodidgy",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "bedroom_prodigy", operant = "gte", value = 3}]}],
		reqs = [],
		effects = [{effect = 'skill_exp', operant = '+', value = 0.5, trigger = 'skill_exp_gain'}],
	},
	pushover = {
		code = "pushover",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "unconsented_orgasm", operant = "gte", value = 2}]}],
		reqs = [],
		effects = [{effect = 'consent_gain', operant = '*', value = 1.5, trigger = 'encounter_end'}],
	},
	teacher = {
		code = "teacher",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "single_partner_consents", operant = "gte", value = 6}]}],
		reqs = [],
		effects = [{effect = 'skill_exp', operant = '+', value = 0.5, trigger = 'skill_exp_gain_partner'}],
	},
	desired = {
		code = "desired",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "satisfied_partners", operant = "gte", value = 2}]}],
		reqs = [],
		effects = [{effect = 'sens_bonus', operant = '+', value = 0.25, trigger = 'action_partner'}],
	},
	curious = {
		code = "curious",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "seen_orgasms", operant = "gte", value = 2}]}],
		reqs = [],
		effects = [{effect = 'exp_bonus', operant = '+', value = 0.25, trigger = 'encounter_end'}],
	},
	life_power = {
		code = "life_power",
		name = "",
		descript = "",
		starting = true,
		random_generation = true,
		negative = false,
		acquire_reqs = [{code = "actor_check", value = [{code = "stat", type = "max_ongoing_actions", operant = "gte", value = 5}]}],
		reqs = [],
		effects = [{effect = 'life_power', trigger = 'encounter_end'}],
	},
#	dislike_petting = {
#		code = "dislike_petting",
#		name = "",
#		descript = "",
#		starting = false,
#		random_generation = true,
#		acquire_reqs = [],
#		negative = true,
#		reqs = [{code = "action_type", value = ["caress","fondletits","kiss"]}],
#		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}],
#	},
#	dislike_fingering = {
#		code = "dislike_fingering",
#		name = "",
#		descript = "",
#		starting = false,
#		random_generation = true,
#		acquire_reqs = [],
#		negative = true,
#		reqs = [{code = "action_type", value = ["fingering","assfingering","vibrator",'analvibrator']}],
#		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
#	},
#	dislike_tits = {
#		code = "dislike_fingering",
#		name = "",
#		descript = "",
#		starting = false,
#		random_generation = true,
#		acquire_reqs = [],
#		negative = true,
#		reqs = [{code = "action_type", value = ["tijob","fondletits","sucknipple",'nipplefuck']}],
#		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
#	},
#	dislike_oral = {
#		code = "dislike_oral",
#		name = "",
#		descript = "",
#		starting = false,
#		random_generation = true,
#		acquire_reqs = [],
#		negative = true,
#		reqs = [{code = "action_type", value = ["blowjob","cunnilingus","rimjob",'deepthroat']}],
#		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
#	},
#	dislike_missionary = {
#		code = "dislike_missionary",
#		name = "",
#		descript = "",
#		starting = false,
#		random_generation = true,
#		acquire_reqs = [],
#		negative = true,
#		reqs = [{code = "action_type", value = ["missionary","missionaryanal","kiss",'fondletits']}],
#		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
#	},
#	dislike_doggy = {
#		code = "dislike_doggy",
#		name = "",
#		descript = "",
#		starting = false,
#		random_generation = true,
#		acquire_reqs = [],
#		negative = true,
#		reqs = [{code = "action_type", value = ["doggy","doggyanal","doubledildo",'doubledildoass','grovel']}],
#		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
#	},
#	dislike_sitting = {
#		code = "dislike_sitting",
#		name = "",
#		descript = "",
#		starting = false,
#		random_generation = true,
#		acquire_reqs = [],
#		negative = true,
#		reqs = [{code = "action_type", value = ["lotus",'lotusanal','revlotus','revlotusanal','facesit','afacesit','tribadism','frottage']}],
#		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
#	},
#	dislike_riding = {
#		code = "dislike_riding",
#		name = "",
#		descript = "",
#		starting = false,
#		random_generation = true,
#		acquire_reqs = [],
#		negative = true,
#		reqs = [{code = "action_type", value = ["ontop",'ontopanal']}],
#		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
#	},
#	dislike_group = {
#		code = "dislike_group",
#		name = "",
#		descript = "",
#		starting = false,
#		random_generation = true,
#		acquire_reqs = [],
#		negative = true,
#		reqs = [{code = "action_type", value = ["doublepen",'spitroast','spitroastass','insertinturns','insertinturnsass']}],
#		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
#	},
#	dislike_bdsm = {
#		code = "dislike_bdsm",
#		name = "",
#		descript = "",
#		starting = false,
#		random_generation = true,
#		acquire_reqs = [],
#		negative = true,
#		reqs = [{code = "action_type", value = ["spanking",'whipping','nippleclap','clitclap','ringgag','blindfold','nosehook','facesit','afacesit']}],
#		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
#	},
#	dislike_tail = {
#		code = "dislike_tail",
#		name = "",
#		descript = "",
#		starting = false,
#		random_generation = true,
#		acquire_reqs = [],
#		negative = true,
#		reqs = [{code = "action_type", value = ["tailjob",'earjob','inserttailv','inserttaila']}],
#		effects = [{effect = 'consent', operant = '*', value = 1, trigger = 'consent_check'},{effect = 'horny_bonus', operant = "-", value = 0.33, trigger = 'action_self'}]
#	},
#
#
#	bisexual = {
#		code = "bisexual",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [],
#	},
#	open_minded = {
#		code = "open_minded",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [],
#	},
#	deviant = {
#		code = "deviant",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [],
#	},
#	group = {
#		code = "group",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [],
#	},
#	shameless = {
#		code = "shameless",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [],
#	},
#	anal = {
#		code = "anal",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [],
#	},
#	breasts = {
#		code = "breasts",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [{code = "action_tag", value = "tits"}],
#		effects = [{effect = 'sens_bonus', operant = "+", value = 0.5, trigger = 'action_self'},{effect = 'horny_bonus', operant = "+", value = 0.5, trigger = 'action_self'}],
#	},
#	masochist = {
#		code = "masochist",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [{code = "action_tag", value = "punish"}],
#		effects = [{effect = 'sens_bonus', operant = "+", value = 0.5, trigger = 'action_self'}],
#	},
#	sadist = {
#		code = "sadist",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [{code = "action_partner_tag", value = "punish"}],
#		effects = [{effect = 'sens_bonus', operant = "+", value = 0.5, trigger = 'action_self'}],
#	},
#	dominant = {
#		code = "dominant",
#		name = "",
#		descript = "",
#		acquire_reqs = [],
#		starting = true,
#		random_generation = true,
#		negative = false,
#		reqs = [{code = "action_tag", value = "dom"}],
#		effects = [{effect = 'sens_bonus', operant = "+", value = 0.2, trigger = 'action_self'}],
#	},
#	submissive = {
#		code = "submissive",
#		name = "",
#		descript = "",
#		acquire_reqs = [],
#		starting = true,
#		random_generation = true,
#		negative = false,
#		reqs = [{code = "action_tag", value = "sub"}],
#		effects = [{effect = 'sens_bonus', operant = "+", value = 0.2, trigger = 'action_self'}],
#	},
#	nymphomania = {
#		code = "nymphomania",
#		name = "",
#		descript = "",
#		acquire_reqs = [],
#		starting = true,
#		random_generation = true,
#		negative = false,
#		reqs = [],
#		effects = [{effect = 'maximize_hornyness', trigger = 'start'}],
#	},
#	hypersensitive = {
#		code = "hypersensitive",
#		name = "",
#		descript = "",
#		acquire_reqs = [],
#		starting = true,
#		random_generation = true,
#		negative = false,
#		reqs = [],
#		effects = [{effect = 'can_orgasm_regardless', trigger = 'orgasm'}],
#	},
#	lewdness_aura = {
#		code = "lewdness_aura",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [{effect = 'lewdness_aura', trigger = 'end_turn'}],
#	},
#	bottle_fairy = {
#		code = "bottle_fairy",
#		name = "",
#		descript = "",
#		acquire_reqs = [],
#		starting = true,
#		random_generation = true,
#		negative = false,
#		reqs = [{code = 'effect_exists', value = 'tipsy', orflag = true},{code = 'effect_exists', value = 'drunk', orflag = true}],
#		effects = [{effect = 'sens_bonus', operant = '+', value = 0.3, trigger = 'action_self'}],
#	},
#	irresistible = {
#		code = "irresistible",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [{effect = 'consent', operant = "+", value = 10, trigger = 'consent_check_partner'}],
#	},
#	bedroom_prodidgy = {
#		code = "bedroom_prodidgy",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [{effect = 'skill_exp', operant = '+', value = 0.5, trigger = 'skill_exp_gain'}],
#	},
#	pushover = {
#		code = "pushover",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [{effect = 'consent_gain', operant = '*', value = 1.5, trigger = 'encounter_end'}],
#	},
#	teacher = {
#		code = "teacher",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [{effect = 'skill_exp', operant = '+', value = 0.5, trigger = 'skill_exp_gain_partner'}],
#	},
#	desired = {
#		code = "desired",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [{effect = 'sens_bonus', operant = '+', value = 0.25, trigger = 'action_partner'}],
#	},
#	curious = {
#		code = "curious",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [{effect = 'exp_bonus', operant = '+', value = 0.25, trigger = 'encounter_end'}],
#	},
#	life_power = {
#		code = "life_power",
#		name = "",
#		descript = "",
#		starting = true,
#		random_generation = true,
#		negative = false,
#		acquire_reqs = [],
#		reqs = [],
#		effects = [{effect = 'life_power', trigger = 'encounter_end'}],
#	},
#
#	likes_shortstacks = {
#		code = "likes_shortstacks",
#		name = "",
#		descript = "",
#		starting = true,
#		acquire_reqs = [{code = 'custom', value = 'height'}],
#		trigger = 'self',
#		reqs = [{code = 'partner_check', value = [{code = 'is_shortstack', value = true}]}],
#		effects = [{effect = 'sens_bonus', operant = "+", value = 0.25},{effect = 'horny_bonus', operant = "+", value = 0.25}],
#	},
#	likes_beasts = {
#		code = "likes_beasts",
#		name = "",
#		descript = "",
#		starting = true,
#		acquire_reqs = [{code = 'race_is_beast', value = false}],
#		trigger = 'self',
#		reqs = [{code = 'partner_check', value = [{code = 'race_is_beast', value = true}]}],
#		effects = [{effect = 'sens_bonus', operant = "+", value = 0.25},{effect = 'horny_bonus', operant = "+", value = 0.25}],
#	},
}
