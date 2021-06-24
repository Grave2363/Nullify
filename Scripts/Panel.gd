extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var merge_button = $HBoxContainer/AddButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AddButton_pressed():

	if merge_button.icon == preload("res://icons/merge/outline_add_black_48dp.png"):
		merge_button.icon = preload("res://icons/merge/outline_close_black_48dp.png")
	elif merge_button.icon == preload("res://icons/merge/outline_close_black_48dp.png"):
		merge_button.icon = preload("res://icons/merge/outline_add_black_48dp.png")

