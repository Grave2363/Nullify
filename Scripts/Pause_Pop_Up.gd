extends CanvasLayer
onready var mainPopUp = $PopupDialog
onready var secondaryPopUp = $PopupDialog2
onready var quickRulesPopUp = $QuickRulesPopup/Popup
onready var music_box = $PopupDialog/Node2D/VSplitContainer/Music_slider
onready var sfx_box = $PopupDialog/Node2D/VSplitContainer2/SFX_Slider

func _ready():
	if !MusicPlayer.getMusicBoolean():
		music_box.pressed = false
	if !MusicPlayer.getSFXBoolean():
		sfx_box.pressed = false

func show_main_pop():
	mainPopUp.show()

func _on_Home_pressed():
	MusicPlayer.onConfirm()
	secondaryPopUp.show()
	mainPopUp.show()


func _on_Close_pressed():
	MusicPlayer.onBackButton()
	mainPopUp.hide()
	Global.emit_play()


func _on_How_To_pressed():
	MusicPlayer.onConfirm()
	quickRulesPopUp.show()
	mainPopUp.hide()


func _on_No_pressed():
	MusicPlayer.onConfirm()
	secondaryPopUp.hide()
	mainPopUp.show()


func _on_Yes_pressed():
	MusicPlayer.onConfirm()
	Global.set_isTutorial(false)
	Global.set_isCustomPlay(false)
	Global.set_isRoadMap(false)
	Global.set_isLevelReset(false)
	Global.set_isLevelEditor(false)
	Global.set_is_input_handled(false)
	Global.set_is_input_disabled(false)
	if !Global.get_is_add_button():
		Global.toggle_is_add_button()
	mainPopUp.hide()
	ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")
	secondaryPopUp.hide()
	ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn","Fade")
	MusicPlayer.tempTurnOffSFX();
	

func _on_SFX_Slider_pressed():
	MusicPlayer.SwapSFXBoolean()


func _on_Music_slider_pressed():
	MusicPlayer.SwapMusicBoolean()
