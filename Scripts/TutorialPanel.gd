extends Panel


onready var label = $Label
onready var button = $NextButton
onready var addButton = get_parent().get_parent().get_node("GameBoard/Panel/HBoxContainer/AddButton")
onready var changeButton = get_parent().get_parent().get_node("GameBoard/Panel/HBoxContainer/SwapPlayerButton")
onready var splitButton = get_parent().get_parent().get_node("GameBoard/Panel/HBoxContainer/SpliButton")


onready var board = get_parent().get_parent().get_node("GameBoard/PanelContainer/BoardNode")
signal continueScript # for continuing script on conditionals check
signal revertScript # for reverting script when needed on undo pressed

# set all conditions to waiting on start, then make them met as so
# make sure they aren't met
# and when the next conditiinal has been met, set it to done so that it wont trigger again
enum state {WAITING, MET, DONE}

var cond0 = state.WAITING
var cond1 = state.WAITING
var cond2 = state.WAITING
var cond3 = state.WAITING
var cond4 = state.WAITING
var cond5 = state.WAITING
var cond6 = state.WAITING
var cond7 = state.WAITING
var cond8 = state.WAITING
var cond9 = state.WAITING
var cond10 = state.WAITING
var cond11 = state.WAITING

var counter = 2;
var tutorial_dict = {
	1:"Welcome to Nullify!\nLet’s dig in and teach you how the game works!",
	2:"The goal of Nullify is to get rid of all the numbers on the board. Bonus points if you can gather the stars.",
	3:"First, you can tell there are several numbers on this board. You can take control of a certain number by tapping the 'swap' icon button. Try it! ", 
	4:"Your selected number will be highlighted in red. You can also tap on a number to select it. We’re going to deal with 14 first, so make sure the 14 is selected.",
	5:"Good job. Next, let’s show you basic movement! You can drag numbers by swiping horizontally or vertically. Try dragging the 14.",
	6:"The 'add' icon button in the control panel tells the merge mode you’re currently on. This means that swiping the 13 into the 1 will make a 14. Try it!",
	7:"When you move, the 14 will decrement, but don’t be alarmed! When you drag a number, it will decrease until it reaches 0, and then it disappears, POOF!",
	8:"You also notice that the tiles are getting darker. When you move across a tile twice, the tile becomes locked and you can't pass on it unless you have a free number.",
	9: "We’ll get to free numbers later, but for now, keep going until that 14 is a 0!",
	10:"Great. Now let’s talk about individual numbers’ abilities. Change the selected number to the 8 on the bottom left.",
	11:"Even numbers have an added ability of moving diagonally. Get that 8 out of that bind!",
	12:"Now here’s where some magic happens. Tap the 'split' icon button on the control board.",
	13:"Wow! Now that 6 became two 3s. Only even numbers can do this. Alright, now drag the two 3s and try to collect the nearby stars.",
	14:"Excellent, you’re becoming a Nullify pro! Remember about the free number? It's time to use it! But first, tap the add button in the control board to toggle merging to multiply.",
	15:"Awesome! Now you can multiply the 32 with 2. Only even numbers can multiply with each other.",
	16:"Great, we have a 64, but what’s so special about it? This grid is an 8x8, and the “free number” of this board is the max number allowed on board, 64.", 
	17:"A free number can unlock any locked tile! Try freeing that 13 on the bottom right.",
	18:"Awesome! The free number differs depending on the board size; see help in the settings menu to learn more.", 
	19:"We’re almost done. Use that 13 to collect the last star. Warning: this is a bit tricky, so plan out the movement well!",
	20:"Huzzah! You’ve completed your first Nullify puzzle! That wasn’t so bad, was it? You can always come back to this tutorial or access help from the settings.\nHappy Nullifying!"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#by default, start with the first welcoming line
	label.text = tutorial_dict[1]
	# for debugging
	#label.text = tutorial_dict[20]
	
	
func _on_NextButton_pressed(): #works with signal continuescript
	board.Pause()
	_on_continue_script()

		
func _on_continue_script():
	if(counter <tutorial_dict.size()+1):
		if(counter == tutorial_dict.size()): #If it's at the last line, then button exits tutorial
			button.texture_normal = preload("res://icons/home/outline_home_black_24dp.png")
		label.text.empty()
		label.text = tutorial_dict[counter]
		counter = counter+1
	else:
		#do something(s) when tutorial is over, like end game
		#set TUTORIAL MODE to false before leaving
		Global.set_isTutorial(false)
		Global.set_is_input_disabled(false)
		ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")
		
func _on_revert_script():
	if(counter > 0):
		if(counter == tutorial_dict.size()): #If it's at the last line, then button exits tutorial
			button.texture_normal = preload("res://icons/home/outline_home_black_24dp.png")	
			button.texture_pressed = preload("res://icons/home/outline_home_black_pressed_24dp.png")
		label.text.empty()
		counter = counter-1
		label.text = tutorial_dict[counter]

	else:
		pass
		#do something(s) when tutorial is over, like end game
		#set TUTORIAL MODE to false before leaving
#		Global.set_isTutorial(false)
#		ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")
		
func _process(_delta):
	if(Global.get_isTutorial()):
		if (label.text == tutorial_dict[1] 
		||label.text == tutorial_dict[2]
		||label.text == tutorial_dict[7]
		||label.text == tutorial_dict[8]
		||label.text == tutorial_dict[16]
		||label.text == tutorial_dict[18]
		||label.text == tutorial_dict[20]):
			board.Pause()
			show_button()
			disable_control_panel()
		elif(label.text == tutorial_dict[4]):
			board.Pause()
			show_button()
		
		# disable players based on script line
		# and reenable them ON THE CONDITION BEING MET
		else:
			# be default, disable control panel (but not change) except in certain circumsstances
			#disable_player_behavior()
			if label.text == tutorial_dict[3]:
				# disable all players (cond 0)
				board.Pause()
				# be default, disable control panel (but not change) except in certain circumsstances
				disable_player_behavior()
						
			elif label.text == tutorial_dict[5]:
				# disable all but the 14 (cond 1)
				board.InPlay(0)
				board.Play()
				board.ChangeTileColor(1,2)
				# be default, disable control panel (but not change) except in certain circumsstances
				disable_player_behavior()
				
			elif label.text == tutorial_dict[6]:
				#disable all but the 14 and 1 (cond 2)
				board.InPlay(0)
				board.Play()
				board.ChangeTileColor(1,3)
				#enable_control_add()
				
			elif label.text == tutorial_dict[9]:
				#disable all but the 14 and 1 (cond 3)
				board.InPlay(0)
				board.Play()
				around_the_bend_there()
				# be default, disable control panel (but not change) except in certain circumsstances
				disable_player_behavior()
				
			elif label.text == tutorial_dict[10]:
				# once 14 is nullified, disable all but the 8 (cond 4)
				#board.InPlay(2)
				board.Play()
				board.DisablePlayer(0)
				board.DisablePlayer(1)
				# be default, disable control panel (but not change) except in certain circumsstances
				disable_player_behavior()
				
			elif label.text == tutorial_dict[11]:
				# disable all but 8->6 (cond 5)
				board.InPlay(2)
				board.Play()
				board.ChangeTileColor(6,2)
				disable_player_behavior()
				
			elif label.text == tutorial_dict[12]:
				# disable all but 8->6 (cond 6)
				board.InPlay(2)
				board.Pause()
				enable_control_split()

			elif label.text == tutorial_dict[13]:
				# disable all but the two 3s (cond 7)
				if(board.GetNumCollectibles() >1):
					board.ChangeCollectTileColor(1)
					board.InPlay(2)
					board.Play()
					board.ChangeCollectTileColor(2)
				disable_player_behavior()
				enable_control_split()
				

			elif label.text == tutorial_dict[14]:
				# disable all players (cond 8)
				board.InPlay(0)
				board.Pause()
				splitButton.disabled = true
				enable_control_add()
				
			elif label.text == tutorial_dict[17]:
				board.Play()
				
			# for last collectible
			elif label.text == tutorial_dict[19]:
				if(board.GetNumCollectibles()==1):
					board.ChangeCollectTileColor(0)
					board.Play()
					# I've decided to enable the entire control board at this last point. Its pretty hard to mess up terribly 
					# since its the ending, and if the user does undo back enough, they need the control for 6 split and 32,2 merge
					enable_control_panel()
			#dont really need to disable anything else for 15, 17 and 19
			hide_button()
			
			
		# if the 32 is now the first element after the 14 has been nullified
		if cond2 == state.MET:
			if(board.GetPlayer(0) == 32):
				emit_signal("continueScript")
				print("3 cond")
				cond3 = state.MET
				cond2 = state.DONE
				around_the_bend_there_reset()
		
		# if 8 is selected
		if cond3 == state.MET:
			if(board.GetPlayer(2) == 8 && board.GetCurrentPlayer() == 8):
				emit_signal("continueScript")
				print("4 cond")
				cond4 = state.MET
				cond3 = state.DONE

		#if collectable array size is - 2 || on collectible removed
		if cond6 == state.MET:
			if(board.GetNumCollectibles() == 1): 
				emit_signal("continueScript")
				print("7 cond")
				cond7 = state.MET
				cond6 = state.DONE

		# if the only element is player array is 1 ie 13
		if cond9 == state.MET:
			if(board.GetNumPlayers() == 1):
				emit_signal("continueScript")
				print("10 cond")
				cond10 = state.MET	
				cond9 = state.DONE

# if there are no more players
		if cond10 == state.MET:
			if(board.GetNumPlayers() == 0): 
				emit_signal("continueScript")
				print("11 cond")
				cond11 = state.MET
				cond10 = state.DONE

	# runs on detecting player movement 
func on_sendIsMoved():
	if(Global.get_isTutorial()):
			# conditionals for triggering next line of tutorial
			# if the first element has moved 14-1 = 13
			if cond0 == state.MET:
				if (board.GetPlayer(0) == 13):
					emit_signal("continueScript")
					print("1 cond")
					cond1 = state.MET
					cond0 = state.DONE
					board.ResetTileColor(1,2)
					show_button()
			# if the first element is now 14 
			if cond1 == state.MET:
				if(board.GetPlayer(0) == 14): 
					emit_signal("continueScript")
					print("2 cond") 
					cond2 = state.MET
					cond1 = state.DONE
					board.ResetTileColor(1,3)
					show_button()
			# if that 8 is now a 6
			if cond4 == state.MET:
				if(board.GetPlayer(2) == 6): 
					emit_signal("continueScript")
					print("5 cond")
					cond5 = state.MET
					cond4 = state.DONE
					board.ResetTileColor(6,2)
			
			# if the selected element is 64
			if cond8 == state.MET:
				if(board.GetCurrentPlayer() == 64 || board.GetPlayer(0)== 64): # working, 1st cond if 1->64, #2 cond if 64->1
					emit_signal("continueScript")
					print("9 cond")
					cond9 = state.MET
					cond8 = state.DONE
					show_button()		
	pass					

func hide_button():
	button.hide()
func show_button():
	button.show()
func disable_control_panel():
	addButton.disabled = true
	splitButton.disabled = true
	changeButton.disabled = true
	
func enable_control_panel():
	addButton.disabled = false
	splitButton.disabled = false
	changeButton.disabled = false

# by default, disable control panel (but not change) except in certain circumsstances
func disable_player_behavior():
	addButton.disabled = true
	splitButton.disabled = true
	changeButton.disabled = false

func enable_control_add():
	addButton.disabled = false

func enable_control_split():
	splitButton.disabled = false
		
func _on_merge_toggled():
	if(Global.get_isTutorial()):
		#cond8
		# if multi is pressed on 32 x 2
		if cond7 == state.MET:
			emit_signal("continueScript")
			print("8 cond")
			cond8 = state.MET
			cond7 = state.DONE
			board.Play()
	pass

func _on_PlayerChanged():
	if(Global.get_isTutorial()):
		#cond 0, if changed is pressed
		# a special case here since its the first conditonal
		if cond0 != state.MET && cond0 != state.DONE:
			emit_signal("continueScript")
			print("0 cond")
			cond0 = state.MET
			board.Play()
	pass

func _on_PlayerSplit():
	if(Global.get_isTutorial()):
		# if 6 has been split
		print(board.GetCurrentPlayer())
		if cond5 ==state.MET:
			if(board.GetCurrentPlayer() == 6): 
				emit_signal("continueScript")
				print("6 cond")
				cond6 = state.MET
				cond5 = state.DONE
				board.Play()
	pass
	
func around_the_bend_there():
	board.ChangeTileColor(1,4)
	board.ChangeTileColor(1,5)
	board.ChangeTileColor(1,6)
	board.ChangeTileColor(1,7)
	board.ChangeTileColor(1,8)
	board.ChangeTileColor(2,8)
	board.ChangeTileColor(3,8)
	board.ChangeTileColor(3,7)
	board.ChangeTileColor(3,6)
	board.ChangeTileColor(3,5)
	board.ChangeTileColor(4,5)
	board.ChangeTileColor(3,4)
	board.ChangeTileColor(2,4)
	
func around_the_bend_there_reset():
	board.ResetTileColor(1,4)
	board.ResetTileColor(1,5)
	board.ResetTileColor(1,6)
	board.ResetTileColor(1,7)
	board.ResetTileColor(1,8)
	board.ResetTileColor(2,8)
	board.ResetTileColor(3,8)
	board.ResetTileColor(3,7)
	board.ResetTileColor(3,6)
	board.ResetTileColor(3,5)
	board.ResetTileColor(4,5)
	board.ResetTileColor(3,4)
	board.ResetTileColor(2,4)
