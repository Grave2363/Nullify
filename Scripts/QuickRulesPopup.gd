extends CanvasLayer
onready var panel = $Popup/ColorRect/Panel
onready var rulesText = $Popup/ColorRect/Panel/RulesText
onready var pagination = $Popup/ColorRect/Panel/PaginationLabel
onready var nextButton = $Popup/ColorRect/Panel/nextButton
onready var prevButton = $Popup/ColorRect/Panel/prevButton
var counter = 1

var quick_rules_dict = {
	1:"The goal of Nullify is to clear the board\nof all numbers!",
	2:"Use the SELECT button in the control board to select and take control of a number.",
	3:"Once a number is highlighted you can control its movement by swiping in either horizontally or vertically. If the number is even it can additionally move vertically.",
	4:"As you move, the tiles you traverse through will become darker. If you pass through them a second time, they will lock and not be passable.",
	5:"When a number moves, its count decrements. When it reaches 0, it will disappear and nullify.",
	6:"You can merge numbers by either multiplying (if the two numbers are even) or adding them by toggling the ADD button.",
	7:"You can also split even numbers in half with the SPLIT button.",
	8:"Every board size has a free number: for 5x5 it’s 16, for 6x6 it’s 32, and for 8x8 it’s 64. When you reach any of these numbers, you can use these numbers to free any locked tile.",
	9:"Score: You lose 5 points every second and gain 100 points when you Nullify a number. To get a bonus collect the stars!",
}
func _ready():
	rulesText.text = quick_rules_dict[1]
	prevButton.hide()

func _process(delta):
	# hide respective buttons when reaching the end or beginning
	if(rulesText.text == quick_rules_dict[1]):
		prevButton.hide()
	else:
		prevButton.show()
	if(rulesText.text == quick_rules_dict[9]):
		nextButton.hide()
	else:
		nextButton.show()
	pagination.text = str(counter) + "/9"
	

func _on_DoneButton_pressed():
	$Popup.hide()
	# this only works right in the gamehub ui, if its in the settings, it wont work
	#var popup = get_parent().get_node("PopupDialog")
	#popup.show();


func _on_prevButton_pressed():
	if(counter >1):
		counter = counter-1	
		rulesText.text.empty()	
		rulesText.text = quick_rules_dict[counter]
			
	pass

func _on_nextButton_pressed():
	if(counter <quick_rules_dict.size() + 1):
		counter = counter+1
		rulesText.text.empty()
		rulesText.text = quick_rules_dict[counter]
		
