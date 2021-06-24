#  /***   DEV EMILIO   ***/
#  /***   !!OPTIMIZE!! ORIGINALLY WE HAD THIS CLASS TO USE FOR THE PLAYER'S SCORE   ***/
#  /***   !!CHANGE!!   <-  THIS SHOULD SIMPLY BE A GLOBAL VARIABLE   ***/


extends Panel
onready var score = get_node("Label")
onready var timer = get_node("Label/Timer")
onready var finalScore = get_node("../../WinPopup")
var g_score = 10000

func _ready():
	score.text = str(Global.get_score())
	start_timer()

func start_timer():
	timer.start()

func End_timer():
	timer.stop()
	finalScore.set_final_score(Global.get_score())

func _on_Timer_timeout():
	sub_score()

func sub_score():
	Global.set_score((Global.get_score()) - 5)
	score.text = str(Global.get_score())

func set_base_score(num):
	Global.set_score(num)
	score.text = str(Global.get_score())
	timer.start()

func player_removed():
	Global.set_score((Global.get_score()) + 200)
	score.text = str(Global.get_score())
	timer.start()

func collectable_removed():
	Global.set_score((Global.get_score()) + 500)
	score.text = str(Global.get_score())
	timer.start()

func collectable_added():
	Global.set_score((Global.get_score()) - 500)
	score.text = str(Global.get_score())
	timer.start()

func get_score():
	return int(Global.get_score())


