extends Control
# warning-ignore-all:return_value_discarded

var current_tutorial

var tutorial_themes = {
	introduction = {name = "Introduction", text = "This is your Mansion Screen. At the right side you can see your character list. At the left side is your Task list. Make yourself familiar with your characters by clicking on them."},
	slavetab = {name = "Character Tab", text = "This is the character panel. It contains most of the character's information and allows you to control it. Your characters are your main possessions.\nCharacters consume food every day, which is represented by Food Consumption stat on the left. Different characters require different amount of it, which, similar to other stats, often tied to race. Characters can be assigned to work by selecting Job menu. This way you can start utilize them. "},
	tasklist = {name = "Task List", text = "Task list shows up ongoing tasks. Once progress bar is filled, you receive an item to your storage. You can hover over the task to see what workers are assigned to it."},
	outside = {name = 'Exploration', text = ''},
	crafting = {name = "Crafting", text = "To craft an item, select the number of desired items, then assign a worker to task, responsible for production. Resources will be consumed when each new item starts its production. You can unlock more crafts by making upgrades and finding new recipes."},
	upgrades = {name = "Upgrades", text = "After selecting an upgrade, make sure to assign a character to work on it. Physics and Wits, as well as certain classes can improve upgrading speed."},
}

func _ready():
	rebuild()
	for i in tutorial_themes:
		tutorial_themes[i].code = i
	$Panel/HBoxContainer/Hide.connect("pressed", self, "hide_text_window")
	$Panel/HBoxContainer/Dismiss.connect("pressed",self, "confirm_message")
	$Panel/HBoxContainer/Stop.connect("pressed",self,'stop_tutorial')

func rebuild():
	if state.show_tutorial == false:
		hide_node()
		return
	if self.visible == false:
		input_handler.UnfadeAnimation(self, 0.3)
	globals.ClearContainer($Container)
	
	for i in state.active_tutorials:
		if !tutorial_themes.has(i):
			continue
		var tut_data = tutorial_themes[i]
		var newbutton = globals.DuplicateContainerTemplate($Container)
		newbutton.text = tut_data.name
		newbutton.connect('pressed', self, 'show_tutorial_window', [i])
	
	yield(get_tree(), 'idle_frame')
	if $Container.get_child_count() <= 1:
		hide_node()

func activate_tutorial(code):
	state.active_tutorials.append(code)
	rebuild()

func show_tutorial_window(data):
	current_tutorial = data
	
	$Panel.show()
	$Panel/RichTextLabel.bbcode_text = tutorial_themes[data].text

func hide_node():
	input_handler.FadeAnimation(self, 0.3)

func hide_text_window():
	$Panel.hide()

func confirm_message():
	hide_text_window()
	state.seen_tutorials.append(current_tutorial)
	state.active_tutorials.remove(current_tutorial)
	rebuild()

func stop_tutorial():
	input_handler.ShowConfirmPanel(self, 'stop_tutorial_confirm', "Disable Tutorial Tips?")

func stop_tutorial_confirm():
	state.show_tutorial = false
	rebuild()