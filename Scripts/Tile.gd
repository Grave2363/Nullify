extends Node2D

#STATES
#0 -> FREE
#1 -> IMMINENT
#2 -> LOCKED
var currState = 0
var isAreaOn = true
	
func change_texture():
#	print("CHANGE TEXTUERE -> ", currState)
	if currState == 0:
		MusicPlayer.onTileToUnlock()
		$Area2D/Sprite.texture = load("res://Assets/Sprites/TileFree_01.png")
	elif currState == 1:
		MusicPlayer.onTileToImm()
		$Area2D/Sprite.texture = load("res://Assets/Sprites/TileImm_02.png")
	else:
		MusicPlayer.onTileToLock()
		$Area2D/Sprite.texture = load("res://Assets/Sprites/TileLocked_02.png")

func reset_tile_color():
	#white
	$Area2D/Sprite.modulate = Color("#ffffff")
		


func change_texture_onGen():
	if currState == 0:
		$Area2D/Sprite.texture = load("res://Assets/Sprites/TileFree_01.png")
	elif currState == 1:
		$Area2D/Sprite.texture = load("res://Assets/Sprites/TileImm_02.png")
	else:
		$Area2D/Sprite.texture = load("res://Assets/Sprites/TileLocked_02.png")
		
		

func _on_Area2D_area_exited(area):
#	print(isAreaOn)
	if isAreaOn && Global.get_tile_toggle() && area != null:
		if currState == 0:
			currState = 1
		elif currState == 1:
			currState = 2
		change_texture()

	
func is_tile_locked():
	return currState == 2
	
func is_tile_imm():
	return currState == 1
	
func get_state():
	return currState
	
func set_state(val):
	currState = val
	change_texture()

func set_state_onGen(val):
	currState = val
	change_texture_onGen()
	
func unlock():
	currState = 0
	change_texture()
	
#func setTileAfterMerge():
#	currState = 1
#	change_texture()
#	turn_off_area_exit()
#	turn_on_area_exit()


#func change_tile_color():
#	# yellow green
#	# highlight 1,0.8,1
#	sprite.modulate = Color(0.6, 0.8, 0.2, 1)
#func reset_tile_color():
#	#white
#	sprite.modulate = Color("#ffffff")

func change_tile_color():
	# yellow green
	# highlight 1,0.8,1
	$Area2D/Sprite.modulate = Color(0.6, 0.8, 0.2, 1)



func turn_off_area_exit():
#	$Area2D/CollisionShape2D.set_deferred("disabled",true)
	isAreaOn = false

func turn_on_area_exit():
#	$Area2D/CollisionShape2D.set_deferred("disabled",false)
	isAreaOn = true
#
func turn_on_area_exit_for_stack():
	$Timer.set_wait_time(0.2)
	$Timer.start()

func _on_timeout():
	isAreaOn = true
