extends Control


func _ready():
	$Control/CreditsText.bbcode_text = "[center][b]Created by[/b]:\nKaleah Lubin\n[b]Developed by:[/b]\nKaleah Lubin\nEmilio Benavente\nAngelo Nicotra\n[b]Produced by:[/b]\n Rebecca Carroll\nZachary Gilbert\n[b]Special Thanks to:[/b]\n Glim Music, for menu music\nSabrina Wood for UI/UX advisory\n[b]Copyright 2021[/b][center]"

func _on_BackButton_pressed():
	MusicPlayer.onBackButton()
	ChangeScenes.change_scene("res://Scenes/UI/UI_Settings.tscn", "Fade")
