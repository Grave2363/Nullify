extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currLevel = 1

### CRATING THE FUNCTION TO UNLOCK LEVELS 
### THAT THE USER CAN ACCESS <- EMILIO
func _ready():
	var file = File.new()
	if file.file_exists("user://level.dat"):
		var err = file.open("user://level.dat", File.READ)
		if err == OK:
			currLevel = file.get_32()
			print(currLevel)
			file.close()
	else:
		var err = file.open("user://level.dat", File.WRITE)
		if err == OK:
			file.store_32(1)
			file.close()
	
	unlock_levels()
	

func unlock_levels():
	if currLevel != 10:
		$BossLevel.disabled = true
	if currLevel < 9:
		$HBoxContainer3/Level9.disabled = true
	if currLevel < 8:
		$HBoxContainer3/Level8.disabled = true
	if currLevel < 7:
		$HBoxContainer3/Level7.disabled = true
	if currLevel < 6:
		$HBoxContainer2/Level6.disabled = true
	if currLevel < 5:
		$HBoxContainer2/Level5.disabled = true
	if currLevel < 4:
		$HBoxContainer2/Level4.disabled = true
	if currLevel < 3:
		$HBoxContainer/Level3.disabled = true
	if currLevel < 2:
		$HBoxContainer/Leve2.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackButton_pressed():
	MusicPlayer.onBackButton()
	Global.set_isRoadMap(false)
	ChangeScenes.change_scene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade")
	
func _notification(what):
# this is primarily for Windows quit, but it doesnt seem like an issue	
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
#		pass
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		MusicPlayer.onBackButton()
		Global.set_isRoadMap(false)
		ChangeScenes.change_scene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade")

func _on_Level1_pressed():
	MusicPlayer.onConfirm()
	Global.set_roadMapLevel(1)
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")


func _on_Leve2_pressed():
	MusicPlayer.onConfirm()
	Global.set_roadMapLevel(2)
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")


func _on_Level3_pressed():
	MusicPlayer.onConfirm()
	Global.set_roadMapLevel(3)
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")


func _on_Level4_pressed():
	MusicPlayer.onConfirm()
	Global.set_roadMapLevel(4)
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")


func _on_Level5_pressed():
	MusicPlayer.onConfirm()
	Global.set_roadMapLevel(5)
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")


func _on_Level6_pressed():
	MusicPlayer.onConfirm()
	Global.set_roadMapLevel(6)
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")


func _on_Level7_pressed():
	MusicPlayer.onConfirm()
	Global.set_roadMapLevel(7)
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")


func _on_Level8_pressed():
	MusicPlayer.onConfirm()
	Global.set_roadMapLevel(8)
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")


func _on_Level9_pressed():
	MusicPlayer.onConfirm()
	Global.set_roadMapLevel(9)
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")


func _on_BossLevel_pressed():
	MusicPlayer.onConfirm()
	Global.set_roadMapLevel(10)
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")
