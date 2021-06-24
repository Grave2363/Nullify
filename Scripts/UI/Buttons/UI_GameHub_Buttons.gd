extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var thisScene = "res://Scenes/UI/UI_GameHub.tscn"
onready var pop = get_parent().get_node("WinPopup/PopupDialog") #$WinPopup/PopupDialog
onready var settingsPop = get_parent().get_node("Pause_Pop_Up") #$WinPopup/PopupDialog
onready var timer = $ScorePanel
# Called when the node enters the scene tree for the first time.
#func _ready():
#	if(!Global.get_isTutorial() && !Global.get_isCustom()): # still need to account for custom play
#		$BoardSizeLabel.text = "Board Size: " + Global.cur_board + " Free Num: " + Global.freenum
#	else:
#		$BoardSizeLabel.hide()


func _on_HomeButton_pressed():
	Global.set_isTutorial(false)
	Global.set_isCustomPlay(false)
	Global.set_isRoadMap(false)
	Global.set_isLevelReset(false)
	ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")


func _on_SettingsButton_pressed():
	MusicPlayer.onPause()
	Global.emit_pause()
	settingsPop.show_main_pop()

# for Android back button
func _notification(what):
# this is primarily for Windows quit, but it doesnt seem like an issue	
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
#		pass
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		MusicPlayer.onPause()
		Global.emit_pause()
		settingsPop.show_main_pop()
		
#### FOR TESTING POPUP ONLY ####
func _on_TestButton_pressed():
	if(pop != null):
		print("POP")
		pop.popup()
