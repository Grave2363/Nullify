extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal swipe(direction)
signal swipe_caned(start_pos)
export(float, 1.0,1.5) var MAX_DIAGONAL_SLOPE = 1.3
onready var timer = $Timer2
onready var coolDownDur = $Cooldown
var swipe_start_pos = Vector2()
var min_drag = 25
var can_detect = true
var cooldown = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if !Global.get_is_input_handled():
		if not event is InputEventScreenTouch:
			return
		if event.pressed:
			_start_detect(event.position)
		elif not timer.is_stopped():
			_end_detection(event.position)

func _start_detect(position):
	swipe_start_pos = position
	timer.start()

func connect_node(node):
	connect("swipe", node, "_on_SwipeDetector_swipe")

func _end_detection(position):
	timer.stop()
	var direct = (position - swipe_start_pos)
	if (abs(direct.x) > min_drag || abs(direct.y) > min_drag) && cooldown == false:
		direct = direct.normalized()
		if abs(direct.x) + abs(direct.y) >= MAX_DIAGONAL_SLOPE:
			cooldown = true
			coolDownDur.start()
			emit_signal("swipe", Vector2(-sign(direct.x),-sign(direct.y)))
		elif abs(direct.x) > abs(direct.y):
			cooldown = true
			coolDownDur.start()
			emit_signal("swipe", Vector2(-sign(direct.x), 0))
		else:
			cooldown = true
			coolDownDur.start()
			emit_signal("swipe", Vector2(0, -sign(direct.y)))
func _on_Timer_timeout():
	emit_signal("swipe_caned", swipe_start_pos)


func _on_Cooldown_timeout():
	cooldown = false
	coolDownDur.stop()
