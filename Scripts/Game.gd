###/***   THIS IS EMILIO'S VERSION  [232]   ***/
extends Node2D
onready var Player_og = load("res://Scenes/Player.tscn")
onready var Collectabel_og = load("res://Scenes/Collectable.tscn")
onready var swipe = get_parent().get_node("SwipeDetector")
onready var timer = get_node("../Label/Timer")
onready var game_score = get_node("../Label") 
var game_board_node
var running = true 
var array_of_players = []
var i = 0
var z = 0
var playerScale
func isPlayerArrayEmpty():
	return array_of_players.size() == 0
func setPlayerScale(var val):
	playerScale = val
func placeAtIndexInArray(var index, var obj):
	array_of_players.insert(index,obj)
func getPlayerByObj(var obj):
	var z = 0;
	for p in array_of_players:
		if(obj == p):
			return z
		z = z + 1
func printPlayers():
	for p in array_of_players:
		printraw(p.get_current_value(), ", ")
	print("\n")
func getIDFromObj(var obj):
	var index = 0
	for p in array_of_players:
		if p.get_is_player_movable():
			return index
		index += 1
func get_cur_player_id():
	for aIndex in range(array_of_players.size()):
		if array_of_players[aIndex].get_is_player_movable(): 
			return aIndex
func remove_player_from_array(var obj):
	if  array_of_players.size() != 1:
		var id = getPlayerByObj(obj)
		if id == array_of_players.size() - 1:
			update_player_vals(array_of_players[id - 1])
		else:
			update_player_vals(array_of_players[id + 1])
		array_of_players.remove(id)
		obj.queue_free()
		MusicPlayer.onDeletePlayer()
	else:
		var id = getPlayerByObj(obj)
		array_of_players.remove(id)
		obj.queue_free()
		timer.stop()
		game_board_node.win_condition()
func remove_player_from_array_and_swap_to_id(var obj, var swapObj):
	if  array_of_players.size() != 1:
		var id = getPlayerByObj(obj)
		var idSwap = getPlayerByObj(swapObj)
		update_player_vals(array_of_players[idSwap])
		array_of_players.remove(id)
		obj.queue_free()
		MusicPlayer.onDeletePlayer()
	else:
		var id = getPlayerByObj(obj)
		array_of_players.remove(id)
		obj.queue_free()
		timer.stop()
		game_board_node.win_condition()
	Global.set_is_input_handled(false)
func make_players(player, num_x, num_y, move_val,grid_x, grid_y, make_while_running, node):
	var temp_x = 0
	var temp_y = 0
	player = Player_og.instance()
	add_child(player)
	player.set_main_game_node(node)
	if make_while_running == true:
		player.set_pos( num_x ,  num_y )
		player.set_player_grid(grid_x, grid_y, false);
	else:
		player.set_pos( num_x ,  num_y )
	array_of_players.append(player)
	swipe.connect_node(player)
	if move_val > 0:
		player.set_moves_left(move_val)
	z = 0
	for p in array_of_players:
		if p != null:
			p.set_is_player_moveable 
			z = z + 1
	add_to_player_array(player)
func make_rand_val(val_max, val_min):
	var num = 0
	num = randi() % val_max - val_min
	return num
# pass the player/collectable index you want to get 
func get_player_at_index(index):
	if index < array_of_players.size() && array_of_players.size() != 0:
		return array_of_players[index]
	else:
		return null
func get_cur_player():
	for p in array_of_players:
		if p.get_is_player_movable():
			return p
func get_player_array_size():
	print("SIIZEEE ->", array_of_players.size())
	return array_of_players.size()
func sub_score():
	Global.set_score(Global.get_score() - 5) 
	game_score.text = str(Global.get_score())
func STOP_PLAYERS(state):
	for p in array_of_players:
		if p.get_is_player_movable():
			p.Is_Game_running(state)
func add_to_player_array(obj):
	var player = obj
	array_of_players.append(player)
	var z = 0
	for p in array_of_players:
		if p != null:
			p.set_is_player_movable(false) 
			p.player_turn()
			z = z + 1
	array_of_players[0].set_is_player_movable(true)
	array_of_players[0].player_turn()
func player_split():
	MusicPlayer.onSplit()
	var curr = 0
	for p in array_of_players:
		if p.get_is_player_movable():
			break
		curr += 1 
	if array_of_players[curr].get_current_value() % 2 == 0:
		var posOffset
		var gridOffset
		if array_of_players[curr].checkForCollisionRight():
			posOffset = Vector2.RIGHT * Global.get_textureDistance()
			gridOffset = Vector2(1,0)
			pass
		elif array_of_players[curr].checkForCollisionUp():
			posOffset = Vector2.UP * Global.get_textureDistance()
			gridOffset = Vector2(0,-1)
			pass
		elif array_of_players[curr].checkForCollisionLeft():
			posOffset = Vector2.LEFT * Global.get_textureDistance()
			gridOffset = Vector2(-1,0)
			pass
		elif array_of_players[curr].checkForCollisionDown():
			posOffset = Vector2.DOWN * Global.get_textureDistance()
			gridOffset = Vector2(0,1)
			pass
		else:
			return
		game_board_node.addToUndoStack(curr, curr + 1, array_of_players[curr].player_grid, array_of_players[curr].player_grid  + gridOffset, array_of_players[curr].get_current_value(), array_of_players[curr].get_current_value(), "SPLIT")
		var player = Player_og.instance()
		player.scale = array_of_players[curr].scale
		player.position = array_of_players[curr].position + posOffset
		player.set_player_grid_vector(array_of_players[curr].player_grid + gridOffset)
		add_child(player)
		player.main_game_node = game_board_node
		array_of_players[curr].set_current_value(array_of_players[curr].get_current_value() / 2)
		player.set_current_value(array_of_players[curr].get_current_value())
		swipe.connect_node(player)
		placeAtIndexInArray(curr + 1,player)
		update_player_vals(player)
func update_player_vals(obj):
	for p in array_of_players:
		if p == obj:
			p.set_is_player_movable(true)
			p.player_turn()
		else:
			p.set_is_player_movable(false)
			p.player_turn()
func set_board_node(name):
	game_board_node = name
func _on_Change_player_pressed():
	i = i + 1
	if (i >= array_of_players.size()):
		i = 0
	for p in array_of_players:
		if p != null:
			p.can_player_move(i)
func Change_player():
	MusicPlayer.onChangePlayer()
	var curr = 0
	for p in array_of_players:
		if p.get_is_player_movable():
			if curr == array_of_players.size() - 1:
				update_player_vals(array_of_players[0])
			else:
				update_player_vals(array_of_players[curr+1])
			return
		curr += 1
func _on_Split_player_pressed():
	pass
func _on_Timer_timeout():
	sub_score()
func _on_Player_multi_pressed():
	for p in array_of_players:
		if p != null:
			var temp = p.get_multi()
			p.set_multi(!temp)
func disable_player(index):
	if index < array_of_players.size()-1 && array_of_players[index] != null:
		array_of_players[index].set_is_player_movable(false)
	else:
		return
func enable_player(index):
	if index < array_of_players.size()-1 && array_of_players[index] != null:
		array_of_players[index].set_is_player_movable(true)
	else:
		return
func in_play(index):
	var obj = array_of_players[index]
	update_player_vals(obj)
















##/***   THIS IS EMILIO'S COMMENT VERSION   [574]   ***/
#extends Node2D
#onready var Player_og = load("res://Scenes/Player.tscn")
#onready var Collectabel_og = load("res://Scenes/Collectable.tscn")
#onready var swipe = get_parent().get_node("SwipeDetector")
#onready var timer = get_node("../Label/Timer")
#onready var game_score = get_node("../Label") 
#var game_board_node
#var running = true 
#var array_of_players = []
##var array_of_collectables = []  # /***  !!CHANGE!!  <- NO LONGER NEED A COLLECTABLE ARRAY, UNLESS YOU ADD DIFFERENT KINDS OF COLLECTABLE   ***/ 
##var array_of_objects = []  # /***  !!CHANGE!!  <- NO LONGER NEED AN OBJECT ARRAY, UNLESS YOU ADD DIFFERENT KINDS OF COLLECTABLE   ***/ 
##var width = 10   /***  !!CHANGE!!  <- REPLACED WITH MAX NUM GLOBAL   ***/
##var height = 10
#var i = 0
#var z = 0
##var grid_size = 64 # !!CHANGE!! <- REPLACE WITH TEXTURE_DSTANCE
#var playerScale
##var isCollectableMove = false # /***  !!CHANGE!!  <- NO LONGER NEED A COLLECTABLE ARRAY, UNLESS YOU ADD DIFFERENT KINDS OF COLLECTABLE   ***/
#
#
## this can be cleared after merging, but the timer needs to be kept
##func _ready():
##	create_object_array()
#
##func create_object_array():
##	print("Grid -> ", Global.get_grid())
##	for x in range(Global.get_grid()):
##		array_of_objects.append([])
##		for y in range(Global.get_grid()):
##			array_of_objects[x].append(0)
#
#func isPlayerArrayEmpty():
#	return array_of_players.size() == 0
#func setPlayerScale(var val):
#	playerScale = val
#
## /***  !!CHANGE!! <- UN-USED FUNCTIONS   ***/
##func set_grid_size(grid):
##	grid_size = grid
##	print("grid_size -> ",grid_size)
##
##func get_grid_size():
##	return grid_size
#
##func start_timer():
##	timer.start()
#
## MADE BY EMILIO FOR STACK ALG.
#func placeAtIndexInArray(var index, var obj):
#	array_of_players.insert(index,obj)
##	for p in array_of_players:
##		if p != null:
##			p.set_is_player_movable(false) # /***  !!CHANGE!!  ->  p.set_player_move(z)   ***/
##			p.player_turn()
##	var tempx = obj.get_player_grid_x() - 1
##	var tempy = obj.get_player_grid_y() - 1
##	array_of_objects[tempy][tempx] = 1
## /***  !!CHANGE!!  <- NO LONGER NEED A COLLECTABLE ARRAY, UNLESS YOU ADD DIFFERENT KINDS OF COLLECTABLE   ***/
##func setCollectable(var val):
##	isCollectableMove = val
#func getPlayerByObj(var obj):
#	var z = 0;
#	for p in array_of_players:
#		if(obj == p):
#			return z
#		z = z + 1
#func printPlayers():
#	for p in array_of_players:
##		if p != null:
#		printraw(p.get_current_value(), ", ")
#	print("\n")
#
#
## /***   ??UPDATE??  THIS NEW SYSTEM MAY REQUIRE YOU TO DO THIS IF GETTING ID OF ANOTHER PLAYER   ***/
##set_is_player_movable(false)
##collider.set_is_player_movable(true)
##var colliderID = gameScript.getIDFromObj(collider)
##collider.set_is_player_movable(false)
##set_is_player_movable(true)
#func getIDFromObj(var obj):
#	var index = 0
#	for p in array_of_players:
#		if p.get_is_player_movable():
#			return index
#		index += 1
#
#
## /***  ??UPDATE??  WHY ARE WE DOING THIS WHEN WE CAN JUST HAVE AN INDEX FOR AN ARRAY   ***/
## /***  ??UPDATE??  THE INDEX WOULD DROP STORAGE SPACE   ***/
### COMEBACK TO THIS FUNCTION!!
#func get_cur_player_id():
#	for aIndex in range(array_of_players.size()):
##		if array_of_players[aIndex] != null:
#		if array_of_players[aIndex].get_is_player_movable(): #if array_of_players[aIndex].get_player_move() == array_of_players[aIndex].get_can_player_move():
#			return aIndex
#
##func update_object_array(x_new, y_new, x_prev, y_prev, is_from_external_edit):
##	if(!is_from_external_edit):
##		var currNum
##		if (i < 0):
##			if array_of_players.size() == 0:
##				game_board_node.win_condition()
##			elif array_of_players[0]!= null:
##				 i = array_of_players[0].get_can_player_move()
##		if(array_of_players.size() > i && i >= 0):
##
##			currNum = array_of_players[i].get_player_moves_left()
##		else:
##			currNum = -1;
##		var currID = get_cur_player_id()
##		game_board_node.call("addToUndoStack", currID, currID, x_prev, y_prev, x_new, y_new, currNum + 1, currNum,isCollectableMove, "MOVE")
##	array_of_objects[y_prev][x_prev] = 0
##
##	array_of_objects[y_new][x_new] = 1
##func add_player_to_object_array(x,y):
##	if array_of_players.size() != 0:
##		array_of_objects[y][x] = 1
#
## /***   WITHOUT ARRAY OF OBJECTS   ***/
#func remove_player_from_array(var obj):
#	if  array_of_players.size() != 1:
#		var id = getPlayerByObj(obj)
#		if id == array_of_players.size() - 1:
#			update_player_vals(array_of_players[id - 1])
#		else:
#			update_player_vals(array_of_players[id + 1])
#		array_of_players.remove(id)
#		obj.queue_free()
#		MusicPlayer.onDeletePlayer()
#	else:
#		obj.queue_free()
#		timer.stop()
#		game_board_node.win_condition()
#
#func remove_player_from_array_and_swap_to_id(var obj, var swapObj):
#	if  array_of_players.size() != 1:
#		var id = getPlayerByObj(obj)
#		var idSwap = getPlayerByObj(swapObj)
#		update_player_vals(array_of_players[idSwap])
#		array_of_players.remove(id)
#		obj.queue_free()
#		MusicPlayer.onDeletePlayer()
#	else:
#		obj.queue_free()
#		timer.stop()
#		game_board_node.win_condition()
#	Global.set_is_input_handled(false)
##func remove_player_from_array(x,y):
##	if  array_of_players.size() != 0:
###		array_of_objects[y][x] = 0
##
##		MusicPlayer.onDeletePlayer()
#
## function for making players, takes a var and adds that to the active player array
## parameters ; player: original player, num_x: the x position, num_y: the y position 
#func make_players(player, num_x, num_y, move_val,grid_x, grid_y, make_while_running, node):
#	var temp_x = 0
#	var temp_y = 0
#	player = Player_og.instance()
#	add_child(player)
#	player.set_main_game_node(node)
#	# first one is for generating a player on start, the second is for everything else
#	if make_while_running == true:
#		player.set_pos( num_x ,  num_y )
#		player.set_player_grid(grid_x, grid_y, false);
#	else:
#		player.set_pos( num_x ,  num_y )
#	array_of_players.append(player)
#	swipe.connect_node(player)
#	if move_val > 0:
#		player.set_moves_left(move_val)
#	z = 0
#	for p in array_of_players:
#		if p != null:
#			p.set_is_player_moveable # /***  !!CHANGE!! ->  p.set_player_move(z)   ***/
#			z = z + 1
#	add_to_player_array(player)
#
##	add_player_to_object_array(grid_x, grid_y)
#
#func make_rand_val(val_max, val_min):
#	var num = 0
#	num = randi() % val_max - val_min
#	return num
## pass the player/collectable index you want to get 
#func get_player_at_index(index):
#	if index < array_of_players.size() && array_of_players.size() != 0:
#		return array_of_players[index]
#	else:
#		return null
#
## /***  !!CHANGE!!  <- NO LONGER NEED A COLLECTABLE ARRAY, UNLESS YOU ADD DIFFERENT KINDS OF COLLECTABLE   ***/
##func get_collect_at_index(index):
##	return array_of_collectables[index]
#
#func get_cur_player():
#	for p in array_of_players:
#		if p != null:
#			if p.get_player_move() == p.get_can_player_move():
#				return p
## *MY FUNCTIONS *
## /***  !!CHANGE!!  <- NO LONGER NEED A COLLECTABLE ARRAY, UNLESS YOU ADD DIFFERENT KINDS OF COLLECTABLE   ***/
##func get_collectible_array_size():
##	return array_of_collectables.size()
#func get_player_array_size():
#	if array_of_players.size() != 0:
#		return array_of_players.size()
#	else:
#		return 0
#
## creates a new collectable and adds it as a child
## parameters ; collectable: original collectable, num_x: the x position, num_y: the y position  
## shuold not be used after game starts
## /***  !!CHANGE!!  <- NO LONGER NEED A COLLECTABLE ARRAY, UNLESS YOU ADD DIFFERENT KINDS OF COLLECTABLE   ***/
##func make_collectables(collectable, num_x, num_y):
##	var temp_x = 0
##	var temp_y = 0
##	collectable = Collectabel_og.instance()
##	temp_x = collectable.get_pos_x()
##	temp_y = collectable.get_pos_y()
##	add_child(collectable)
##	collectable.set_pos(temp_x + (Global.get_textureDistance() * num_x ), temp_y + (Global.get_textureDistance() * num_y ))
##	array_of_collectables.append(collectable)
##	var temp_num = 0
##	for c in array_of_collectables:
##		c.set_collect_num(temp_num)
##		temp_num = temp_num + 1
#
#func sub_score():
#	Global.set_score(Global.get_score() - 5) 
#	game_score.text = str(Global.get_score())
#
## /***  !!CHANGE!!  <- NO LONGER NEED A COLLECTABLE ARRAY, UNLESS YOU ADD DIFFERENT KINDS OF COLLECTABLE   ***/
##func remove_collectable(num):
##	var check = 0
##	for c in array_of_collectables:
##		var temp = c.get_collect_num()
##		if (temp == num):
##			array_of_collectables.remove(check)
##			c.queue_free()
##			Global.set_score(Global.get_score + 500)
##		check += 1
#
#func STOP_PLAYERS(state):
#	for p in array_of_players:
#		if p.get_is_player_movable():
#			p.Is_Game_running(state)
#
## both these functions are for adding objects to the arrays in this class to manage the 
## objects and remove them when they are nolonger needed or used 
#func add_to_player_array(obj):
#	var player = obj
#	array_of_players.append(player)
#	var z = 0
#	for p in array_of_players:
#		if p != null:
#			p.set_is_player_movable(false) # /***   !!CHANGE!!  -> p.set_player_move(z)   ***/
#			p.player_turn()
#			z = z + 1
#	array_of_players[0].set_is_player_movable(true)
#	array_of_players[0].player_turn()
##	var tempx = player.get_player_grid_x() - 1
##	var tempy = player.get_player_grid_y() - 1
##	array_of_objects[tempy][tempx] = 1
#
## /***  !!CHANGE!!  <- NO LONGER NEED A COLLECTABLE ARRAY, UNLESS YOU ADD DIFFERENT KINDS OF COLLECTABLE   ***/
##func add_to_collect_array(obj):
##	var collect = obj
##	array_of_collectables.append(collect)
##	var temp_num = 0
##	for c in array_of_collectables:
##		c.set_collect_num(temp_num)
##		temp_num = temp_num + 1
#
## /***  !!CHANGE!!  <- THIS IS ONLY USED IN REMOVE PLAYER FROM ARRAY< WHICH ALREADY CHECK IF ARRAY IS EMPTY  ***/
##func state_of_player_array():
##	if array_of_players.size() < 1:
##		timer.stop()
##		return true
##	else:
##		return false
## creates a new player when the split command is issued 
#func player_split():
#	MusicPlayer.onSplit()
#	var curr = 0
#	for p in array_of_players:
#		if p.get_is_player_movable():
#			break
#		curr += 1 
#	# /*** >>NOTE>>  <-  CAN ONLY SPLIT IF USING AN EVEN NUMBER   ***/
#	if array_of_players[curr].get_current_value() % 2 == 0:
#		var posOffset
#		var gridOffset
#		if array_of_players[curr].checkForCollisionRight():
#			posOffset = Vector2.RIGHT * Global.get_textureDistance()
#			gridOffset = Vector2(1,0)
#			pass
#		elif array_of_players[curr].checkForCollisionUp():
#			posOffset = Vector2.UP * Global.get_textureDistance()
#			gridOffset = Vector2(0,-1)
#			pass
#		elif array_of_players[curr].checkForCollisionLeft():
#			posOffset = Vector2.LEFT * Global.get_textureDistance()
#			gridOffset = Vector2(-1,0)
#			pass
#		elif array_of_players[curr].checkForCollisionDown():
#			posOffset = Vector2.DOWN * Global.get_textureDistance()
#			gridOffset = Vector2(0,1)
#			pass
#		else:
#			return
#		game_board_node.addToUndoStack(curr, curr + 1, array_of_players[curr].player_grid, array_of_players[curr].player_grid  + gridOffset, array_of_players[curr].get_current_value(), array_of_players[curr].get_current_value(), "SPLIT")
#		var player = Player_og.instance()
#		player.scale = array_of_players[curr].scale
#		player.position = array_of_players[curr].position + posOffset
#		player.set_player_grid_vector(array_of_players[curr].player_grid + gridOffset)
#		add_child(player)
#		player.main_game_node = game_board_node
#		array_of_players[curr].set_current_value(array_of_players[curr].get_current_value() / 2)
#		player.set_current_value(array_of_players[curr].get_current_value())
#		swipe.connect_node(player)
#		placeAtIndexInArray(curr + 1,player)
#		update_player_vals(player)
#
##	if i < array_of_players.size() && i >= 0:
##		var temp_x = 0
##		var temp_y = 0
##		var check = 0
##		var gridx = 0
##		var gridy = 0
##		var player = null
##		var board_node = null
##		var testing = 0
##		var map_num = 0
##		var tile_size = 0
##		var map_size = 0
##		player = Player_og.instance()
##		temp_x = array_of_players[i].get_pos_x()
##		temp_y = array_of_players[i].get_pos_y()
##		check = array_of_players[i].get_player_moves_left()
##		gridx = array_of_players[i].get_player_grid_x() 
##		gridy = array_of_players[i].get_player_grid_y() 
##		map_size = Global.get_grid
##		var x_prev = gridx
##		var y_prev = gridy
##		var num_prev = check
##		board_node = array_of_players[i].get_main_game_node()
##		map_num = array_of_players[i].get_map_num()
###		tile_size = array_of_players[i].get_tile_size()
##		var grid_size = Global.get_textureDistance()  #/***   !!OPTIMIIZE!! WHATS THE POINT OF LINE ABOVE   ***/
##		if array_of_players[i].get_player_moves_left() % 2 == 0:
##			check = check / 2
##			if gridx + 1 < 9 && array_of_players[i].check_adjacent_tiles( gridx + 1, gridy) && (array_of_objects[gridy][ gridx + 1] == 0):
##				temp_x = temp_x + grid_size
##				gridx = gridx + 1
##			elif gridy - 1 >= 0 && array_of_players[i].check_adjacent_tiles(gridx, gridy - 1) && (array_of_objects[gridy - 1][ gridx] == 0):
##				temp_y = temp_y - grid_size
##				gridy = gridy - 1
##			elif gridx - 1 >= 0 && array_of_players[i].check_adjacent_tiles( gridx - 1, gridy) &&  (array_of_objects[gridy][ gridx - 1] == 0):
##				temp_x = temp_x - grid_size
##				gridx = gridx - 1
##			elif gridy + 1 < 9 && array_of_players[i].check_adjacent_tiles(gridx ,gridy + 1) &&  (array_of_objects[gridy + 1][ gridx] == 0):
##				temp_y = temp_y + grid_size
##				gridy = gridy + 1
##			if temp_x != array_of_players[i].get_pos_x() || temp_y != array_of_players[i].get_pos_y():
##				player = Player_og.instance()
##				player.scale = playerScale
##				player.set_pos( temp_x ,  temp_y )
##				add_child(player)
##				player.set_player_grid(gridx, gridy, false);
##				player.set_main_game_node(board_node)
##				swipe.connect_node(player)
##				player.set_moves_left(check)
##				player.set_map_num(map_num)
##				z = 0
##				for p in array_of_players:
##					if p != null:
##						p.set_is_player_movable(false)# /***   !!CHANGE!!  ->  p.set_player_move(z)   ***/
##						z = z + 1
##				var currPlayerID = get_cur_player_id()
##				placeAtIndexInArray(currPlayerID + 1,player)
##				add_player_to_object_array(gridx, gridy)
###				game_board_node.call("addToUndoStack", currPlayerID, currPlayerID + 1, x_prev, y_prev, gridx, gridy, num_prev, num_prev,isCollectableMove, "SPLIT")
##				array_of_players[i].set_moves_left(check)
#
#
##func checkForGameOver():
##	var gridx = 0
##	var gridy = 0
##	var non_null_players = 0
##	var possable_moves = 0
##	for p in array_of_players:
##		if p != null:
##			non_null_players = non_null_players + 1
##			gridx = p.get_player_grid_x() 
##			gridy = p.get_player_grid_y() 
##			if gridx + 1 < 9 && p.check_adjacent_tiles( gridx + 1, gridy) || (array_of_objects[gridy][ gridx + 1] != 0):
##				possable_moves = possable_moves + 1
##			if gridy - 1 >= 0 && p.check_adjacent_tiles(gridx, gridy - 1) || (array_of_objects[gridy - 1][ gridx] != 0):
##				possable_moves = possable_moves + 1
##			if gridx - 1 >= 0 && p.check_adjacent_tiles( gridx - 1, gridy) ||  (array_of_objects[gridy][ gridx - 1] != 0):
##				possable_moves = possable_moves + 1
##			if gridy + 1 < 9 && p.check_adjacent_tiles(gridx ,gridy + 1) ||  (array_of_objects[gridy + 1][ gridx] != 0):
##				possable_moves = possable_moves + 1
##			if p.get_player_moves_left() % 2 == 0:
##				if gridy + 1 < 9 && p.check_adjacent_tiles(gridx + 1 ,gridy + 1) ||  (array_of_objects[gridy + 1][ gridx + 1] != 0):
##					possable_moves = possable_moves + 1
##				if gridy + 1 < 9 && p.check_adjacent_tiles(gridx - 1 ,gridy + 1) ||  (array_of_objects[gridy + 1][ gridx - 1] != 0):
##					possable_moves = possable_moves + 1
##				if gridy + 1 < 9 && p.check_adjacent_tiles(gridx + 1 ,gridy - 1) ||  (array_of_objects[gridy - 1][ gridx + 1] != 0):
##					possable_moves = possable_moves + 1
##				if gridy + 1 < 9 && p.check_adjacent_tiles(gridx - 1 ,gridy - 1) ||  (array_of_objects[gridy - 1][ gridx - 1] != 0):
##					possable_moves = possable_moves + 1
##	if possable_moves == 0 && non_null_players != 0:
##		game_board_node.game_over()  
#
##func playerSwap(state):
##	for p in array_of_players:
##		p.set_canSwap(state)
#
##func change_to_this_player(playerNum):
##	MusicPlayer.onChangePlayer()
##	if array_of_players.size() != 0:
###		for p in array_of_players:
###			p.Is_Game_running(false)
##		#	i = playerNum
##		for p in array_of_players:
##			if p.get_is_player_movable():
##				p.player_turn()
###		for p in array_of_players:
###			p.Is_Game_running(true)
#
#func update_player_vals(obj):
#	for p in array_of_players:
#		if p == obj:
#			p.set_is_player_movable(true)
#			p.player_turn()
#		else:
#			p.set_is_player_movable(false)
#			p.player_turn()
##			tempMove = tempMove + 1
##	var check = 0
##	if array_of_players.size() != 0:
##		for num in array_of_players:
##			if num != null:
##				if check >= array_of_players.size():
##					break
##				var temp = num.get_current_value()
##				if (temp == 0):
##					array_of_players.remove(check)
##					num.queue_free()
##					var tempMove = 0
###					i = i - 1
##					for p in array_of_players:
##						if p != null:
##							p.set_is_player_movable(false) # /***   !!CHANGE!!  ->  p.set_player_move(tempMove)   ***/
##							tempMove = tempMove + 1
##							i = 0
##					for p in array_of_players:
##						if p != null:
##							p.can_player_move(i)
##					for p in array_of_players:
##						if p != null:
##							p.Is_Game_running(false)
##					if array_of_players.size() > 1:
##						if array_of_players[0] != null:
##							Global.set_score(Global.get_score + 200)
##				check += 1
##		var c = 0
##		for p in array_of_players:
##			if p != null:
##				if (array_of_players.size() > 1):
##					if c == Global.get_curActivePlayer():
##						p.set_is_player_movable(true) # /***  !!CHANGE!!  -> p.set_player_move(c)   ***/
##				else:
##					if p != null:
##						p.set_is_player_movable(false) # /***  !!CHANGE!!  -> p.set_player_move(0)   ***/
##					c = c + 1
##			if p != null:
##				p.player_turn()
##		var validation = 0
##		for p in array_of_players:
##			if p != null:
##				validation = validation + 1
##	var validation = 0
##	for p in array_of_players:
##		if p != null:
##			validation = validation + 1
##	for p in array_of_players:
##		if p != null:
##			p.Is_Game_running(true)
##	STOP_PLAYERS(true)
#
#
#func set_board_node(name):
#	game_board_node = name
#
#func _on_Change_player_pressed():
#	i = i + 1
#	if (i >= array_of_players.size()):
#		i = 0
#	for p in array_of_players:
#		if p != null:
#			p.can_player_move(i)
#
#func Change_player():
#	MusicPlayer.onChangePlayer()
#	var curr = 0
#	for p in array_of_players:
#		if p.get_is_player_movable():
#			if curr == array_of_players.size() - 1:
#				update_player_vals(array_of_players[0])
#			else:
#				update_player_vals(array_of_players[curr+1])
#			return
#		curr += 1
##	i = i + 1
##	if (i >= array_of_players.size()):
##		i = 0
##	for p in array_of_players:
##		if p != null:
##			p.can_player_move(i)
##			p.player_turn()
#
#func pause_game(): 
#	running = false
#	for p in array_of_players:
#		p.set_is_player_movable(false)
#	timer.stop()
#
#func play_game():
#	running = true
#	for p in array_of_players:
#		if p != null:
#			p.Is_Game_running(running)
#	timer.start()
#
#func _on_Split_player_pressed():
#	pass
#	#player_split()
#
#
#func _on_Timer_timeout():
#	sub_score()
#
#
#func _on_Player_multi_pressed():
#	for p in array_of_players:
#		if p != null:
#			var temp = p.get_multi()
#			p.set_multi(!temp)
#
#func disable_player(index):
#	if index < array_of_players.size()-1 && array_of_players[index] != null:
#		array_of_players[index].Is_Game_running(false)
#	else:
#		#print("Player at index " + str(index) + "is NULL")
#		return
#func enable_player(index):
#	if index < array_of_players.size()-1 && array_of_players[index] != null:
#		array_of_players[index].Is_Game_running(true)
#	else:
#		return
#
## a conciser function on only enabling players in play and disabling the others 		
#func in_play(index):
#	var count = 0
#	if index < array_of_players.size()-1 && array_of_players[index] != null:
#		for p in array_of_players:
#			if count != index:
#				p.set_is_player_movable(false)
#			else:
#				p.set_is_player_movable(true)
#			count = count + 1









## /***   THIS IS ANGELO'S VERSION   [468]   ***/
#extends Node2D
#onready var Player_og = load("res://Scenes/Player.tscn")
#onready var Collectabel_og = load("res://Scenes/Collectable.tscn")
#onready var swipe = get_parent().get_node("SwipeDetector")
#onready var timer = get_node("../Label/Timer")
#onready var game_score = get_node("../Label") 
#var game_board_node
#var running = true 
#var score = 100000
#var array_of_players = []
#var array_of_collectables = []
#var array_of_objects = []
#var width = 10
#var height = 10
#var i = 0
#var z = 0
#var grid_size = 64
#var playerScale
#var isCollectableMove = false
#
## this can be cleared after merging, but the timer needs to be kept
#func _ready():
#	create_object_array()
#
#func isPlayerArrayEmpty():
#	return array_of_players.size() == 0
#
#func setPlayerScale(var val):
#	playerScale = val
#
#func set_grid_size(grid):
#	grid_size = grid
#
#func get_grid_size():
#	return grid_size
#
#func start_timer():
#	timer.start()
#func create_object_array():
#	for x in range(width):
#		array_of_objects.append([])
#		for y in range(height):
#			array_of_objects[x].append(0)
#
## MADE BY EMILIO FOR STACK ALG.
#func placeAtIndexInArray(var index, var obj):
#	var player = obj
#	array_of_players.insert(index,player)
#	var z = 0
#	for p in array_of_players:
#		if p != null:
#			p.set_player_move(z)
#			p.player_turn()
#			z = z + 1
#	var tempx = player.get_player_grid_x()
#	var tempy = player.get_player_grid_y()
#	array_of_objects[tempy][tempx] = 1
#func setCollectable(var val):
#	isCollectableMove = val
#func getPlayerByObj(var obj):
#	var z = 0;
#	for p in array_of_players:
#		if p != null:
#			if(obj == p):
#				return z
#		z = z + 1
#func printPlayers():
#	var z = 0;
#	for p in array_of_players:
#		if p != null:
#			printraw(p.Move_Left, ", ")
#		z = z + 1
#	print("\n")
#
#
#
#func get_cur_player_id():
#	for aIndex in range(array_of_players.size()):
#		if array_of_players[aIndex] != null:
#			if array_of_players[aIndex].get_player_move() == array_of_players[aIndex].get_can_player_move():
#				return aIndex
#
#func update_object_array(x_new, y_new, x_prev, y_prev, is_from_external_edit):
#	if(!is_from_external_edit):# && game_board_node.peekUndoStackAction() != "DELETE"):
#		var currNum
#
#		if (i < 0):
#			if array_of_players.size() == 0:
#				game_board_node.win_condition()
#			elif array_of_players[0]!= null:
#				 i = array_of_players[0].get_can_player_move()
#		if(array_of_players.size() > i && i >= 0):
#
#			currNum = array_of_players[i].get_player_moves_left()
#		else:
#			currNum = -1;
#		var currID = get_cur_player_id()
#		game_board_node.call("addToUndoStack", currID, currID, x_prev, y_prev, x_new, y_new, currNum + 1, currNum,isCollectableMove, "MOVE")
##		if currNum != null:
##			game_board_node.call("addToUndoStack", currID, currID, x_prev, y_prev, x_new, y_new, currNum + 1, currNum,"MOVE")
#	array_of_objects[y_prev][x_prev] = 0
#	array_of_objects[y_new][x_new] = 1
#func add_player_to_object_array(x,y):
#	if array_of_players.size() != 0:
#		array_of_objects[y][x] = 1
#func remove_player_from_array(x,y):
#	if  array_of_players.size() != 0:
#		array_of_objects[y][x] = 0
#		MusicPlayer.onDeletePlayer()
#
## function for making players, takes a var and adds that to the active player array
## parameters ; player: original player, num_x: the x position, num_y: the y position 
#func make_players(player, num_x, num_y, move_val,grid_x, grid_y, make_while_running, node):
#	var temp_x = 0
#	var temp_y = 0
#	player = Player_og.instance()
#	add_child(player)
#	player.set_main_game_node(node)
#	# first one is for generating a player on start, the second is for everything else
#	if make_while_running == true:
#		player.set_pos( num_x ,  num_y )
#		player.set_player_grid(grid_x, grid_y, false);
#	else:
#		player.set_pos( num_x ,  num_y )
#	array_of_players.append(player)
#	swipe.connect_node(player)
#	if move_val > 0:
#		player.set_moves_left(move_val)
#	z = 0
#	for p in array_of_players:
#		if p != null:
#			p.set_player_move(z)
#			z = z + 1
#	add_to_player_array(player)
#	add_player_to_object_array(grid_x, grid_y)
#
#func make_rand_val(val_max, val_min):
#	var num = 0
#	num = randi() % val_max - val_min
#	return num
## pass the player/collectable index you want to get 
#func get_player_at_index(index):
#	if index < array_of_players.size() && array_of_players.size() != 0:
#		return array_of_players[index]
#	else:
#		return null
#
#func get_collect_at_index(index):
#	return array_of_collectables[index]
#
#func get_cur_player():
#	for p in array_of_players:
#		if p != null:
#			if p.get_player_move() == p.get_can_player_move():
#				return p
## *MY FUNCTIONS *
#func get_collectible_array_size():
#	return array_of_collectables.size()
#func get_player_array_size():
#	if array_of_players.size() != 0:
#		return array_of_players.size()
#	else:
#		return 0
#
## creates a new collectable and adds it as a child
## parameters ; collectable: original collectable, num_x: the x position, num_y: the y position  
## shuold not be used after game starts
#func make_collectables(collectable, num_x, num_y):
#	var temp_x = 0
#	var temp_y = 0
#	collectable = Collectabel_og.instance()
#	temp_x = collectable.get_pos_x()
#	temp_y = collectable.get_pos_y()
#	add_child(collectable)
#	collectable.set_pos(temp_x + (grid_size * num_x ), temp_y + (grid_size * num_y ))
#	array_of_collectables.append(collectable)
#	var temp_num = 0
#	for c in array_of_collectables:
#		c.set_collect_num(temp_num)
#		temp_num = temp_num + 1
#
#func sub_score():
#	score = score - 5
#	game_score.text = str(score)
#
#func remove_collectable(num):
#	var check = 0
#	for c in array_of_collectables:
#		var temp = c.get_collect_num()
#		if (temp == num):
#			array_of_collectables.remove(check)
#			c.queue_free()
#			array_of_players[0].send_collect_remove_sig()
#		check += 1
#
#func STOP_PLAYERS(state):
#	for p in array_of_players:
#		if p.get_player_move() != p.get_can_player_move():
#			p.Is_Game_running(state)
#
## both these functions are for adding objects to the arrays in this class to manage the 
## objects and remove them when they are nolonger needed or used 
#func add_to_player_array(obj):
#	var player = obj
#	array_of_players.append(player)
#	var z = 0
#	for p in array_of_players:
#		if p != null:
#			p.set_player_move(z)
#			p.player_turn()
#			z = z + 1
#	var tempx = player.get_player_grid_x()
#	var tempy = player.get_player_grid_y()
#	array_of_objects[tempy][tempx] = 1
#
#
#func add_to_collect_array(obj):
#	var collect = obj
#	array_of_collectables.append(collect)
#	var temp_num = 0
#	for c in array_of_collectables:
#		c.set_collect_num(temp_num)
#		temp_num = temp_num + 1
#
#func state_of_player_array():
#	if array_of_players.size() <= 1:
#		timer.stop()
#		return true
#	else:
#		return false
## creates a new player when the split command is issued 
#func player_split():
#	MusicPlayer.onSplit()
#	if i < array_of_players.size() && i >= 0:
#		var temp_x = 0
#		var temp_y = 0
#		var check = 0
#		var gridx = 0
#		var gridy = 0
#		var player = null
#		var board_node = null
#		var testing = 0
#		var map_num = 0
#		var tile_size = 0
#		var map_size = 0
#		player = Player_og.instance()
#		temp_x = array_of_players[i].get_pos_x()
#		temp_y = array_of_players[i].get_pos_y()
#		check = array_of_players[i].get_player_moves_left()
#		gridx = array_of_players[i].get_player_grid_x() 
#		gridy = array_of_players[i].get_player_grid_y() 
#		map_size = array_of_players[i].get_map_size()
#		var x_prev = gridx
#		var y_prev = gridy
#		var num_prev = check
#		board_node = array_of_players[i].get_main_game_node()
#		map_num = array_of_players[i].get_map_num()
#		tile_size = array_of_players[i].get_tile_size()
#		grid_size = tile_size
#		if array_of_players[i].get_player_moves_left() % 2 == 0:
#			check = check / 2
#			if gridx + 1 < 9 && array_of_players[i].check_adjacent_tiles( gridx + 1, gridy) && (array_of_objects[gridy][ gridx + 1] == 0):
#				temp_x = temp_x + grid_size
#				gridx = gridx + 1
#			elif gridy - 1 >= 0 && array_of_players[i].check_adjacent_tiles(gridx, gridy - 1) && (array_of_objects[gridy - 1][ gridx] == 0):
#				temp_y = temp_y - grid_size
#				gridy = gridy - 1
#			elif gridx - 1 >= 0 && array_of_players[i].check_adjacent_tiles( gridx - 1, gridy) &&  (array_of_objects[gridy][ gridx - 1] == 0):
#				temp_x = temp_x - grid_size
#				gridx = gridx - 1
#			elif gridy + 1 < 9 && array_of_players[i].check_adjacent_tiles(gridx ,gridy + 1) &&  (array_of_objects[gridy + 1][ gridx] == 0):
#				temp_y = temp_y + grid_size
#				gridy = gridy + 1
#			if temp_x != array_of_players[i].get_pos_x() || temp_y != array_of_players[i].get_pos_y():
#				player = Player_og.instance()
#				player.scale = playerScale
#				player.set_pos( temp_x ,  temp_y )
#				add_child(player)
#				player.set_player_grid(gridx, gridy, false);
#				player.set_main_game_node(board_node)
#				player.set_tile_size(tile_size)
#				swipe.connect_node(player)
#				player.set_moves_left(check)
#				player.set_map_num(map_num)
#				player.set_map_size(map_size)
#				z = 0
#				for p in array_of_players:
#					if p != null:
#						p.set_player_move(z)
#						z = z + 1
#				var currPlayerID = get_cur_player_id()
#				placeAtIndexInArray(currPlayerID + 1,player)
#				add_player_to_object_array(gridx, gridy)
#				game_board_node.call("addToUndoStack", currPlayerID, currPlayerID + 1, x_prev, y_prev, gridx, gridy, num_prev, num_prev,isCollectableMove, "SPLIT")
#				array_of_players[i].set_moves_left(check)
#
#
#func checkForGameOver():
#	var gridx = 0
#	var gridy = 0
#	var non_null_players = 0
#	var possable_moves = 0
#	for p in array_of_players:
#		if p != null:
#			non_null_players = non_null_players + 1
#			gridx = p.get_player_grid_x() 
#			gridy = p.get_player_grid_y() 
#			if gridx + 1 < 9 && p.check_adjacent_tiles( gridx + 1, gridy) || (array_of_objects[gridy][ gridx + 1] != 0):
#				possable_moves = possable_moves + 1
#			if gridy - 1 >= 0 && p.check_adjacent_tiles(gridx, gridy - 1) || (array_of_objects[gridy - 1][ gridx] != 0):
#				possable_moves = possable_moves + 1
#			if gridx - 1 >= 0 && p.check_adjacent_tiles( gridx - 1, gridy) ||  (array_of_objects[gridy][ gridx - 1] != 0):
#				possable_moves = possable_moves + 1
#			if gridy + 1 < 9 && p.check_adjacent_tiles(gridx ,gridy + 1) ||  (array_of_objects[gridy + 1][ gridx] != 0):
#				possable_moves = possable_moves + 1
#			if p.get_player_moves_left() % 2 == 0:
#				if gridy + 1 < 9 && p.check_adjacent_tiles(gridx + 1 ,gridy + 1) ||  (array_of_objects[gridy + 1][ gridx + 1] != 0):
#					possable_moves = possable_moves + 1
#				if gridy + 1 < 9 && p.check_adjacent_tiles(gridx - 1 ,gridy + 1) ||  (array_of_objects[gridy + 1][ gridx - 1] != 0):
#					possable_moves = possable_moves + 1
#				if gridy + 1 < 9 && p.check_adjacent_tiles(gridx + 1 ,gridy - 1) ||  (array_of_objects[gridy - 1][ gridx + 1] != 0):
#					possable_moves = possable_moves + 1
#				if gridy + 1 < 9 && p.check_adjacent_tiles(gridx - 1 ,gridy - 1) ||  (array_of_objects[gridy - 1][ gridx - 1] != 0):
#					possable_moves = possable_moves + 1
#	if possable_moves == 0 && non_null_players != 0:
#		game_board_node.game_over()  
#
#func playerSwap(state):
#	for p in array_of_players:
#		p.set_canSwap(state)
#
#func change_to_this_player(playerNum):
#	MusicPlayer.onChangePlayer()
#	for p in array_of_players:
#		p.Is_Game_running(false)
#	i = playerNum
#	for p in array_of_players:
#		if p != null:
#			p.can_player_move(playerNum)
#			p.player_turn()
#	for p in array_of_players:
#		p.Is_Game_running(true)
#
#func update_player_vals():
#	var check = 0
#	if array_of_players.size() != 0:
#		for num in array_of_players:
#			if num != null:
#				if check >= array_of_players.size():
#					break
#				var temp = num.get_player_moves_left()
#				if (temp == 0):
#					array_of_players.remove(check)
#					num.queue_free()
#					var tempMove = 0
#					i = i - 1
#					for p in array_of_players:
#						if p != null:
#							p.set_player_move(tempMove)
#							tempMove = tempMove + 1
#							i = 0
#					for p in array_of_players:
#						if p != null:
#							p.can_player_move(i)
#					for p in array_of_players:
#						if p != null:
#							p.Is_Game_running(false)
#					if array_of_players.size() > 1:
#						if array_of_players[0] != null:
#							array_of_players[0].send_player_remove_sig()
#				check += 1
#		var c = 0
#		for p in array_of_players:
#			if p != null:
#				if (array_of_players.size() > 1):
#					if p != null:
#						p.set_player_move(c)
#						c = c + 1
#				else:
#					if p != null:
#						p.set_player_move(0)
#			if p != null:
#				p.player_turn()
#		var validation = 0
#		for p in array_of_players:
#			if p != null:
#				validation = validation + 1
#	var validation = 0
#	for p in array_of_players:
#		if p != null:
#			validation = validation + 1
#	for p in array_of_players:
#		if p != null:
#			p.Is_Game_running(true)
#	STOP_PLAYERS(true)
#
#
#func set_board_node(name):
#	game_board_node = name
#
#func _on_Change_player_pressed():
#	i = i + 1
#	if (i >= array_of_players.size()):
#		i = 0
#	for p in array_of_players:
#		if p != null:
#			p.can_player_move(i)
#
#func Change_player():
#	MusicPlayer.onChangePlayer()
#	i = i + 1
#	if (i >= array_of_players.size()):
#		i = 0
#	for p in array_of_players:
#		if p != null:
#			p.can_player_move(i)
#			p.player_turn()
#
#func pause_game(): 
#	running = false
#	for p in array_of_players:
#		if p != null:
#			p.Is_Game_running(running)
#	timer.stop()
#
#func play_game():
#	running = true
#	for p in array_of_players:
#		if p != null:
#			p.Is_Game_running(running)
#	timer.start()
#
#func _on_Split_player_pressed():
#	player_split()
#
#
#func _on_Timer_timeout():
#	sub_score()
#
#
#func _on_Player_multi_pressed():
#	for p in array_of_players:
#		if p != null:
#			var temp = p.get_multi()
#			p.set_multi(!temp)
#
#func disable_player(index):
#	if index < array_of_players.size()-1 && array_of_players[index] != null:
#		array_of_players[index].Is_Game_running(false)
#	else:
#		#print("Player at index " + str(index) + "is NULL")
#		return
#func enable_player(index):
#	if index < array_of_players.size()-1 && array_of_players[index] != null:
#		array_of_players[index].Is_Game_running(true)
#	else:
#		return
#
## a conciser function on only enabling players in play and disabling the others 		
#func in_play(index):
#	var count = 0
#	if index < array_of_players.size()-1 && array_of_players[index] != null:
#		for p in array_of_players:
#			if count != index:
#				p.Is_Game_running(false)
#			else:
#				p.Is_Game_running(true)
#			count = count + 1

