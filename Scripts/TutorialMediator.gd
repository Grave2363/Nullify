extends Node

onready var node = get_node("/root/res/Scenes/UI/UI_GameHub/GameBoard/PanelContainer/BoardNode")

# So here's what I want to do: 
# Make a signal here
# gauge the conditionals in process* (*this could go in either process or input, will have to play with it first)
# when the condition is met, this will emit signal to tutorial panel
# tutorial panel on signal recieved will execute next line of script or specific line of script based on conditional 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if conditional is met
	# if the first element of the player && its value is 12
	# emit
	# if the first element is 0, or for how the code works, if the first element is now 63 
	# emit
	# if the selected element is 8, more specifically, if 8's index has changed to 2 && its selected
	# emit
	# if that 8 is now a 6
	# emit
	# if object 3 and 3 is on coordinate (1,5) (2, 5) *
	# emit
	# if size of colletibles array is 1 (?)
	# emit
	# if the selected element is 64
	# emit
	# if the only element is player array is 1 ie 13
	# emit
	# if size of player is 0
	# emit
	# ...
	# emit signal
	pass
	
func _input(event):
	pass
