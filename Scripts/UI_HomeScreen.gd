extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	ChangeScenes.change_scene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade")

	#maybe add adnimatoon control to scene?
	


func OnPlayPressed():
	pass # Replace with function body.
