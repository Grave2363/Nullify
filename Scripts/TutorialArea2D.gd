extends Area2D


##onready var label = $TutorialPanel/Label
#var is_mouse_entered = false
#var is_mouse_on = false
#
#var counter = 1;
#var tutorial_dict = {
#	1:"Welcome to Nullify! Let’s dig in and teach you how the game works!",
#	2:"The goal of Nullify is to get rid of all the numbers on the board. Bonus points if you can gather all the collectibles.",
#	3:"First, as you can tell, there’s several numbers on this board. So, what do we do in order to take control of a certain number?", 
#	4:"Tap the SELECT button on the control board to switch control between the available numbers. Your selected number will be highlighted in red. We’re going to deal with 16 first, so make sure the 16 is selected.",
#	5:"Good job. Next, let’s show you basic movement! In Nullify, this is termed as dragging. All numbers can move horizontally and vertically. We’re going to drag the 16 first. So, try swiping it across the bend there.",
#	6:"You see that the 16 is going 15, 14, 13… It's decrementing, but don’t be alarmed! When you drag a number, that number will decrease until it reaches 0, and then it disappears, POOF!",
#	7:"You also notice that the tiles are getting darker; they’re becoming IMMINENT. When you move across a tile twice, the tile becomes locked and you can no longer pass on it until you get a free number, which we will get to later. For now, keep going until that 16 is a 0!",
#	8:"Great. Now let’s talk about individual numbers’ abilities. Change the selected number to the 8 on the bottom left.",
#	9:"Even numbers have an added ability of moving diagonally. Get that 8 out of that bind!",
#	10:"Now here’s where some magic happens. Tap the SPLIT button on the control board.",
#	11:"Wow! Now that 6 became two 3s. Only even numbers can do this. Alright, now drag the two 3s and try to collect the two nearby collectibles.",
#	12:"Excellent, you’re becoming a Nullify pro! Now remember about the free number mentioned earlier? This is your time to use it! But first, add that 1 to that 63. This is adding/merging numbers. Press the respective button on the control board.",
#	13:"Now we have a 64, but what’s so special about it? This grid is an 8x8, and the “free number” of this board is the max number, 64. The free number can free any locked tile! Cool, right? Try freeing that 13 on the bottom right.",
#	14:"Awesome! We’re almost done. Use that 13 to collect the last collectible. Warning, this is a bit tricky, so plan out the movement well!",
#	15:"Huzzah! You’ve completed your first Nullify puzzle! That wasn’t so bad, was it? Remember, you can always come back to this tutorial anytime and you can also access the quick rules in the settings. Happy Nullifying!"
#}
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass
#
##func _input(event):
##	if(counter <16):
##		if(event is InputEventScreenTouch):
##			print(tutorial_dict[counter])
##			counter = counter+1
##	else:
##		#do stuff when tutorial is over?
##		print("Tutorial is over")
#
#
##		for x in tutorial_dict:
##
###			label.text.empty()
###			label.text = tutorial_dict[x]
##			print("Is working")
#
#
#func _process(_delta):
#	#pass
#	if(is_mouse_entered):
#		print("Detecting Mouse")
#
##func _unhandled_input(event):
##	if is_mouse_entered:
##		if Input.is_action_pressed("click"):
##			is_mouse_on = event.is_pressed()
##			get_tree().set_input_as_handled()
##			print("Working")
##	else:
##		print("Not Working")
#
#func _unhandled_input(event):
#	if event is InputEventMouseButton and event.pressed:
#		$Collider.position = self.global_transform.xform_inv(event.position)
#		if $Collider.shape.collide($Collider.global_transform, $Hitbox.get_shape(), $Hitbox.global_transform):
#			print("Is working")
#			get_tree().set_input_as_handled()
#		else:
#			print("Not Working")
#
#
#func _on_Area2D_area_exited(area):
#	is_mouse_entered = false
#
#
#func _on_Area2D_area_entered(area):
#	is_mouse_entered = true
