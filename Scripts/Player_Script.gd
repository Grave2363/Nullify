##/***   THIS IS EMILIO'S NEW VERSION   [221]   ***/
extends KinematicBody2D
onready var timer = $TouchScreenButton/Timer
onready var ray = $RayCast2D
onready var label = get_node("Label") 
onready var gameScript = get_node("../") 
onready var main_game_node 
signal moved
var using_swipe = false
var player_grid = Vector2(0,0)
var prev_player_grid = Vector2(0,0)
var isPlayerMovable = true 
var tile_size = 64
var playing_game = true
var curValue = 5
var prevPos = Vector2(0,0)
var curPos = Vector2(0,0)
var inputs = {
	'ui_up': Vector2.UP,
	'ui_down': Vector2.DOWN,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT
}
func get_player_grid_x():
	return player_grid.x
func get_player_grid_y():
	return player_grid.y
func set_player_grid_vector(val):
	player_grid = val
	prev_player_grid = val
func set_is_player_movable(val):
	isPlayerMovable = val
func get_is_player_movable():
	return isPlayerMovable
func set_current_value(num):
	curValue = num
	label.text = str(curValue)
func get_current_value():
	return curValue
func change_this_player():
	print("ENTER!")
	$Sprite.modulate = Color("#ff6f59")
func set_main_game_node(name):
	main_game_node = name
	gameScript.set_board_node(name)
func get_main_game_node():
	return main_game_node
func player_turn():
	if isPlayerMovable:
		$Sprite.modulate = Color("#ff6f59")
	else:
		$Sprite.modulate = Color(1,1,1)
func _on_SwipeDetector_swipe(direction):
	var isEvenAndDia = true
	if direction == Vector2(1,1) || direction == Vector2(-1,-1) || direction == Vector2(1,-1) || direction == Vector2(-1, 1):
		if curValue % 2 != 0:
			isEvenAndDia = false
	print("is diabled -> ", Global.get_is_input_disabled())
	if isPlayerMovable && isEvenAndDia && !Global.get_is_input_disabled():
		using_swipe = true
		move(-direction)
func checkForCollisionRight():
	ray.cast_to = Vector2.RIGHT * Global.get_textureDistance() * 3 / 4;
	ray.force_raycast_update()
	print("Collider -> ", ray.is_colliding())
	return !ray.is_colliding() && !main_game_node.IsTileLocked(player_grid.x + 1, player_grid.y)
func checkForCollisionLeft():
	ray.cast_to = Vector2.LEFT * Global.get_textureDistance() * 3 / 4;
	ray.force_raycast_update()
	return !ray.is_colliding() && !main_game_node.IsTileLocked(player_grid.x - 1, player_grid.y)
func checkForCollisionUp():
	ray.cast_to = Vector2.UP * Global.get_textureDistance() * 3 / 4;
	ray.force_raycast_update()
	return !ray.is_colliding() && !main_game_node.IsTileLocked(player_grid.x, player_grid.y - 1)
func checkForCollisionDown():
	ray.cast_to = Vector2.DOWN * Global.get_textureDistance() * 3 / 4;
	ray.force_raycast_update()
	return !ray.is_colliding() && !main_game_node.IsTileLocked(player_grid.x, player_grid.y + 1)
func connect_player():
	connect("moved", main_game_node, "_player_moved")
func disableCurrentTile():
	main_game_node.DisableTile(player_grid.x, player_grid.y)
func disableAdjecantTiles():
	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y - 1):
		main_game_node.DisableTile(prev_player_grid.x - 1, prev_player_grid.y - 1)
	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y):
		main_game_node.DisableTile(prev_player_grid.x - 1, prev_player_grid.y)
	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y + 1):
		main_game_node.DisableTile(prev_player_grid.x - 1, prev_player_grid.y + 1)
	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y - 1):
		main_game_node.DisableTile(prev_player_grid.x, prev_player_grid.y - 1)
	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y):
		main_game_node.DisableTile(prev_player_grid.x, prev_player_grid.y)
	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y + 1):
		main_game_node.DisableTile(prev_player_grid.x, prev_player_grid.y + 1)
	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y - 1):
		main_game_node.DisableTile(prev_player_grid.x + 1, prev_player_grid.y - 1)
	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y):
		main_game_node.DisableTile(prev_player_grid.x + 1, prev_player_grid.y)
	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y + 1):
		main_game_node.DisableTile(prev_player_grid.x + 1, prev_player_grid.y + 1)
func enableAdjecantTiles():
	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y - 1):
		main_game_node.EnableTile(prev_player_grid.x - 1, prev_player_grid.y - 1)
	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y):
		main_game_node.EnableTile(prev_player_grid.x - 1, prev_player_grid.y)
	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y + 1):
		main_game_node.EnableTile(prev_player_grid.x - 1, prev_player_grid.y + 1)
	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y - 1):
		main_game_node.EnableTile(prev_player_grid.x, prev_player_grid.y - 1)
	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y):
		main_game_node.EnableTile(prev_player_grid.x, prev_player_grid.y)
	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y + 1):
		main_game_node.EnableTile(prev_player_grid.x, prev_player_grid.y + 1)
	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y - 1):
		main_game_node.EnableTile(prev_player_grid.x + 1, prev_player_grid.y - 1)
	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y):
		main_game_node.EnableTile(prev_player_grid.x + 1, prev_player_grid.y)
	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y + 1):
		main_game_node.EnableTile(prev_player_grid.x + 1, prev_player_grid.y + 1) 
func stop_moves():
	timer.start()
	playing_game = false
func move(dir):
	Global.set_is_input_handled(true)
	Global.set_tile_toggle(true)
	var isAnimate = true
	var isUnlockingTile = false
	var currID = gameScript.getIDFromObj(self)
	prevPos = position
	ray.cast_to = dir * Global.get_textureDistance() * 3 / 4;
	ray.force_raycast_update()
	if  ray.is_colliding():
		var collider = ray.get_collider()
		if (collider.is_in_group('Collectable')):
			if curValue == Global.get_max_val():
				isAnimate = false
			else:
				collider.remove_collectable()
				main_game_node.addToUndoStack(currID, currID, player_grid, player_grid + dir, curValue, curValue - 1, "MOVE")
		elif collider.is_in_group('Player'):
			var tmpCurrID = currID
			set_is_player_movable(false)
			collider.set_is_player_movable(true)
			var colliderID = gameScript.getIDFromObj(collider)
			collider.set_is_player_movable(false)
			set_is_player_movable(true)
			if !Global.get_is_add_button() && curValue % 2 == 0 && (curValue * collider.get_current_value()) <= Global.get_max_val() :
				main_game_node.addToUndoStack(currID, colliderID, player_grid, player_grid + dir, curValue, collider.get_current_value(), "MERGE")
				calc_multi(collider)
			elif (curValue + collider.get_current_value()) <= Global.get_max_val():
				main_game_node.addToUndoStack(currID, colliderID, player_grid, player_grid + dir, curValue, collider.get_current_value(), "MERGE")
				calc_add(collider)
			else:
				isAnimate = false
				print("Hit BOUNDARY")
		else:
			isAnimate = false
			print("Hit BOUNDARY")
	elif main_game_node.IsTileLocked(player_grid.x + dir.x, player_grid.y + dir.y) == true:
		print("HIT LOCKED TILE")
		if curValue == Global.get_max_val():
			main_game_node.UnlockLocked(player_grid.x + dir.x, player_grid.y + dir.y)
			isUnlockingTile = true
		else:
			print("BLOCKED MOVE")
			isAnimate = false
	elif curValue == Global.get_max_val():
		curValue += 1
		main_game_node.addToUndoStack(currID, currID, player_grid, player_grid + dir, curValue, curValue - 1, "MOVE")
	else:
		print("move")
		main_game_node.addToUndoStack(currID, currID, player_grid, player_grid + dir, curValue, curValue - 1, "MOVE")
	if(isAnimate):
		prev_player_grid = player_grid
		disableAdjecantTiles()
		main_game_node.EnableTile(prev_player_grid.x, prev_player_grid.y) # /***  >>NOTE>> CANNOT DO THIS IN OTHER FUNCTION DUE TO ADD TO UNDO STACK   ***/
		player_grid = player_grid + dir
		curValue -= 1
		var tween = get_node("Tween")
		tween.interpolate_property($".", "position",
		position, position + (dir * Global.get_textureDistance()), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield($Tween, "tween_all_completed")
		if(curValue == 0 || isUnlockingTile):
			if isUnlockingTile:
				main_game_node.addToUndoStack(currID, currID, prev_player_grid, player_grid, Global.get_max_val(), Global.get_max_val(), "DELETE")
			else:
				main_game_node.addToUndoStack(currID, currID, player_grid, player_grid, 1, 1, "DELETE")
			enableAdjecantTiles()
			gameScript.remove_player_from_array(self)
			Global.set_is_input_handled(false)
			Global.set_tile_toggle(false)
			return
		label.text = str(curValue)
		enableAdjecantTiles()
	gameScript.printPlayers()
	Global.set_is_input_handled(false)
	Global.set_tile_toggle(false)
	emit_signal("moved")
func calc_add(collider): 
	MusicPlayer.onAddButton()
	curValue = curValue + collider.get_current_value() + 1
	print("THIS IS DEF HIT!")
	collider.disableCurrentTile()
	gameScript.remove_player_from_array_and_swap_to_id(collider, self)

func calc_multi(collider):
	MusicPlayer.onMult()
	curValue = curValue * collider.get_current_value() + 1
	collider.disableCurrentTile()
	gameScript.remove_player_from_array_and_swap_to_id(collider, self)
func set_pos(x,y):
	position.x = x
	position.y = y
func _on_TouchScreenButton_pressed():
	isPlayerMovable = true
	gameScript.update_player_vals(self)
func _on_Timer_timeout():
	print("_On_TimeOut_PlayerClass")













##  /*** >>NOTE>>  ONLY THING LEFT TO UPDATE IS MOVE AND WHAT EVER BREAK   ***/
##/***   THIS IS EMILIO'S COMMENT VERSION  [583]   ***/
#extends KinematicBody2D
#onready var timer = $TouchScreenButton/Timer
#onready var ray = $RayCast2D
#onready var label = get_node("Label") 
#onready var gameScript = get_node("../") 
#onready var main_game_node 
#signal moved
#var using_swipe = false
#var player_grid = Vector2(0,0) # /***   !!CHANGE!!  <- THIS VAR WAS ORIGIANLLY var player_grid = [0,0]  ***/
#var prev_player_grid = Vector2(0,0) # /***   !!CHANGE!!  <- THIS VAR WAS ORIGIANLLY var player_grid = [0,0]  ***/
##var Player_can_move = 0
##var player = 0
#var isPlayerMovable = true # /***   REPLACEMENT BOOLEAN FOR PLAYER CAN MOVE AND PLAYER   ***/
#var tile_size = 64
#var playing_game = true
#var curValue = 5 # /***   !!CHANGE!!  <- THIS VAR WAS ORIGIANLLY Move_Left   ***/
#var prevPos = Vector2(0,0) #  /*** !!CHANGE!! <- THIS VAR WAS ORIGINALLY tempXForStack && tempYForStack   ***/
#var curPos = Vector2(0,0)
##var tempCollectableUndoX = 1
##var tempCollectableUndoY = 1
##var isCollectableMove = false
##var multi = true
## /*** >>NOTE>>  GET RID OF ALL vec_pos -> vec_pos and dir are exactly the same VAR  ***/
#
#
## for btn controls
#var inputs = {
#	'ui_up': Vector2.UP,
#	'ui_down': Vector2.DOWN,
#	'ui_left': Vector2.LEFT,
#	'ui_right': Vector2.RIGHT
#}
#
#
### /***   !!CHANGE!!  <- THIS VAR IS GLOBAL NO LONGER NEED TO INSTANCE!!   ***/
##var mapSize = 5
##
##func set_map_size(num):
##	mapSize = num
##func get_map_size():
##	return mapSize
#
### /***   !!CHANGE!!  <- THIS VAR IS GLOBAL TEXTURE DISTANCE!!   ***/
##func set_tile_size(val):
##	tile_size = val
##func get_tile_size():
##	return tile_size
#
#func get_player_grid_x():
#	return player_grid.x
#func get_player_grid_y():
#	return player_grid.y
#func set_player_grid_vector(val):
#	player_grid = val
#	prev_player_grid = val
#
#
##  /***   !!OPTIMIZE!! <- MAYBE Better way | tempx | tempy |   ***/
##  /***   !!OPTIMIZE!! <- MAYBE WE CAN CHANGE THIS FUNCTION   ***/
##func set_player_grid(x, y, external_edit):
##	if external_edit == true:
##		gameScript.update_object_array(x,y,player_grid.x, player_grid.y, true)
##	player_grid.x = x
##	player_grid.y = y
#
#
## /***   THIS IS SPECIFICALLY FOR TUTORIAL, CONTROLLING PLAYERS   ***/
#func Is_Game_running(state):
#	playing_game = state
#
##  /***   !!OPTIMIZE!! <- MAYBE Better way CHANGE SCORE   ***/
##  /***   ??UPDATE??   <- THIS IS A CLASS -> CLASS -> CLASS STRUCT   ***/
##  /***   !!CHANGE!!   <- ATTEMPTING THIS PIPELINE WITH A GLOBAL   ***/
##func send_player_remove_sig():
##	main_game_node.player_removed()
##func send_collect_remove_sig():
##	main_game_node.collect_removed()
#
#
##  /***   NOTE: COME BACK TO THIS FUNCTION(S)   ***/
##  /***   ??UPDATE??  <- WHY DO WE HAVE TWO BOOLEANS THAT SEEM TO CHECK THE SAME THING   ***/
##  /***   ??UPDATE??  <- WHY ARE THESE BOOLEANS BEING COMPARED TO EACH OTHER   ***/
##  /***   !!CHANGE!!  <- ONLY USING ONE BOOLEAN AND RENAME  ***/
##  /***   ??UPDATE??  <- Player_can_move is based on curr player in array??   ***/
##  /***   ??UPDATE??  <- player is related to creating players??   ***/
## utility functions for the player 
##func set_player_move(num):
##	if Player_can_move != 99:
##		Player_can_move = num
##func get_player_move():
##	return Player_can_move
##func get_can_player_move():
##	return player
##func can_player_move(num):
##	player = num
#func set_is_player_movable(val):
#	isPlayerMovable = val
#func get_is_player_movable():
#	return isPlayerMovable
#
##  /***   ??UPDATE??  <- DO WE REALLY WANT Move_Left TO BE THE VARIABLE NAME??   ***/
##  /***   !!CHANGE!!  <- CHANGED VARIBALE TO curValue   ***/
#func set_current_value(num):
#	curValue = num
#	label.text = str(curValue)
#func get_current_value():
#	return curValue
#
##  /***  ??UPDATE??  <-  MISLEADING FUNCTION NAME -> change_this_player  ***/
##  /***  !!CHANGE!!  <-  UPDATED THE FUNCTION NAME   ***/
##  /***  !!CHANGE!!  <-  RATHER THAN MAKING SPRITE A VARIABLE, JUST CALL THE OBJECT   ***/
#func change_this_player():
#	print("ENTER!")
#	$Sprite.modulate = Color("#ff6f59")
#
#
##  /***  >>NOTE>>  IF player_array_check  ->  if gameScript.state_of_player_array():   ***/
##func player_array_check():
##	if gameScript.state_of_player_array():
##		return true
#
#
## /***  !!CHANGE!! <- SINCE I LOWERED THIS TO ONE LINE OF CODE, WE NO LONGER NEED THIS AS A FUNCTION   ***/
##func remove_player():
##	main_game_node.addToUndoStack(gameScript.get_cur_player_id(), 
##	gameScript.get_cur_player_id(),prevPos.x, prevPos.y,
##	tempCollectableUndoX, tempCollectableUndoY, 1, 1,isCollectableMove, "DELETE")
##	$Area2D/CollisionShape2D.set_deferred("disabled", true)
##	isPlayerMovable = false
##	curValue = 0
##	/***  player = 0 !!CHANGE!!  <- DELETED VARIBALE   ***/
##	print("IN FUNCTION!! REMOVE!")
##	gameScript.remove_player_from_array(self)
##	gameScript.update_player_vals()
##	if gameScript.state_of_player_array():
##		main_game_node.win_condition()
#
#
## /*** !!CHANGE!!  <-  WE DO NOT NEED TWO FUNCTIONS FOR THIS!  ***/
##func remove_check():
##	if curValue == 0 :
###  /***  ??UPDATE??  COMEBACK TO THIS ADD TO STACK EDIT LOCAL VARS OR CHANGE STACK FUNCTION   ***/
###  /***  ??UPDATE??  MORE THAN LIKELY NO LONGER NEED isCollectableMove   ***/
##		#Call TO ADD TO STACK
##
##		remove_player()
#
#func set_main_game_node(name):
#	main_game_node = name
#	gameScript.set_board_node(name)
#func get_main_game_node():
#	return main_game_node
#
##  /***  !!OPTIMZIE!!  <- THIS FUNCTIONS SHOULD NO LONGER BE NEEDED, WE HAVE GLOBALS!!   ***/
##func set_game_score_script(name):
##	grid.set_score_node(name)
##
##func set_map_num(num):
##	map_free_num = num
##
##func get_map_num():
##	return map_free_num
##
#
## /*** >>NOTE>>  COME BACK TO THIS FUNCTION -> WHY IS THIS NEEDED??   ***/
##func _ready():
##	curValue = (randi() % Global.get_max_val() + 2)
##	label.text = str(Move_Left)
#
#
## /*** >>NOTE>>  COME BACK TO THIS FUNCTION -> I THINK I LIKE THIS  ***/
## /*** !!CHANGE!!  NO LONGER A NEEDED FUNCTION UNLESS USING KEYBOARD  ***/
## handels math for movement and chages baised on type of input 
##func direction_math(pos, dir):
##	if using_swipe == false:
##		 pos = inputs[dir] * tile_size
##	elif using_swipe == true:
##		 pos = dir * tile_size
##	return pos
#func player_turn():
#	if isPlayerMovable:
#		$Sprite.modulate = Color("#ff6f59")
#	else:
#		$Sprite.modulate = Color(1,1,1)
#
#func _on_SwipeDetector_swipe(direction):
##	gameScript.STOP_PLAYERS(false)
##	if !Global.get_is_input_handled():
#	var isEvenAndDia = true
#	if direction == Vector2(1,1) || direction == Vector2(-1,-1) || direction == Vector2(1,-1) || direction == Vector2(-1, 1):
#		if curValue % 2 != 0:
#			isEvenAndDia = false
#	if isPlayerMovable && isEvenAndDia:
#		using_swipe = true
#		move(-direction)
#
#func checkForCollisionRight():
#	ray.cast_to = Vector2.RIGHT * Global.get_textureDistance() * 3 / 4;
#	ray.force_raycast_update()
#	print("Collider -> ", ray.is_colliding())
#	return !ray.is_colliding() && !main_game_node.IsTileLocked(player_grid.x + 1, player_grid.y)
#
#func checkForCollisionLeft():
#	ray.cast_to = Vector2.LEFT * Global.get_textureDistance() * 3 / 4;
#	ray.force_raycast_update()
#	return !ray.is_colliding() && !main_game_node.IsTileLocked(player_grid.x - 1, player_grid.y)
#
#func checkForCollisionUp():
#	ray.cast_to = Vector2.UP * Global.get_textureDistance() * 3 / 4;
#	ray.force_raycast_update()
#	return !ray.is_colliding() && !main_game_node.IsTileLocked(player_grid.x, player_grid.y - 1)
#
#func checkForCollisionDown():
#	ray.cast_to = Vector2.DOWN * Global.get_textureDistance() * 3 / 4;
#	ray.force_raycast_update()
#	return !ray.is_colliding() && !main_game_node.IsTileLocked(player_grid.x, player_grid.y + 1)
#
##  /***  >>NOTE>>  IF check_adjacent_tiles  ->  if main_game_node.IsSpaceAvailable(x,y)   ***/
##func check_adjacent_tiles(x,y):
##	return main_game_node.IsSpaceAvailable(x,y)
#
##  /***  >>NOTE>>  IF player_array_check  ->  if gameScript.state_of_player_array(): return true   ***/
##func player_array_check():
##	if gameScript.state_of_player_array():
##		return true
#
#func connect_player():
#	connect("moved", main_game_node, "_player_moved")
#
##  /***  >>NOTE>>  Come back to function ->  MUST AVOID PROCESS ANYTIME POSSIBLE!!!   ***/
##  /***  >>NOTE>>  Come back to function ->  TEMP GONNA FIX ERRORS   ***/
##  /***  >>NOTE>>  THIS FUNCTION CONSTANTLY CHECKS ALL ADJACENT TILES AND THEIR STATES ***/
##  /***  >>NOTE>>  THIS IS NOT WHAT WE WANT TO DO, 99% OF THE TILES ARE CONSTANT EVERY FRAME  ***/
##var move = false # /***   THIS IS A TEMP VAR   ***/
##var t = 0 # /***   THIS IS A TEMP VAR   ***/
##var to_vec = Vector2(0,0) # /***   THIS IS A TEMP VAR   ***/
##var cur_pos # /***   THIS IS A TEMP VAR   ***/
##var tempX # /***   THIS IS A TEMP VAR   ***/
##var tempY # /***   THIS IS A TEMP VAR   ***/
##var node0 # /***   THIS IS A TEMP VAR   ***/
##var node1 # /***   THIS IS A TEMP VAR   ***/
##var node2 # /***   THIS IS A TEMP VAR   ***/
##var node3 # /***   THIS IS A TEMP VAR   ***/
##func _process(delta):
##	if move == true:
##		t += delta*0.4 #/***  ??UPDATE??  <- THIS ONLY CAUSES A 0.3m DELAY FOR THE BOOLEAN TO BE CHECKED ***/
##		self.position = self.position.linear_interpolate(to_vec,t) # /***   ??UPDATE??  <- CANNOT HAVE ANIMATION POSITION CHANGE CONSTANTLY   ***/
##																   # /***   ??UPDATE??  <- THIS IS THE CAUSE FOR MANY ANIMATION ISSUES   ***/
##		if t > 0.3:
##			move = false
##			t = 0
##			cur_pos = position
##			var mapSize = Global.get_grid()
##			if curValue != 1:
##				# /***  >>NOTE>>  ASSUME TEMPX AND TEMPY ARE PREVIOUS COORDINATES   ***/
##				# /***  >>NOTE>>  THESE FUNCTIONS RETURN A CLASS -> CLASS -> CLASS -> int (0,1,2)  ***/
##				# /***  >>NOTE>>  THESE NEED TO BE UPDATED!!  ***/
##				if tempX + 1 != mapSize+1  :
##					# /***   ??UPDATE??  YOU CAN'T CHECK FOR NULL AFTER YOU HAVE DONE OPERATION!!   ***/
##					# /***   !!CHANGE!!  SWAPPED OPERATIONS SEE ABOVE ^^   ***/
##					# /***   >>NOTE>>    I DO NOT SEE THE NEED FOR node# WE ALREADY HAVE A ***/
##					# /***   DATA STRUCTURE TO TAKE CARE OF TILE DATA e.g. TileState -> GameBoard Class  ***/
##					if main_game_node.IsTileExist(tempX + 1, tempY): # && node0 != main_game_node.GetTileState(tempX + 1, tempY):
##						main_game_node.SetTileState(tempX + 1, tempY, node0)
##						#main_game_node.EnableTile(tempX + 1, tempY);
##				if tempX - 1 != 0:
##					if main_game_node.IsTileExist(tempX - 1, tempY): # && node1 != main_game_node.GetTileState(tempX - 1, tempY) :
##						main_game_node.SetTileState(tempX - 1, tempY, node1)
##						#main_game_node.EnableTile(tempX - 1, tempY);
##				if tempY + 1 != mapSize+1 :
##					if main_game_node.IsTileExist(tempX, tempY + 1): # && node2 != main_game_node.GetTileState(tempX, tempY + 1) :
##						main_game_node.SetTileState(tempX , tempY + 1, node2)
##						#main_game_node.EnableTile(tempX, tempY + 1);
##				if tempY - 1 != 0:
##					if main_game_node.IsTileExist(tempX, tempY - 1): # && node3 != main_game_node.GetTileState(tempX , tempY - 1) :
##						main_game_node.SetTileState(tempX , tempY - 1, node3)
##						#main_game_node.EnableTile(tempX, tempY - 1);
##				if main_game_node.IsTileExist(tempX + 1, tempY): # && tempX + 1 != mapSize+1 && (vec_pos.x != 0 && vec_pos.y != 0) :
##					node0 = main_game_node.GetTileState(tempX + 1, tempY)
##				if main_game_node.IsTileExist(tempX - 1, tempY): # && tempX - 1 != 0 && (vec_pos.x != 0 && vec_pos.y != 0) :
##					node1 = main_game_node.GetTileState(tempX - 1, tempY)
##				if main_game_node.IsTileExist(tempX, tempY + 1): # && tempY + 1 != mapSize+1 && (vec_pos.x != 0 && vec_pos.y != 0) :
##					node2 = main_game_node.GetTileState(tempX, tempY + 1)
##				if main_game_node.IsTileExist(tempX, tempY - 1): # && tempY - 1 != 0 && (vec_pos.x != 0 && vec_pos.y != 0) :
##					node3 = main_game_node.GetTileState(tempX, tempY - 1)
##				#print(player_grid)  # /***  ??UPDATE??  <- DEBUGGEING PRINT??  ***/
##
#
#
#func disableCurrentTile():
#	main_game_node.DisableTile(player_grid.x, player_grid.y)
#
## #  /*** >>NOTE>>  MIGHT JUST MERGE FUNCTION WITH THE MOVE FUNCTION AFTER OPTIMIZATION    ***/
## #  /*** ??UPDATE??  ALL WE REALLY NEED TO DO IS DISABLE TILES DURING ANIMATION!!   ***/
## #  /*** !!CHANGE!!  NEW FUNCTION TO REPLACE ^^ _process()   ***/
## #  /*** >>NOTE>>  FOR NOW WE JUST WANT TO DISABLE ALL TILES   ***/
#func disableAdjecantTiles():
##	print("\n\nDISABLE!!")
##	print("X1 -> ", prev_player_grid.x - 1)
##	print("Y1 -> ", prev_player_grid.y - 1)
##	print("X2 -> ", prev_player_grid.x - 1)
##	print("Y2 -> ", prev_player_grid.y)
##	print("X3 -> ", prev_player_grid.x - 1)
##	print("Y3 -> ", prev_player_grid.y + 1)
##	print("X4 -> ", prev_player_grid.x)
##	print("Y4 -> ", prev_player_grid.y - 1)
##	print("X5 -> ", prev_player_grid.x)
##	print("Y5 -> ", prev_player_grid.y)
##	print("X6 -> ", prev_player_grid.x)
##	print("Y6 -> ", prev_player_grid.y + 1)
##	print("X7 -> ", prev_player_grid.x + 1)
##	print("Y7 -> ", prev_player_grid.y - 1)
##	print("X8 -> ", prev_player_grid.x + 1)
##	print("Y8 -> ", prev_player_grid.y)
##	print("X9 -> ", prev_player_grid.x + 1)
##	print("Y9 -> ", prev_player_grid.y + 1)
#	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y - 1):
#		main_game_node.DisableTile(prev_player_grid.x - 1, prev_player_grid.y - 1)
#	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y):
#		main_game_node.DisableTile(prev_player_grid.x - 1, prev_player_grid.y)
#	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y + 1):
#		main_game_node.DisableTile(prev_player_grid.x - 1, prev_player_grid.y + 1)
#	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y - 1):
#		main_game_node.DisableTile(prev_player_grid.x, prev_player_grid.y - 1)
#	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y):
#		main_game_node.DisableTile(prev_player_grid.x, prev_player_grid.y)
#	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y + 1):
#		main_game_node.DisableTile(prev_player_grid.x, prev_player_grid.y + 1)
#	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y - 1):
#		main_game_node.DisableTile(prev_player_grid.x + 1, prev_player_grid.y - 1)
#	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y):
#		main_game_node.DisableTile(prev_player_grid.x + 1, prev_player_grid.y)
#	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y + 1):
#		main_game_node.DisableTile(prev_player_grid.x + 1, prev_player_grid.y + 1)
#
#func enableAdjecantTiles():
##	print("\n\nENABLE!!")
##	print("X1 -> ", prev_player_grid.x - 1)
##	print("Y1 -> ", prev_player_grid.y - 1)
##	print("X2 -> ", prev_player_grid.x - 1)
##	print("Y2 -> ", prev_player_grid.y)
##	print("X3 -> ", prev_player_grid.x - 1)
##	print("Y3 -> ", prev_player_grid.y + 1)
##	print("X4 -> ", prev_player_grid.x)
##	print("Y4 -> ", prev_player_grid.y - 1)
##	print("X5 -> ", prev_player_grid.x)
##	print("Y5 -> ", prev_player_grid.y)
##	print("X6 -> ", prev_player_grid.x)
##	print("Y6 -> ", prev_player_grid.y + 1)
##	print("X7 -> ", prev_player_grid.x + 1)
##	print("Y7 -> ", prev_player_grid.y - 1)
##	print("X8 -> ", prev_player_grid.x + 1)
##	print("Y8 -> ", prev_player_grid.y)
##	print("X9 -> ", prev_player_grid.x + 1)
##	print("Y9 -> ", prev_player_grid.y + 1)
#	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y - 1):
#		main_game_node.EnableTile(prev_player_grid.x - 1, prev_player_grid.y - 1)
#	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y):
#		main_game_node.EnableTile(prev_player_grid.x - 1, prev_player_grid.y)
#	if main_game_node.IsTileExist(prev_player_grid.x - 1, prev_player_grid.y + 1):
#		main_game_node.EnableTile(prev_player_grid.x - 1, prev_player_grid.y + 1)
#	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y - 1):
#		main_game_node.EnableTile(prev_player_grid.x, prev_player_grid.y - 1)
#	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y):
#		main_game_node.EnableTile(prev_player_grid.x, prev_player_grid.y)
#	if main_game_node.IsTileExist(prev_player_grid.x, prev_player_grid.y + 1):
#		main_game_node.EnableTile(prev_player_grid.x, prev_player_grid.y + 1)
#	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y - 1):
#		main_game_node.EnableTile(prev_player_grid.x + 1, prev_player_grid.y - 1)
#	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y):
#		main_game_node.EnableTile(prev_player_grid.x + 1, prev_player_grid.y)
#	if main_game_node.IsTileExist(prev_player_grid.x + 1, prev_player_grid.y + 1):
#		main_game_node.EnableTile(prev_player_grid.x + 1, prev_player_grid.y + 1) 
#
## /***  >>NOTE>>  <- COME BACK TO THIS FUNCTION, MAYBE ITS ONLY FOR PROCESS   ***/
#func stop_moves():
#	timer.start()
#	playing_game = false
#
## handels moveing the player and responds to anything the player collides with 
#func move(dir):
#	Global.set_is_input_handled(true)
#	Global.set_tile_toggle(true)
#	var isAnimate = true
#	var isUnlockingTile = false
#	var currID = gameScript.getIDFromObj(self)
#	prevPos = position
#	# /***   ??UPDATE??  THE ORDER OF THE NEXT TWO LINES MIGHT CAUSE ISSUES   ***/
#	# /***   >>NOTE>>  COME BACK TO THIS SITUATION ^^  ***/
#
#	# /***   DO MATH TO GET NEXT POSITION HERE   ***/
##	player_turn()
##	gameScript.checkForGameOver()
##  /***   >>NOTE>>  tempX || tempY IS NO LONGER A NEEDED VARIABLE   ***/
##	if isPlayerMovable: # !!CHANGE!!  ->  player == Player_can_move  && playing_game == true :
#	ray.cast_to = dir * Global.get_textureDistance() * 3 / 4;
#	ray.force_raycast_update()
##	print("SHOULD BE IN FUCNTION -> ", ray.is_colliding())
#	if  ray.is_colliding():
#		var collider = ray.get_collider()
##		print("Collider -> ", collider)
#		if (collider.is_in_group('Collectable')):
#			if curValue == Global.get_max_val():
#				isAnimate = false
#			else:
#				collider.remove_collectable()
#				main_game_node.addToUndoStack(currID, currID, player_grid, player_grid + dir, curValue, curValue - 1, "MOVE")
##				stop_moves()
##				to_vec = position + vec_pos
##				cur_pos = position + vec_pos
#			#position += vec_pos
##				isCollectableMove = true
##				gameScript.setCollectable(true)
#			#FOR UNDOING COLLECTABLES <- EMILIO
##				tempCollectableUndoX = player_grid[0]
##				tempCollectableUndoY = player_grid[1]
#
##				if Move_Left != map_free_num:
##					Move_Left = Move_Left - 1
##				lab.text = str(Move_Left)
#		elif collider.is_in_group('Player'):
#			var tmpCurrID = currID
#			set_is_player_movable(false)
#			collider.set_is_player_movable(true)
#			var colliderID = gameScript.getIDFromObj(collider)
#			collider.set_is_player_movable(false)
#			set_is_player_movable(true)
#			if !Global.get_is_add_button() && curValue % 2 == 0 && (curValue * collider.get_current_value()) <= Global.get_max_val() :
#				main_game_node.addToUndoStack(currID, colliderID, player_grid, player_grid + dir, curValue, collider.get_current_value(), "MERGE")
#				calc_multi(collider)
#			elif (curValue + collider.get_current_value()) <= Global.get_max_val():
#				main_game_node.addToUndoStack(currID, colliderID, player_grid, player_grid + dir, curValue, collider.get_current_value(), "MERGE")
#				calc_add(collider)
#			else:
#				isAnimate = false
#				print("Hit BOUNDARY")
#		else:
#			isAnimate = false
#			print("Hit BOUNDARY")
#	# /***   ASSUMING IS LOCKED TILE   ***/
#	elif main_game_node.IsTileLocked(player_grid.x + dir.x, player_grid.y + dir.y) == true:
#		print("HIT LOCKED TILE")
#		if curValue == Global.get_max_val():
#			main_game_node.UnlockLocked(player_grid.x + dir.x, player_grid.y + dir.y)
#			#ADDING TO UNDO STACK
##				main_game_node.addToUndoStack(gameScript.get_cur_player_id(), 
##				gameScript.get_cur_player_id(),prevPos.x,prevPos.y, 
##				player_grid.x, player_grid.y, curValue, curValue,isCollectableMove, "UNLOCK")
#			isUnlockingTile = true
#		else:
#			print("BLOCKED MOVE")
#			isAnimate = false
#	elif curValue == Global.get_max_val():
#		curValue += 1
#		main_game_node.addToUndoStack(currID, currID, player_grid, player_grid + dir, curValue, curValue - 1, "MOVE")
#	else:
#		print("move")
#		main_game_node.addToUndoStack(currID, currID, player_grid, player_grid + dir, curValue, curValue - 1, "MOVE")
#	if(isAnimate):
#		prev_player_grid = player_grid
#		disableAdjecantTiles()
#		main_game_node.EnableTile(prev_player_grid.x, prev_player_grid.y) # /***  >>NOTE>> CANNOT DO THIS IN OTHER FUNCTION DUE TO ADD TO UNDO STACK   ***/
#		player_grid = player_grid + dir
#		curValue -= 1
#		var tween = get_node("Tween")
#		tween.interpolate_property($".", "position",
#		position, position + (dir * Global.get_textureDistance()), 0.2,
#		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		tween.start()
#		yield($Tween, "tween_all_completed")
#		if(curValue == 0 || isUnlockingTile):
#			if isUnlockingTile:
#				main_game_node.addToUndoStack(currID, currID, prev_player_grid, player_grid, Global.get_max_val(), Global.get_max_val(), "DELETE")
#			else:
#				main_game_node.addToUndoStack(currID, currID, player_grid, player_grid, 1, 1, "DELETE")
#			enableAdjecantTiles()
#			gameScript.remove_player_from_array(self)
#			Global.set_is_input_handled(false)
#			Global.set_tile_toggle(false)
#			return
#		label.text = str(curValue)
#		enableAdjecantTiles()
#	gameScript.printPlayers()
#	Global.set_is_input_handled(false)
#	Global.set_tile_toggle(false)
#
#
## pass the collider then pass the move_left val and the collider's move_left val
#func calc_add(collider): 
#	MusicPlayer.onAddButton()
#	curValue = curValue + collider.get_current_value() + 1
#	print("THIS IS DEF HIT!")
#	collider.disableCurrentTile()
#	gameScript.remove_player_from_array_and_swap_to_id(collider, self)
#
## same as before but multiplying 
#func calc_multi(collider):
#	MusicPlayer.onMult()
#	curValue = curValue * collider.get_current_value() + 1
#	collider.disableCurrentTile()
#	gameScript.remove_player_from_array_and_swap_to_id(collider, self)
#
#
## /***   ??UPDATE?? NO LONGER NEEDED WE HAVE GLOBALS!!  ***/
## the value should be a bool
##func set_multi(val):
##	multi = val
##func get_multi():
##	return multi
#
## funtions to handel input 
## /*** !!CHANGE!!  NO LONGER A NEEDED FUNCTION UNLESS USING KEYBOARD  ***/
##func _on_up_pressed():
##	print("INSIDE UP FUNCTION!!")
##	using_swipe = false
##	move('ui_up')
##
##func _on_down_pressed():
##	print("INSIDE DOWN FUNCTION!!")
##	using_swipe = false
##	move('ui_down')
##
##func _on_left_pressed():
##	print("INSIDE LEFT FUNCTION!!")
##	using_swipe = false
##	move('ui_left')
##
##func _on_right_pressed():
##	print("INSIDE RIGHT FUNCTION!!")
##	using_swipe = false
##	move('ui_right')
#
#func set_pos(x,y):
#	position.x = x
#	position.y = y
##func get_pos_x():
##	return position.x
##func get_pos_y():
##	return position.y
#
#
## /***  !!CHANGE!!  <- UN-USED FUNCTION!!   ***/
##func _on_Area2D_area_exited(area):
##	pass
#
#
#
## /***  !!CHANGE!!  <- UN-USED FUNCTION!!   ***/
##func _on_Area2D_area_entered(area):
##	pass # Replace with function body.
#
#
## /***  !!CHANGE!!  <- UN-USED FUNCTION!!   ***/
##func print_area_id():
##	print($Area2D)
#
#
#func _on_TouchScreenButton_pressed():
#	isPlayerMovable = true
#	gameScript.update_player_vals(self)
##	gameScript.playerSwap(false)
#	#gameScript.change_to_this_player(isPlayerMovable)
#
##func set_canSwap(state):
##	canSwap = state
##
##func moving():
##	grid.STOP_PLAYERS(false)
##	timer.start()
##
##func can_this_player_move():
##	if player == Player_can_move:
##		return true
##	else:
##		return false
##
#func _on_Timer_timeout():
#	print("_On_TimeOut_PlayerClass")
##	gameScript.STOP_PLAYERS(true)
##	gameScript.playerSwap(true)
##	playing_game = true
#	#timer.stop() ??? THIS CAUSES THE TIMER TO AUTO STOP AT 0.3ms  SO WHY TIMER?









##/***   THIS IS ANGELO'S VERSION   [501]   ***/
#extends KinematicBody2D
#
## just gets the ray cast attached to the parent node, shouldn't need to be changed 
#export(Curve) var player_curve
#onready var ray = $RayCast2D
## change to the name of the labels 
#onready var lab = get_node("Label")
#onready var timer = $TouchScreenButton/Timer
#var node0
#var node1
#var node2
#var node3
#var tempX 
#var tempY 
#var vec_pos
#var cur_pos
#var prev_pos
## change to whatever node has the math functions
## and the functions that handle multible players 
#onready var grid = get_node("../") 
#var main_game_node 
#signal moved
#onready var sprite = $Sprite
#var speed = 256
## changes distance player moves, change this value only to match the tile sizes 
#var tile_size = 64
#var player = 0
#var Player_can_move = 0
#var Move_Left = 5
#var map_free_num = 16
## x,y; for checking if the tile the player is moving to is available 
#var player_grid = [0,0]
## for changing from swipe or btn controls 
#var using_swipe = false
#var operations = true
#var playing_game = true
#var multi = false
#var canSwap = true
#var tempXForStack = 0
#var tempYForStack = 0
#var tempCollectableUndoX = 0
#var tempCollectableUndoY = 0
#var isCollectableMove = false
#var mapSize = 5
#var delt = 0
#var t = 0
#var move = false
#var to_vec = Vector2(0,0)
#
## for btn controls
#var inputs = {
#	'ui_up': Vector2.UP,
#	'ui_down': Vector2.DOWN,
#	'ui_left': Vector2.LEFT,
#	'ui_right': Vector2.RIGHT
#}
#
#func set_map_size(num):
#	mapSize = num
#
#func get_map_size():
#	return mapSize
#
#func set_tile_size(val):
#	tile_size = val
#
## btn movement handeler 
#func _unhandled_input(event):
#	for dir in inputs.keys():
#		if event.is_action_pressed(dir):
#			using_swipe = false
#			move(dir)
#
#func get_player_grid_x():
#	return player_grid[0]
#
#func get_player_grid_y():
#	return player_grid[1]
#
#func set_player_grid(x, y, external_edit):
#	var tempx = player_grid[0]
#	var tempy = player_grid[1]
#	player_grid[0] = x
#	player_grid[1] = y
#	if external_edit == true:
#		grid.update_object_array(x,y,tempx, tempy, true)
#
#func get_tile_size():
#	return tile_size
#
#func Is_Game_running(state):
#	playing_game = state
#
#func send_player_remove_sig():
#	main_game_node.player_removed()
#
#func send_collect_remove_sig():
#	main_game_node.collect_removed()
#
## utility functions for the player 
#func set_player_move(num):
#	if Player_can_move != 99:
#		Player_can_move = num
#
#func get_player_move():
#	return Player_can_move
#
#func get_can_player_move():
#	return player
#
#func can_player_move(num):
#	player = num
#
#func set_moves_left(num):
#	Move_Left = num
#	lab.text = str(Move_Left)
#
#func get_player_moves_left():
#	return Move_Left
#
#func change_this_player():
#	sprite.modulate = Color("#ff6f59")
#
#func remove_player():
#	$Area2D/CollisionShape2D.set_deferred("disabled", true)
#	Player_can_move = 99
#	Move_Left = 0
#	player = 0
#	if player_array_check():
#		main_game_node.win_condition()
#	grid.remove_player_from_array(player_grid[0], player_grid[1])
#	grid.update_player_vals()
#
#func remove_check():
#	if Move_Left == 0 :
#		if player_array_check():
#			main_game_node.win_condition()
#
#		#Call TO ADD TO STACK
#		print(grid.get_cur_player_id())
#		print(tempXForStack)
#		print(tempYForStack)
#		print(tempCollectableUndoX)
#		print(tempCollectableUndoY)
#		main_game_node.addToUndoStack(grid.get_cur_player_id(), 
#		grid.get_cur_player_id(),tempXForStack, tempYForStack,
#		tempCollectableUndoX, tempCollectableUndoY, 1, 1,isCollectableMove, "DELETE")
#		remove_player()
#
#func set_main_game_node(name):
#	main_game_node = name
#	grid.set_board_node(name)
#
#func get_main_game_node():
#	return main_game_node
#
#func set_game_score_script(name):
#	grid.set_score_node(name)
#
#func set_map_num(num):
#	map_free_num = num
#
#func get_map_num():
#	return map_free_num
#
#func _ready():
#	Move_Left = (randi() % map_free_num + 2)
#	lab.text = str(Move_Left)
#
#
## handels math for movement and chages baised on type of input 
#func direction_math(pos, dir):
#	if using_swipe == false:
#		 pos = inputs[dir] * tile_size
#	elif using_swipe == true:
#		 pos = dir * tile_size
#	return pos
#
#func player_turn():
#	if player == Player_can_move:
#		sprite.modulate = Color("#ff6f59")
#	else:
#		sprite.modulate = Color(1,1,1)
#
#func check_adjacent_tiles(x,y):
#	return main_game_node.IsSpaceAvailable(x,y)
#
#func player_array_check():
#	if grid.state_of_player_array():
#		return true
#
#func connect_player():
#	connect("moved", main_game_node, "_player_moved")
#
#func _process(delta):
#	if move == true:
#		t += delta*0.4
#		self.position = self.position.linear_interpolate(to_vec,t)
#		if t > 0.3:
#			move = false
#			t = 0
#			cur_pos = position
#			if Move_Left != 1:
#				if tempX + 1 != mapSize+1  :
#					if node0 != main_game_node.GetTileState(tempX + 1, tempY) && main_game_node.GetTileState(tempX + 1, tempY) != null :
#						main_game_node.SetTileState(tempX + 1, tempY, node0)
#						#main_game_node.EnableTile(tempX + 1, tempY);
#				if tempX - 1 != 0:
#					if node1 != main_game_node.GetTileState(tempX - 1, tempY) && main_game_node.GetTileState(tempX - 1, tempY) != null :
#						main_game_node.SetTileState(tempX - 1, tempY, node1)
#						#main_game_node.EnableTile(tempX - 1, tempY);
#				if tempY + 1 != mapSize+1 :
#					if node2 != main_game_node.GetTileState(tempX, tempY + 1) && main_game_node.GetTileState(tempX, tempY + 1) != null:
#						main_game_node.SetTileState(tempX , tempY + 1, node2)
#						#main_game_node.EnableTile(tempX, tempY + 1);
#				if tempY - 1 != 0:
#					if node3 != main_game_node.GetTileState(tempX , tempY - 1) && main_game_node.GetTileState(tempX, tempY - 1) != null:
#						main_game_node.SetTileState(tempX , tempY - 1, node3)
#						#main_game_node.EnableTile(tempX, tempY - 1);
#				if tempX + 1 != mapSize+1 && (vec_pos.x != 0 && vec_pos.y != 0) && main_game_node.GetTileState(tempX + 1, tempY) != null:
#					node0 = main_game_node.GetTileState(tempX + 1, tempY)
#				if tempX - 1 != 0 && (vec_pos.x != 0 && vec_pos.y != 0) && main_game_node.GetTileState(tempX - 1, tempY) != null:
#					node1 = main_game_node.GetTileState(tempX - 1, tempY)
#				if tempY + 1 != mapSize+1 && (vec_pos.x != 0 && vec_pos.y != 0) && main_game_node.GetTileState(tempX, tempY + 1) != null:
#					node2 = main_game_node.GetTileState(tempX, tempY + 1)
#				if tempY - 1 != 0 && (vec_pos.x != 0 && vec_pos.y != 0) && main_game_node.GetTileState(tempX, tempY - 1) != null:
#					node3 = main_game_node.GetTileState(tempX, tempY - 1)
#				print(player_grid)
#
#
#
#
#func stop_moves():
#	timer.start()
#	playing_game = false
#
## handels moveing the player and responds to anything the player collides with 
#func move(dir):
#	player_turn()
#	grid.checkForGameOver()
#	if cur_pos == prev_pos && tempX != null:
#		print("did this work")
#		player_grid[0] = tempX
#		player_grid[1] = tempY
#	tempX = player_grid[0]
#	tempY = player_grid[1]
#	prev_pos = position
#	if player == Player_can_move  && playing_game == true :
#		var available_space = true
#		var tempCurrNumForStack = Move_Left
#		if Move_Left != 1 :
#			if tempX + 1 != mapSize+1 && main_game_node.GetTileState(tempX + 1, tempY) != null:
#				node0 = main_game_node.GetTileState(tempX + 1, tempY)
#				#main_game_node.DisableTile(tempX + 1, tempY);
#			if tempX - 1 != 0 && main_game_node.GetTileState(tempX - 1, tempY) != null:
#				node1 = main_game_node.GetTileState(tempX - 1, tempY)
#				#main_game_node.DisableTile(tempX - 1, tempY);
#			if tempY + 1 != mapSize+1 && main_game_node.GetTileState(tempX, tempY + 1) != null:
#				node2 = main_game_node.GetTileState(tempX, tempY + 1)
#				#main_game_node.DisableTile(tempX, tempY + 1);
#			if tempY - 1 != 0 && main_game_node.GetTileState(tempX, tempY - 1) != null:
#				node3 = main_game_node.GetTileState(tempX, tempY - 1)
#				#main_game_node.DisableTile(tempX , tempY - 1);
#		isCollectableMove = false
#		grid.setCollectable(false)
#		tempXForStack = player_grid[0]
#		tempYForStack = player_grid[1]
#		print("dir -> ", dir)
#		vec_pos = direction_math(vec_pos, dir)
#		if vec_pos.x != 0 && vec_pos.y != 0 && Move_Left % 2 != 0:
#			pass
#		# sanity checks to hopfully prevent an oob crash
#		elif player_grid[0] + (vec_pos.x / tile_size) > mapSize || player_grid[1] + (vec_pos.y / tile_size) > mapSize:
#			pass
#		elif player_grid[0] + (vec_pos.x / tile_size) < 0 || player_grid[1] + (vec_pos.y / tile_size) < 0:
#			pass
#		else:
#			ray.cast_to = vec_pos
#			ray.force_raycast_update()
#			player_grid[0] = player_grid[0] + (vec_pos.x / tile_size)
#			player_grid[1] = player_grid[1] + (vec_pos.y / tile_size)
#			if !ray.is_colliding():
#				move = true
#				stop_moves()
#				to_vec = position + vec_pos
#				#position += vec_pos
#				#cur_pos = position 
#				if Move_Left!= map_free_num: 
#					Move_Left = Move_Left - 1
#				lab.text = str(Move_Left)
#				remove_check()
#			else:
#				var collider = ray.get_collider()
#				print(collider)
#				if (Move_Left == map_free_num):
#					if (main_game_node.IsTileLocked(player_grid[0], player_grid[1]) == true):
#						main_game_node.UnlockLocked(player_grid[0], player_grid[1])
#
#						#ADDING TO UNDO STACK
#						main_game_node.addToUndoStack(grid.get_cur_player_id(), 
#						grid.get_cur_player_id(),tempXForStack, tempYForStack,
#						player_grid[0], player_grid[1], Move_Left, Move_Left,isCollectableMove, "UNLOCK")
#
#						remove_player()
#						remove_check()
#
#				elif main_game_node.IsSpaceAvailable(player_grid[0], player_grid[1]) == false && !collider.is_in_group('Collectable'):
#					player_grid[0] = player_grid[0] - (vec_pos.x / tile_size)
#					player_grid[1] = player_grid[1] - (vec_pos.y / tile_size)
#				elif collider.is_in_group('Collectable'): # collectable 
#					move = true
#					stop_moves()
#					to_vec = position + vec_pos
#					cur_pos = position + vec_pos
#					#position += vec_pos
#					isCollectableMove = true
#					grid.setCollectable(true)
#					#FOR UNDOING COLLECTABLES <- EMILIO
#					tempCollectableUndoX = player_grid[0]
#					tempCollectableUndoY = player_grid[1]
#
#					if Move_Left != map_free_num:
#						Move_Left = Move_Left - 1
#					lab.text = str(Move_Left)
#					collider.remove_collectable()
#					remove_check();
#				elif collider.is_in_group('Player'): # other players 
#					if collider.Player_push(dir, using_swipe, collider) && collider.get_player_moves_left() != map_free_num && check_collider_val(collider):
#						#position += vec_pos
#						if collider.get_player_moves_left() != 0 && collider.get_player_moves_left() < map_free_num && Move_Left < map_free_num:
#							if Move_Left % 2 == 0 && multi == true && (Move_Left * collider.get_player_moves_left()) <= map_free_num :
#								move = true
#								stop_moves()
#								to_vec = position + vec_pos
#								cur_pos = position + vec_pos
#								calc_multi(collider) 
#								collider.remove_player()
#							elif (Move_Left + collider.get_player_moves_left()) <= map_free_num:
#								move = true
#								stop_moves()
#								to_vec = position + vec_pos
#								cur_pos = position + vec_pos
#								calc_add(collider) 
#								collider.remove_player()
#							else:
#								print("can this thing get it right")
#								player_grid[0] = tempX
#								player_grid[1] = tempY
#
#						#DEV EMILIO FIX FOR NUMBER ON LOCKED TILE
#						if main_game_node.IsTileImm(player_grid[0], player_grid[1]) == true:
#							main_game_node.SetTileAfterMerge(player_grid[0], player_grid[1])
#
#						remove_check();
#
#				#elif (collider.get_class() == "StaticBody2D" && !main_game_node.IsTileLocked(player_grid[0], player_grid[1])):
#				#	position += vec_pos
#				#	cur_pos = position
#				#	if Move_Left!= map_free_num: 
#				#		Move_Left = Move_Left - 1
#				#	lab.text = str(Move_Left)
#				#	remove_check()
#	if Move_Left != 1 || Move_Left != 0:
#		grid.STOP_PLAYERS(true)
#
#
#
# pass the collider 
#func check_collider_val(collider):
#	if multi == true : 
#		if Move_Left * collider.get_player_moves_left() <= map_free_num:
#			return true
#		else :
#			return false 
#	elif multi == false :
#		if Move_Left + collider.get_player_moves_left() <= map_free_num:
#			return true
#		else:
#			return false
#	else:
#		return false 

# pass the collider then pass the move_left val and the collider's move_left val
#func calc_add(collider): 
#	MusicPlayer.onAddButton()
#	var temp =  Move_Left + collider.get_player_moves_left()
#	Move_Left = temp
#	lab.text = str(Move_Left)
#
#	#Call TO ADD TO STACK
#	var tempX = get_player_grid_x()
#	var tempY = get_player_grid_y()
#	var tempCurrNumForStack = Move_Left - collider.get_player_moves_left()
#	var collideID = grid.getPlayerByObj(collider)
#	main_game_node.addToUndoStack(grid.get_cur_player_id(), 
#	collideID,tempXForStack, tempYForStack,
#	tempX, tempY, tempCurrNumForStack, Move_Left, isCollectableMove, "ADD")
#
#
## the value should be a bool
#func set_multi(val):
#	multi = val
#	print("changed ability to multiply or add")
#func get_multi():
#	return multi
## same as before but multiplying 
#func calc_multi(collider):
#	MusicPlayer.onMult()
#	var temp = Move_Left * collider.get_player_moves_left()
#	Move_Left = temp
#	lab.text = str(Move_Left)
#
#	#Call TO ADD TO STACK
#	var tempX = get_player_grid_x()
#	var tempY = get_player_grid_y()
#	var tempCurrNumForStack = Move_Left - collider.get_player_moves_left()
#	var collideID = grid.getPlayerByObj(collider)
#	main_game_node.addToUndoStack(grid.get_cur_player_id(), 
#	collideID,tempXForStack, tempYForStack,
#	tempX, tempY, collider.get_player_moves_left(), Move_Left, isCollectableMove,  "MULTIPLY")

# for pushing a player if another player collides and a math operation can't be done 
#func Player_push(dir, swipe, collider):
#	var vec_pos
#	if swipe == false:
#		 vec_pos = inputs[dir] * tile_size
#	elif swipe == true:
#		 vec_pos = dir * tile_size
#	ray.cast_to = vec_pos
#	ray.force_raycast_update()
#	if !ray.is_colliding():
#		return true
#	else:
#		return true

# funtions to handel input 
#func _on_up_pressed():
#	using_swipe = false
#	move('ui_up')
#
#func _on_down_pressed():
#	using_swipe = false
#	move('ui_down')
#
#func _on_left_pressed():
#	using_swipe = false
#	move('ui_left')
#
#func _on_right_pressed():
#	using_swipe = false
#	move('ui_right')
#
#
#func set_pos(x,y):
#	position.x = x
#	position.y = y
#
#func get_pos_x():
#	return position.x
#
#func get_pos_y():
#	return position.y
#
#func _on_Area2D_area_exited(area):
#	pass
#
#func _on_SwipeDetector_swipe(direction):
#	grid.STOP_PLAYERS(false)
#	using_swipe = true
#	if player == Player_can_move  && playing_game == true:
#		move(-direction)
#
##func _on_Area2D_area_entered(area):
##	pass # Replace with function body.
#
#func print_area_id():
#	print($Area2D)
#
#func _on_TouchScreenButton_pressed():
#	grid.update_player_vals()
#	grid.playerSwap(false)
#	grid.change_to_this_player(Player_can_move)
#
#func set_canSwap(state):
#	canSwap = state
#
#func moving():
#	grid.STOP_PLAYERS(false)
#	timer.start()
#
#func can_this_player_move():
#	if player == Player_can_move:
#		return true
#	else:
#		return false
#
#func _on_Timer_timeout():
#	grid.STOP_PLAYERS(true)
#	grid.playerSwap(true)
#	playing_game = true
#	timer.stop()
