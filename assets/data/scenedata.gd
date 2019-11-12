extends Node

#wolves_skirmish_start
var scenedict = {
	childbirth = {text = tr("DIALOGUECHILDBIRTHTEXT"), image = 'childbirth', tags = ['active_character_translate'], options = [{code = 'keepbaby', reqs = [], text = tr("DIALOGUEKEEPBABY")}, {code = 'removebaby', reqs = [], text = tr("DIALOGUEREMOVEBABY")}]},
	
	slave_escape = {text = tr("DIALOGUEESCAPETEXT"), image = 'slaveescape', tags = ['active_character_translate'], options = [{code = 'close', reqs = [], text = tr("DIALOGUEESCAPECLOSE")}]},
	
	
	location_event_search = {text = tr("DIALOGUELOCATIONEVENT"), tags = [], image = '', options = [{code = 'good_event', reqs = [], text = tr("DIALOGUELOCATIONEVENTGOOD")},{code = 'evil_event', reqs = [], text = tr("DIALOGUELOCATIONEVENTEVIL")},{code = 'leave', reqs = [], text = tr("DIALOGUELEAVEOPTION")}]},
	
	wolves_skirmish_start = {text = tr("DIALOGUEWOLVES_SKIRMISH_START"), set_enemy = 'wolves_skirmish',tags = [], image = '', options = [{code = 'fight_skirmish', reqs = [], text = tr("DIALOGUEFIGHTOPTION")},{code = 'leave', reqs = [], text = tr("DIALOGUELEAVEOPTION")}]},
	rebels_skirmish_start = {text = tr("DIALOGUEREBELS_SKIRMISH_START"), set_enemy = 'rebels_skirmish',tags = [], image = '', options = [{code = 'fight_skirmish', reqs = [], text = tr("DIALOGUEFIGHTOPTION")},{code = 'leave', reqs = [], text = tr("DIALOGUELEAVEOPTION")}]},
	
	
	character_boss_defeat = {text = tr("DIALOGUERANDOMBOSSDEFEAT"), 
	image = 'bosscapturefemale', 
	tags = [],
	options = [
	{code = 'recruit', reqs = [], text = tr("DIALOGUERECRUITBOSSOPTION")},
	{code = 'execute', reqs = [], text = tr("DIALOGUEEXECUTEOPTION")}
	]
	},
	finish_quest_dungeon = {text = tr("DIALOGUEDUNGEONQUESTCOMPLETE"), 
	image = 'dungeonclear',
	tags = [], 
	options = [
	{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")},
	]
	},
	finish_quest_location = {text = tr("DIALOGUELOCATIONQUESTCOMPLETE"), 
	image = 'dungeonclear',
	tags = [], 
	options = [
	{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")},
	]
	},
	
	
	
	dungeon_find_chest_easy = {
		text = tr("DIALOGUEDUNGEONCHEST"), 
		tags = [],
		image = 'chest', 
		bonus_args = {loot_data = {type = 'tableloot', pool = [['easy_chest_usable', 1], ['easy_chest_gear',0.2], ['easy_chest_cosmetics', 0.5]]}},
		options = [
		{code = 'open_chest', reqs = [], text = tr("DIALOGUEFORCECHESTOPEN")},
		{code = 'leave', reqs = [], text = tr("DIALOGUELEAVEOPTION")}
		]
	},
	
	purchase_dungeon_location = {
		text = tr("DIALOGUEPURCHASEDUNGEONLOCATION"), 
		image = 'locationpurchase',
		tags = [], 
		options = [
		{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")},
		],
	},
	
	event_good_recruit = {text = tr("DIALOGUEEVENTGOODRECRUIT"), 
	args = {characterdata = {}},
	tags = ['good'],
	default_event_type = "character_event",
	image = 'recruit', 
	bonus_args = {characterdata = {type = 'function', function = 'make_local_recruit', args = {}}},
	options = [
	{code = 'recruit', reqs = [], text = tr("DIALOGUERECRUITCHARACTEROPTION")},
	{code = 'leave', reqs = [], text = tr("DIALOGUELEAVEOPTION")}
	]
	},
	
	event_good_loot_small = {text = tr("DIALOGUEEVENTGOODLOOT"), 
	tags = ['good'],
	default_event_type = "loot",
	image = 'chest', 
	bonus_args = {loot_data = {type = 'tableloot', pool = [['easy_chest_usable', 1], ['easy_chest_gear',0.2], ['easy_chest_cosmetics', 0.5]]}},
	options = [
	{code = 'open_chest', reqs = [], text = tr("DIALOGUEFORCECHESTOPEN")},
	{code = 'leave', reqs = [], text = tr("DIALOGUELEAVEOPTION")}
	]
	},
	event_trap_easy = {text = tr("DIALOGUEEVENTTRAP"), 
	tags = ['linked_event'],
	default_event_type = "trap",
	image = '', 
	bonus_args = {},
	options = [
	{code = 'activate_trap_easy', select_person = true, reqs = [], text = tr("DIALOGUEACTIVATETRAP")},
	]
	},
	activate_trap_easy = {
		variations = [
			{reqs = [{type = 'active_character_checks', value = [{code = 'trait', value = 'trap_detection'}]},
			],
			text = tr("DIALOGUEEVENTTRAPSUCCESS"),
			common_effects = [{code = 'affect_active_character', type = 'stat', name = 'wits', value = 3}],
			tags = ['active_character_translate'],
			image = '',
			options = [
				{code = 'leave', text = tr("DIALOGUECLOSE"), reqs = []},
				]
			},
			{reqs = [],
			text = tr("DIALOGUEEVENTTRAPFAILURE"),
			image = '',
			common_effects = [{code = "affect_active_character", type = 'damage', value = 25}],
			tags = ['active_character_translate'],
			options = [
				{code = 'leave', text = tr("DIALOGUECLOSE"), reqs = []},
				],
				
			}
		],
	},
	
	event_dungeon_prisoner = {text = tr("DIALOGUEEVENTDUNGEONPRISONER"), 
	tags = ['linked_event'],
	default_event_type = "character_event",
	image = '', 
	bonus_args = {
		characterdata = {type = 'function', function = 'make_local_recruit', args = {races = [['local', 5],['random', 1]], difficulty = [0,2], type = 'servant'}},
	},
	options = [
	{code = 'event_dungeon_prisoner_enslave', reqs = [], text = ("DIALOGUETAKESLAVE")},
	{code = 'event_dungeon_prisoner_free', reqs = [], text = tr("DIALOGUESETFREEPERSON")},
	{code = 'leave', reqs = [], text = tr("DIALOGUELEAVEOPTION")}
	]
	},
	event_dungeon_prisoner_enslave = {text = tr("DIALOGUEEVENTDUNGEONPRISONERSENSLAVE"), 
	tags = ['active_character_translate'],
	image = '', 
	bonus_args = {},
	common_effects = [{code = 'change_type_scene_characters', type = 'all', value = 'slave'},{code = 'affect_scene_characters', type = 'all', name = 'obedience', value = 20}],
	options = [
	{code = 'recruit', reqs = [], text = tr("DIALOGUELEAVEOPTION")}
	]
	},
	event_dungeon_prisoner_free = {
		variations = [
			{reqs = [{type = 'random', value = 0}],
			text = tr("DIALOGUEEVENTDUNGEONPRISONERFREE1"),
			image = 'chest',
			default_event_type = "loot",
			bonus_args = {},
			common_effects = [{code = 'make_loot', type = 'tableloot', pool = [['easy_prisoner_reward_resource',1]] }],
			tags = ['active_character_translate'],
			options = [
				{code = 'open_chest', text = tr("DIALOGUECLOSE"), reqs = []},
				]
			},
			{reqs = [],
			text = tr("DIALOGUEEVENTDUNGEONPRISONERFREE2"),
			image = 'chest',
			default_event_type = "loot",
			bonus_args = {},
			common_effects = [{code = 'make_loot', type = 'tableloot', pool = [['easy_prisoner_reward_item',1]] }],
			tags = ['active_character_translate'],
			options = [
				{code = 'open_chest', text = tr("DIALOGUECLOSE"), reqs = []},
				],
				
			}
		],
	},
	
	
	event_good_slavers_woods = {text = tr("DIALOGUEEVENTGOODSLAVERS"), 
	args = {},
	tags = ['good','linked_event'],
	default_event_type = "character_event",
	image = '',
	set_enemy = 'slavers_small',
	winscene = 'event_person_acquired',
	bonus_args = {
		characterdata = {type = 'function', function = 'make_local_recruit', args = {races = [['Elf', 10], ['Fairy', 2], ['Dryad', 1]], difficulty = [0,1], bonuses = {pricemod = -0.3}, type = 'slave'}},
	},
	common_effects = [{code = 'affect_scene_characters', type = 'all', name = 'obedience', value = 10},{code = 'affect_scene_characters', type = 'all', name = 'fear', value = 50}],
	options = [
	{code = 'fight_skirmish', reqs = [], text = tr("DIALOGUEFIGHTOPTION")},
	{code = 'event_person_acquired', reqs = [{type = "has_money_for_scene_slave", value = 0}], not_hide = true, text = tr("DIALOGUESLAVERSPURCHASE"), bonus_effects = [{code = 'spend_money_for_scene_character', value = 0}]},
	{code = 'event_good_slavers_request', select_person = true, reqs = [], text = tr("DIALOGUEREQUESTSLAVE")},
	{code = 'leave', reqs = [], text = tr("DIALOGUELEAVEOPTION")},
	]
	},
	event_good_slavers_request = {
		variations = [
			{reqs = [{type = 'active_character_checks', value = [{code = 'random', value = [['self.charm_factor','*5'],"+", ['self.charm', '/4']]}]},
			],
			text = tr("DIALOGUEEVENTSLAVERSNEGOTIATESUCCESS"),
			common_effects = [{code = 'affect_active_character', type = 'stat', name = 'charm', value = 3}],
			tags = ['linked_event','active_character_translate'],
			image = '',
			options = [
				{code = 'event_person_acquired', text = tr("DIALOGUECONTINUEOPTION"), reqs = []},
				]
			},
			{reqs = [],
			text = tr("DIALOGUEEVENTSLAVERSNEGOTIATEFAILURE"),
			image = '',
			common_effects = [{code = 'affect_active_character', type = 'stat', name = 'charm', value = 2}],
			tags = ['linked_event','active_character_translate'],
			options = [
				{code = 'close', text = tr("DIALOGUECLOSE"), reqs = []},
				],
				
			}
		],
	},
	event_person_acquired = {
		text = tr("DIALOGUEEVENTGOODSLAVERSACQUIRED"),
		args = {},
		tags = ['linked_event'],
		default_event_type = 'scene_character_event',
		image = 'recruit',
		common_effects = [{code = 'bool_scene_characters', type = 'all', name = 'is_known_to_player', value = true}],
		options = [
		{code = 'recruit_from_scene', reqs = [], text = tr("DIALOGUEKEEPSLAVEPERSON")},
		{code = 'event_person_free', reqs = [], text = tr("DIALOGUESETFREEPERSON")}
		],
	},
	event_person_free = {
		text = tr("DIALOGUEEVENTPERSONFREE"),
		args = {},
		tags = [],
		default_event_type = 'scene_character_event',
		image = '',
		common_effects = [{code = 'change_type_scene_characters', type = 'all', value = 'servant'}],
		options = [
		{code = 'event_person_recruit_attempt', select_person = true, reqs = [], text = tr("DIALOGUEPERSONASKTOJOIN")},
		{code = 'close', reqs = [], text = tr("DIALOGUELEAVEOPTION")}
		],
	},
	
	event_person_recruit_attempt = {
		variations = [
			{reqs = [{type = 'active_character_checks', value = [{code = 'random', value = [['self.charm_factor','*5'],"+", ['self.charm', '/4']]}]},#type = 'charm_factor', operant = 'gte', value = 3}]}
			],
			text = tr("DIALOGUERECRUITSUCCESS"),
			common_effects = [{code = 'affect_active_character', type = 'stat', name = 'charm', value = 3},{code = 'affect_scene_characters', type = 'all', name = 'obedience', value = 90}],
			tags = ['active_character_translate','scene_character_translate'],
			image = '',
			options = [
				{code = 'recruit_from_scene', text = tr("DIALOGUECONTINUEOPTION"), reqs = []},
				]
			},
			{reqs = [],
			text = tr("DIALOGUERECRUITFAILURE"),
			image = '',
			common_effects = [{code = 'affect_active_character', type = 'stat', name = 'charm', value = 2}],
			tags = ['active_character_translate','scene_character_translate'],
			options = [
				{code = 'close', text = tr("DIALOGUECLOSE"), reqs = []},
				],
				
			}
		],
	},
	
	event_good_rebels_beastkin = {text = tr("DIALOGUEEVENTGOODREBELSBEAST"), 
	args = {},
	tags = ['good'],
	default_event_type = "character_event",
	image = '',
	set_enemy = 'rebels_small',
	winscene = 'event_person_acquired',
	bonus_args = {
		characterdata = {type = 'function', function = 'make_local_recruit', args = {races = [['beast', 1]], difficulty = [0,1], type = 'servant'}},
	},
	common_effects = [{code = 'affect_scene_characters', type = 'all', name = 'obedience', value = 50},{code = 'affect_scene_characters', type = 'all', name = 'fear', value = 50}],
	options = [
	{code = 'fight_skirmish', reqs = [], text = tr("DIALOGUEFIGHTOPTION")},
	{code = 'event_good_rebels_intimidate', select_person = true, reqs = [], text = tr("DIALOGUEINTIMIDATE")},
	{code = 'leave', reqs = [], text = tr("DIALOGUELEAVEOPTION")},
	]
	},
	
	event_good_rebels_intimidate = {
		variations = [
			{reqs = [{type = 'active_character_checks', value = [{code = 'random', value = [['self.physics_factor','*8'],"+", ['self.physics', '/3']]}]},
			],
			text = tr("DIALOGUEEVENTREBELSBEASTINTIMIDATESUCCES"),
			common_effects = [{code = 'affect_active_character', type = 'stat', name = 'charm', value = 3}],
			tags = ['linked_event','active_character_translate'],
			image = '',
			options = [
				{code = 'event_person_acquired', text = tr("DIALOGUECONTINUEOPTION"), reqs = []},
				]
			},
			{reqs = [],
			text = tr("DIALOGUEEVENTREBELSBEASTINTIMIDATEFAILURE"),
			image = '',
			common_effects = [{code = 'affect_active_character', type = 'stat', name = 'charm', value = 2}],
			tags = ['linked_event','active_character_translate'],
			options = [
				{code = 'fight_skirmish', text = tr("DIALOGUEFIGHTOPTION"), reqs = []},
				],
				
			}
		],
	},
	
	event_nothing_found = {text = tr("DIALOGUEEVENTNOTHING"), 
	tags = ['good'],
	default_event_type = "location",
	image = 'noevent', 
	bonus_args = {},
	options = [
	{code = 'leave', reqs = [], text = tr("DIALOGUELEAVEOPTION")}
	]
	},
	
	#items with options
	
	minorus_potion_select = {text = tr("DIALOGUEEVENTMINORUSSELECT"), 
	tags = ['custom_effect','active_character_translate'],
	image = 'pot', 
	options = [
	{code = 'minorus_tits', reqs = [], text = tr("DIALOGUETITSSELECT")},
	{code = 'minorus_ass', reqs = [], text = tr("DIALOGUEASSSELECT")},
	{code = 'minorus_balls', reqs = [{type = 'active_character_checks', value = [{code = 'bodypart', name = 'balls_size', operant = 'neq', value = ''}]}], text = tr("DIALOGUEBALLSSELECT")},
	{code = 'minorus_penis', reqs = [{type = 'active_character_checks', value = [{code = 'bodypart', name = 'penis_size', operant = 'neq', value = ''}]}], text = tr("DIALOGUEPENISSELECT")},
	]
	},
	majorus_potion_select = {text = tr("DIALOGUEEVENTMAJORUSSELECT"), 
	tags = ['custom_effect','active_character_translate'],
	image = 'pot', 
	options = [
	{code = 'majorus_tits', reqs = [], text = tr("DIALOGUETITSSELECT")},
	{code = 'majorus_ass', reqs = [], text = tr("DIALOGUEASSSELECT")},
	{code = 'majorus_balls', reqs = [{type = 'active_character_checks', value = [{code = 'bodypart', name = 'balls_size', operant = 'neq', value = ''}]}], text = tr("DIALOGUEBALLSSELECT")},
	{code = 'majorus_penis', reqs = [{type = 'active_character_checks', value = [{code = 'bodypart', name = 'penis_size', operant = 'neq', value = ''}]}], text = tr("DIALOGUEPENISSELECT")},
	]
	},
	
	minorus_potion_tits = {text = tr("DIALOGUEMINORUSPOTTITS"), image = 'potmaj', tags = [], options = [{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")}]},
	minorus_potion_ass = {text = tr("DIALOGUEMINORUSPOTASS"), image = 'potmaj', tags = [], options = [{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")}]},
	minorus_potion_penis = {text = tr("DIALOGUEMINORUSPOTPENIS"), image = 'potmaj', tags = [], options = [{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")}]},
	minorus_potion_balls = {text = tr("DIALOGUEMINORUSPOTBALLS"), image = 'potmaj', tags = [], options = [{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")}]},
	majorus_potion_tits = {text = tr("DIALOGUEMAJORUSPOTTITS"), image = 'potmaj', tags = [], options = [{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")}]},
	majorus_potion_ass = {text = tr("DIALOGUEMAJORUSPOTASS"), image = 'potmaj', tags = [], options = [{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")}]},
	majorus_potion_penis = {text = tr("DIALOGUEMAJORUSPOTPENIS"), image = 'potmaj', tags = [], options = [{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")}]},
	majorus_potion_balls = {text = tr("DIALOGUEMAJORUSPOTBALLS"), image = 'potmaj', tags = [], options = [{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")}]},
	potion_no_effect = {text = tr("DIALOGUEPOTIONNOEFFECT"), image = 'potmaj', tags = [], options = [{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")}]},
	
	#Action events
	enslave = {text = tr("DIALOGUEENSLAVETEXT"), image = 'warn', tags = ['active_character_translate'], options = [{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")}]},
	hire = {text = tr("DIALOGUEHIRETEXT"), image = 'praise', tags = ['active_character_translate'], options = [{code = 'close', reqs = [], text = tr("DIALOGUECLOSE")}]},
	
	#Story Events
	daisy_meet = {
		text = tr('SCENEDAISY_MEET_TEXT'),
		tags = ['linked_event'],#linked_event means that all options will trigger other events by name instead of generic options like 'close' or 'inspect'
		receiver = 'master', #not used yet but supposed to represent a group of characters involved into event
		image = 'daisystart',
		opp_characters = [{type = 'pregen', value = 'Daisy'}],
		options = [
		{code = 'daisy_purchase', text = tr("SCENEDAISY_MEET_OPTION1"), reqs = []},
		{code = 'daisy_claim_kinship', text =  tr("SCENEDAISY_MEET_OPTION2"), reqs = [{type = 'master_is_beast', value = true}]},
		{code = 'daisy_ignore_purchase', text = tr("SCENEDAISY_MEET_OPTION3"), reqs = []},
		],
	},
	daisy_claim_kinship = {
		text = tr("SCENEDAISY_CLAIM_KINSHIPTEXT"),
		tags = [],
		receiver = 'master',
		image = 'daisystart',
		common_effects = [{code = 'make_story_character', value = 'Daisy'},{code = 'add_timed_event', value = "daisy_first_event", args = [{type = 'add_to_date', date = [4,6], hour = 18}]}],
		options = [
		{code = 'close', text = tr('DIALOGUECLOSE'), reqs = []},
		],
	},
	daisy_purchase = {
		text = tr("SCENEDAISY_PURCHASE_TEXT"),
		tags = ['linked_event'],
		receiver = 'master',
		image = 'daisystart',
		options = [{code = 'daisy_purchase_negotiate', text = tr("SCENEDAISY_PURCHASE_OPTION1"), reqs = []},
		{code = 'daisy_purchase_confirm', text = tr("SCENEDAISY_PURCHASE_OPTION2"), reqs = [{type = "has_money", value = 200}]},
		{code = 'daisy_purchase_leave', text = tr("SCENEDAISY_PURCHASE_OPTION3"), reqs = []},
		],
	},
	daisy_purchase_negotiate = {
		variations = [ #variations are used if previous option can have multiple outcomes. If variation's requirements are passed it triggers and the rest is ignored. Priority is set by order. 
			{reqs = [{type = 'master_check', value = [{code = 'stat', type = 'charm_factor', operant = 'gte', value = 3}, {code = 'stat', type = 'charm', operant = 'gte', value = 15, orflag = true}]}],
			text = tr("SCENEDAISY_PURCHASE_NEGOTIATE_TEXT1"),
			common_effects = [],
			tags = ['linked_event'],
			image = 'daisystart',
			options = [
				{code = 'daisy_purchase_confirm_discount', text = tr("SCENEDAISY_PURCHASE_OPTION2"), reqs = [{type = "has_money", value = 100}]},
				{code = 'daisy_purchase_leave', text = tr("SCENEDAISY_PURCHASE_OPTION3"), reqs = []},
				]
			},
			{reqs = [],
			text = tr("SCENEDAISY_PURCHASE_NEGOTIATE_TEXT2"),
			image = 'daisystart',
			common_effects = [],
			tags = ['linked_event'],
			options = [
				{code = 'daisy_purchase_confirm', text = tr("SCENEDAISY_PURCHASE_OPTION2"), reqs = [{type = "has_money", value = 200}]},
				{code = 'daisy_purchase_leave', text = tr("SCENEDAISY_PURCHASE_OPTION3"), reqs = []},
				],
				
			}
		],
	},
	daisy_purchase_confirm = {
		text = tr("SCENEDAISY_PURCHASE_CONFIRM_TEXT"),
		tags = [],
		receiver = 'master',
		image = 'daisystart',
		common_effects = [{code = 'money_change', operant = '-', value = 200}, 
		{code = 'make_story_character', value = 'Daisy'}, #make_story_character takes character data from worldgen.pregen_characters
		{code = 'add_timed_event', value = "daisy_first_event", args = [{type = 'add_to_date', date = [4,6], hour = 18}]}],
		options = [
		{code = 'close', text = tr('DIALOGUECLOSE'), reqs = []},
		],
	},
	daisy_purchase_confirm_discount = {
		text = tr("SCENEDAISY_PURCHASE_CONFIRM_TEXT"),
		tags = [],
		receiver = 'master',
		image = 'daisystart',
		common_effects = [{code = 'money_change', operant = '-', value = 100}, {code = 'make_story_character', value = 'Daisy'}, {code = 'add_timed_event', value = "daisy_first_event", args = [{type = 'add_to_date', date = [4,6], hour = 18}]}],
		options = [
		{code = 'close', text = tr('DIALOGUECLOSE'), reqs = []},
		],
	},
	daisy_purchase_leave = {
		text = tr("SCENEDAISY_PURCHASE_LEAVE_TEXT"),
		tags = [],
		receiver = 'master',
		image = 'daisystart',
		common_effects = [],
		options = [
		{code = 'close', text = tr('DIALOGUECLOSE'), reqs = []},
		],
	},
	daisy_ignore_purchase = {
		text = tr("SCENEDAISY_IGNORE_TEXT"),
		tags = [],
		receiver = 'master',
		image = 'daisystart',
		common_effects = [],
		options = [
		{code = 'close', text = tr('DIALOGUECLOSE'), reqs = []},
		],
	},
	
	daisy_first_event = {
		text = tr("SCENEDAISY_FIRST_EVENT_TEXT"),
		tags = ['linked_event'],
		receiver = 'master',
		reqs = [{type = 'unique_character_at_mansion', value = 'daisy', negative = 'repeat_next_day'}],#this requirement only applies when checking timed_events. 'negative' means what resolution should apply when requirement is not met.
		image = 'daisyevent',
		options = [
		{code = 'daisy_first_event_reassure', text = tr("SCENEDAISY_FIRST_EVENT_OPTION1"), reqs = []},
		{code = 'daisy_first_event_discipline', text = tr("SCENEDAISY_FIRST_EVENT_OPTION2"), reqs = []},
		],
	},
	daisy_first_event_reassure = {
		text = tr("SCENEDAISY_FIRST_EVENT_REASSURE"),
		tags = [],
		receiver = 'master',
		image = 'daisyevent',
		common_effects = [#common_effects are treated in state by applying simple changes to game state and characters.
		{code = 'add_timed_event', value = "daisy_confess_event", args = [{type = 'add_to_date', date = [7,10], hour = 20}]},
		{code = 'unique_character_changes', value = 'daisy', args = [ #unique_character_changes takes an unique character and apply specific values to their values with exceptions of traits and tags which treated separately
			{code = 'tame_factor', value = 1, operant = "+"},
			{code = 'obedience', operant = '+', value = 75}
			]},
		],
		options = [
		{code = 'close', text = tr('DIALOGUECLOSE'), reqs = []},
		],
	},
	daisy_first_event_discipline = {
		text = tr("SCENEDAISY_FIRST_EVENT_DISCIPLINE"),
		tags = [],
		receiver = 'master',
		image = 'daisyevent',
		common_effects = [{code = 'unique_character_changes', value = 'daisy', args = [
			{code = 'sexuals_factor', value = 1, operant = "+"},
			{code = 'sextrait', value = 'submissive', operant = 'add'},#for sextrait/add setting, trait is appended to character's traits
			{code = 'fear', operant = '+', value = 75},
			{code = 'obedience', operant = '+', value = 30},
			{code = 'tag', operant = 'remove', value = 'no_sex'},
			]}],
		options = [
		{code = 'close', text = tr('DIALOGUECLOSE'), reqs = []},
		],
	},
	daisy_confess_event = {
		text = tr("SCENEDAISY_CONFESS_EVENT_TEXT"),
		tags = ['linked_event','master_translate'],
		reqs = [{type = 'unique_character_at_mansion', value = 'daisy', negative = 'repeat_next_day'}],
		receiver = 'master',
		image = 'daisyconfess',
		options = [
		{code = 'daisy_confess_accept', text = tr("SCENEDAISY_CONFESS_EVENT_OPTION1"), reqs = []},
		{code = 'daisy_confess_refuse', text = tr("SCENEDAISY_CONFESS_EVENT_OPTION2"), reqs = []},
		],
	},
	daisy_confess_accept = {
		text = tr("SCENEDAISY_CONFESS_ACCEPT_TEXT"),
		tags = [],
		receiver = 'master',
		image = 'daisyconfess',
		common_effects = [
		{code = 'unique_character_changes', value = 'daisy', args = [
			{code = 'growth_factor', value = 1, operant = "+"},
			{code = 'wits_factor', value = 1, operant = "+"},
			{code = 'obedience', operant = '+', value = 75},
			{code = 'tag', operant = 'remove', value = 'no_sex'},
			]},
		],
		options = [
		{code = 'close', text = tr('DIALOGUECLOSE'), reqs = []},
		],
	},
	daisy_confess_refuse = {
		text = tr("SCENEDAISY_CONFESS_REFUSE_TEXT"),
		tags = [],
		receiver = 'master',
		image = 'daisyconfess',
		common_effects = [
		{code = 'unique_character_changes', value = 'daisy', args = [
			{code = 'tag', operant = 'remove', value = 'no_sex'},
			]},
		],
		options = [
		{code = 'close', text = tr('DIALOGUECLOSE'), reqs = []},
		],
	},
	
	
	
}