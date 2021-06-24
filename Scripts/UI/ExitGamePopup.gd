extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Yes_pressed():
	get_tree().quit()


func _on_No_pressed():
	hide()
