extends KinematicBody2D

var lock_counter = 0

onready var collision_box = $CollisionShape2D
onready var sprite = $Sprite
onready var area = $Area2D
# Called when the node enters the scene tree for the first time.
func _ready():
	collision_box.disabled = true
	lock_counter = 0

func area_check(move_val):
	pass

func get_lock():
	return lock_counter

func set_area_lock(num):
	lock_counter = num

func lock_tile(move_val):
	lock_counter = lock_counter + 1
	if lock_counter > 2:
		lock_counter = 2
	if lock_counter == 1:
		# the texture strings should be changes out for what is going to be used 
		sprite.texture =  load("res://Sprites/locking_tile.png")
	if lock_counter == 2:
		$CollisionShape2D.set_deferred("disabled", false)
		sprite.texture =  load("res://Sprites/Locked_tile.png")
	if move_val == 16:
		if lock_counter == 2:
			lock_counter = 0
			$CollisionShape2D.set_deferred("disabled", true)
			sprite.texture =  load("res://Sprites/Open_tile.png")

func _on_Area2D_area_exited(area):
	pass #
