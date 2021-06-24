extends Node2D


func _on_Easy_pressed():
	MusicPlayer.onConfirm()
	Global.set_diff(Global.diff.EASY)


func _on_Medium_pressed():
	MusicPlayer.onConfirm()
	Global.set_diff(Global.diff.MEDIUM)


func _on_Hard_pressed():
	MusicPlayer.onConfirm()
	Global.set_diff(Global.diff.HARD)


func _on_BackButton_pressed():
	MusicPlayer.onBackButton()
	ChangeScenes.change_scene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade")

	# for handling Android back button 
func _notification(what):
# this is primarily for Windows quit, but it doesnt seem like an issue	
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
#		pass
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		MusicPlayer.onBackButton()
		ChangeScenes.change_scene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade")

func _on_5x5_pressed():
	Global.set_grid(Global.gridSize.FIVE)
	Global.set_max_val(16)
	if !diff_null_check():
		ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")

func _on_6x6_pressed():
	Global.set_grid(Global.gridSize.SIX)
	Global.set_max_val(32)
	if !diff_null_check():
		ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")


func _on_8x8_pressed():
	Global.set_grid(Global.gridSize.EIGHT)
	Global.set_max_val(64)
	if !diff_null_check():
		ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")

# if no difficulty was selected 
# either return if null or set it to a default	
# this is specifically against crashes on fresh installs
func diff_null_check():
	if Global.get_grid() == null:
		return
