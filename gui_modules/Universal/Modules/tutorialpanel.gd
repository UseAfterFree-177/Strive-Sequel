extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("pressed",self,"hide")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass