extends Node2D

var this_scene : String

func _ready():
	this_scene = self.get_name()




func _on_Start_pressed():
	ChangeScenes.set_prev_scene(this_scene)
	ChangeScenes.change_scene('res://Scenes/BuildBoardScene.tscn', 'Fade')


func _on_Settings_pressed():
	pass



func _on_Quit_pressed():
	get_tree().quit()
