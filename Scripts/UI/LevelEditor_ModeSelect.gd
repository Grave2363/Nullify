extends Node2D




func _on_BackButton_pressed():
	MusicPlayer.onBackButton()
	Global.set_isRoadMap(false)
	Global.set_isLevelEditor(false)
	ChangeScenes.change_scene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade")
	


func _on_5x5_pressed():
	MusicPlayer.onConfirm()
	Global.set_grid(Global.gridSize.FIVE)
	Global.set_max_val(16)
	ChangeScenes.change_scene("res://Scenes/UI/LevelEditor_5x5.tscn", "Fade")
	


func _on_6x6_pressed():
	MusicPlayer.onConfirm()
	Global.set_grid(Global.gridSize.SIX)
	Global.set_max_val(32)
	ChangeScenes.change_scene("res://Scenes/UI/LevelEditor_6x6.tscn", "Fade")
	

func _on_8x8_pressed():
	MusicPlayer.onConfirm()
	Global.set_grid(Global.gridSize.EIGHT)
	Global.set_max_val(64)
	ChangeScenes.change_scene("res://Scenes/UI/LevelEditor_8x8.tscn", "Fade")
