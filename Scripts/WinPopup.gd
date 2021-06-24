extends CanvasLayer

onready var button = $PopupDialog/Button
onready var finalScore = $PopupDialog/ScoreLabel
onready var playedMusic = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.isRoadMap:
		button.text = "Next"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_final_score(score):
	finalScore.text = "Score: " + str(score)

func _on_Button_pressed():
	#DEV EMILIO ->
	#STOPS GAME BREAKING BUG OF UNABLE TO COMPLETE LEVEL ONCE OFF-SCREEN
	var backTo = get_parent().get_node("Background/BackToWin")
	MusicPlayer.onConfirm()
	var pop = $PopupDialog
	Global.set_isTutorial(false)
	Global.set_isCustomPlay(false)
	Global.set_isLevelReset(false)
	Global.set_isLevelEditor(false)
	Global.set_is_input_handled(false)
	Global.set_is_input_disabled(false)
	if !Global.get_is_add_button():
		Global.toggle_is_add_button()
	backTo.disabled = true
	playedMusic = false
	pop.hide()
	if Global.isRoadMap:
		if Global.roadMapLevel == 10:
			ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")	
		else:
			print(Global.get_roadMapLevel())
			Global.set_roadMapLevel(Global.get_roadMapLevel() + 1)
			print(Global.get_roadMapLevel())
			ChangeScenes.change_scene("res://Scenes/UI/UI_GameHub.tscn", "Fade")
	else:
		ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")
		
# retrieve final score
func _on_PopupDialog_about_to_show():
	#DEV EMILIO ->
	#STOPS GAME BREAKING BUG OF UNABLE TO COMPLETE LEVEL ONCE OFF-SCREEN
	var undo = get_parent().get_node("UI/HBoxContainer/UndoButton")
	var settings = get_parent().get_node("UI/HBoxContainer/SettingsButton")
	var reset = get_parent().get_node("UI/HBoxContainer/ResetButton")
	var backTo = get_parent().get_node("Background/BackToWin")
	undo.disabled = true
	settings.disabled = true
	reset.disabled = true
	backTo.disabled = false
	
	var score = get_parent().get_node("UI/ScorePanel")
	finalScore.text = str(score.get_score())
	if !playedMusic:
		MusicPlayer.onWin()
		playedMusic = true
	pass # Replace with function body.
