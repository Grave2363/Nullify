extends Node2D

onready var board = $GameBoard/PanelContainer/BoardNode


func _ready():
	MusicPlayer.onGameHub()
	#if TUTORIAL MODE is enabled
	if (Global.get_isTutorial() == true):
		$UI/ScorePanel.hide()
		$UI/TutorialPanel.show()
		#print(board.GetPlayer(0))
	else:
		$UI/TutorialPanel.hide()

