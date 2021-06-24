extends KinematicBody2D
onready var grid = get_node("../") 
onready var sprite = $Sprite
var collect_num = 0
var collect_grid = [0,0]

#onready var sprite = $Sprite


func remove_collectable():
	MusicPlayer.onCollect()
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	position *= 99
	collect_grid[0] = 0
	collect_grid[1] = 0
	Global.set_score(Global.get_score() + 500)
	#grid.remove_collectable(collect_num)
	
func change_collect_tile_color():
	#yellow green
	sprite.modulate = Color(0.6, 0.8, 0.2, 1)
	
func reset_collect_tile_color():
	#white - default
	sprite.modulate = Color("#ffffff")	

func get_collect_grid_x():
	return collect_grid[0]

func get_collect_grid_y():
	return collect_grid[1]

func set_collect_grid(x, y):
	collect_grid[0] = x
	collect_grid[1] = y

func set_collect_num(num):
	collect_num = num

func get_collect_num():
	return collect_num

func get_pos_x():
	return position.x

func get_pos_y():
	return position.y

func set_pos(x, y):
	position.x = x
	position.y = y

func change_tile_color():
	# yellow green
	# highlight 1,0.8,1
	sprite.modulate = Color(0.6, 0.8, 0.2, 1)
func reset_tile_color():
	#white
	sprite.modulate = Color("#ffffff")

func _on_SwipeDetector_swipe(direction):
	pass


func _on_Area2D_area_entered(area):
	pass
