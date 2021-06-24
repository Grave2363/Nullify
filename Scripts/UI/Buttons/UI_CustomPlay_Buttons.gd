extends Node2D


var playerNum = 0
var maxNum = 0
var MapSize = 0
var ImmenentTileNum = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackButton_pressed():
	MusicPlayer.onBackButton()
	ChangeScenes.change_scene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade")

# for Android back button
func _notification(what):
# this is primarily for Windows quit, but it doesnt seem like an issue	
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
#		pass
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		MusicPlayer.onBackButton()
		ChangeScenes.change_scene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade")

func _on_PlayerNum_text_changed(new_text):
	playerNum = int(new_text)

func _on_MapSize_text_changed(new_text):
	if (int(new_text) == 1 || int(new_text) == 5):
		Global.set_grid(Global.gridSize.FIVE)
	elif (int(new_text) == 2 || int(new_text) == 6):
		Global.set_grid(Global.gridSize.SIX)
	elif (int(new_text) == 3 || int(new_text) == 8):
		Global.set_grid(Global.gridSize.EIGHT)
	elif(new_text == "Small" || new_text == "SMALL" ):
		Global.set_grid(Global.gridSize.FIVE)
	elif (new_text == "Medium" || new_text == "MEDIUM" ):
		Global.set_grid(Global.gridSize.SIX)
	elif (new_text == "Large" || new_text == "LARGE" ):
		Global.set_grid(Global.gridSize.EIGHT)


func _on_ImmenentTileNum_text_changed(new_text):
	ImmenentTileNum = int(new_text)

func _on_PlayButton_pressed():
	MusicPlayer.onConfirm()
	Global.set_player_Num(playerNum)
	Global.set_immenent_Num(ImmenentTileNum)
	Global.set_max_val(maxNum)
	Global.set_diff(Global.diff.CUSTOM)
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")

func _on_MaxPlayerValue_text_changed(new_text):
	maxNum = int(new_text)
