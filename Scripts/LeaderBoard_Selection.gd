extends Control


var thisScene = "res://Scenes/Firebase/LeaderBoard_Selection.tscn"
func _ready():
	pass # Replace with function body.



func _on_5x5_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("5x5")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_6x6_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("6x6")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_8x8_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("8x8")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_01_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("01")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_02_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("02")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_03_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("03")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_04_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("04")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_05_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("05")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_06_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("06")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_07_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("07")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_08_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("08")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_09_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("09")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_10_pressed():
	MusicPlayer.onConfirm()
	Global.set_leaderboard_level("Final Level")
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard.tscn", "Fade")


func _on_Settings_pressed():
	MusicPlayer.onConfirm()
	ChangeScenes.set_prev_scene(thisScene)
	ChangeScenes.change_scene("res://Scenes/UI/UI_Settings.tscn", "Fade")


func _on_BackButton_pressed():
	ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")

	MusicPlayer.onBackButton()
	
func _notification(what):
# this is primarily for Windows quit, but it doesnt seem like an issue	
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
#		pass
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")
		MusicPlayer.onBackButton()

