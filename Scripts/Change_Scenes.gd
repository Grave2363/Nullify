extends CanvasLayer

func _ready():
	pass # Replace with function body.
onready var Animat = $Control/AnimationPlayer
var currGridSize 
var currDiff
var scene : String
var prev_scene : String
func set_grid(grid):
	currGridSize = grid
func set_diff(diff):
	currDiff = diff
# format SceneChanging.change_scene('[scene you want to load]', '[animation you want]')
# ex: SceneChanging.change_scene('res://next_scene.tscn', 'Fade')
# might need to add another var to this for the type of board to make 
func change_scene(n_scene, anima):
	scene = n_scene
	Animat.play(anima)

func set_prev_scene(name):
	prev_scene = name

func go_back(anima):
	scene = prev_scene
	Animat.play(anima)

func get_board():
	return int(currGridSize)

func get_diff():
	return int(currDiff)
# call this from the animation player when you want to change the scene 
func _new_scene():
	get_tree().change_scene(scene)

# call this at the end of the animation in the animation player to prevent looping 
func end_animat():
	Animat.stop()
