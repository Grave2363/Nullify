extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var thisScene = "res://Scenes/UI/UI_HomeScreen.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set_isCustomPlay(false)
	Global.set_isTutorial(false)
	

func _on_Play_pressed():
	MusicPlayer.onConfirm()
	ChangeScenes.change_scene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade")

# for handling Android back button 
func _notification(what):
# quit_request is for Windows, cant really do anything special
	#if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST 
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		# show exit popup
		MusicPlayer.onConfirm()
		get_parent().get_node("ExitGamePopup").show()
	
func _on_Settings_pressed():
	MusicPlayer.onConfirm()	
	ChangeScenes.set_prev_scene(thisScene)
	ChangeScenes.change_scene("res://Scenes/UI/UI_Settings.tscn", "Fade")


func _on_Quit_pressed():
	MusicPlayer.onConfirm()
	get_tree().quit()


func _on_Tutorial_pressed():
	MusicPlayer.onConfirm()
	#set TUTORIAL MODE to true
	Global.set_isTutorial(true)
	Global.set_max_val(64)
	#call game hub, but it should initialize on tutorial mode
	ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")


func _on_Leaderboard_pressed():
	MusicPlayer.onConfirm()
	ChangeScenes.set_prev_scene(thisScene)
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard_Selection.tscn", "Fade")


func _on_login_pressed():
	MusicPlayer.onConfirm()
	ChangeScenes.set_prev_scene(thisScene)
	ChangeScenes.change_scene("res://Scenes/Firebase/Sign_in.tscn", "Fade")
