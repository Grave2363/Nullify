extends Node2D
#onready var music_slider = $VBoxContainer/VSplitContainer_Music/Music
#onready var sfx_slider = $VBoxContainer/VSplitContainer_SFX/SFX
onready var quickRulesPopup = $QuickRulesPopup/Popup
onready var creditsButton = $CreditsButton
onready var music_box = $VBoxContainer/VSplitContainer_Music/Music
onready var sfx_box = $VBoxContainer/VSplitContainer_SFX/SFX


func _ready():
	if !MusicPlayer.getMusicBoolean():
		music_box.pressed = false
	if !MusicPlayer.getSFXBoolean():
		sfx_box.pressed = false

func _on_BackButton_pressed():
	MusicPlayer.onBackButton()
	ChangeScenes.go_back("Fade")

func _notification(what):
# this is primarily for Windows quit, but it doesnt seem like an issue	
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
#		pass
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		MusicPlayer.onBackButton()
		ChangeScenes.go_back("Fade")

func _on_QuickRulesButton_pressed():
	MusicPlayer.onConfirm()
	quickRulesPopup.show()


func _on_Music_pressed():
	MusicPlayer.SwapMusicBoolean()

func _on_SFX_pressed():

	MusicPlayer.SwapSFXBoolean()

func _on_CreditsButton_pressed():
	MusicPlayer.onConfirm()
	ChangeScenes.change_scene("res://Scenes/UI/Credits.tscn", "Fade")
