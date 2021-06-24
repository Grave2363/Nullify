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

func _on_BackButton_pressed():
	MusicPlayer.onBackButton()
	ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")
	Global.set_isRoadMap(false)
	Global.set_isCustomPlay(false)

	# for handling Android back button 
func _notification(what):
# this is primarily for Windows quit, but it doesnt seem like an issue	
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
#		pass
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		MusicPlayer.onBackButton()
		ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")
		Global.set_isRoadMap(false)
		Global.set_isCustomPlay(false)


func _on_RoadMap_pressed():
	MusicPlayer.onConfirm()
	Global.set_isRoadMap(true)
	ChangeScenes.change_scene("res://Scenes/UI/UI_RoadMap1.tscn", "Fade")


func _on_StandardPlay_pressed():
	MusicPlayer.onConfirm()
	ChangeScenes.change_scene("res://Scenes/UI/UI_LevelSelect.tscn", "Fade")


func _on_CustomPlay_pressed():
	MusicPlayer.onConfirm()
	Global.set_isCustomPlay(true)
	ChangeScenes.change_scene("res://Scenes/UI/UI_CustomPlay.tscn", "Fade")


func _on_LevelEditor_pressed():
	MusicPlayer.onConfirm()
	Global.set_isLevelEditor(true)
	ChangeScenes.change_scene("res://Scenes/UI/LevelEditor_ModeSelect.tscn", "Fade")
