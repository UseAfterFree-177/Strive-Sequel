extends Node

var slave_number = 0

func start():
	if game_globals.starting_preset == '' || starting_presets.preset_data.has(game_globals.starting_preset) == false:
		print('Error: no preset exists')
		return
	var data = starting_presets.preset_data[game_globals.starting_preset]
	game_res.money = data.gold
	slave_number = data.free_slave_number
	for i in data.materials:
		game_res.materials[i] = data.materials[i]
	for i in data.upgrades:
		game_res.upgrades[i] = data.upgrades[i]
	
	input_handler.get_spec_node(input_handler.NODE_CHARCREATE, ['master'])
	yield(input_handler, 'CharacterCreated')
	if data.code != 'default':
		game_progress.mainprogress = 1
		while slave_number > 0:
			slave_number -= 1
			input_handler.get_spec_node(input_handler.NODE_CHARCREATE, ['slave'])
			yield(input_handler, 'CharacterCreated')
	else:
		game_progress.mainprogress = 0
	
	finish()

func finish():
	input_handler.emit_signal("StartingSequenceComplete")

