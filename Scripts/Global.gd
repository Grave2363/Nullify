extends Node

enum gridSize{FIVE, SIX, EIGHT}  # /***   >>NOTE>>   THIS ALWAYS PRINTS OUT 0, 1, 2   ***/
enum diff{EASY, MEDIUM, HARD, CUSTOM}
var grid  = gridSize.FIVE
var difff = diff.EASY
var MaxVal = -1
var player_Num = -1
var immenent_Num = -1
var isTutorial = false
var isCustomPlay = false
var isRoadMap = false
var isLevelReset = false
var isLevelEditor = false
var roadMapLevel = -1
var error_Code = ""
var username = ""
var passw = ""
var textureDistance = 64
var score = 0
var currActivePlayer = 0
var isAddButton = true
var isInputBeingHandled = false
var originalScore = 0
var globalTileToggle = true
var isInputDisabled = false
var leaderboardLevel = ""


const file_name_user = "user://user.dat"
signal pause
signal play

func _ready():
	var file = File.new()
	if file.file_exists(file_name_user):
		var err = file.open(file_name_user, File.READ)
		if err == OK:
			username = file.get_as_text()
			file.close()
	else:
		var err = file.open(file_name_user, File.WRITE)
		if err == OK:
			file.close()
	print(username)

func set_user(name):
	username = name
	var file = File.new()
	var err = file.open(file_name_user, File.READ)
	if err == OK:
		var currLevel = file.get_as_text()
		file.close()
		if currLevel != username:
			var err2 = file.open(file_name_user, File.WRITE)
			if err2 == OK:
				file.store_string(username)
				file.close()
	print(username)

func get_username():
	return username

func set_error_code(text):
	error_Code = text

func get_error_code():
	return error_Code

func emit_pause():
	emit_signal("pause")

func emit_play():
	emit_signal("play")

func connect_Pause_Play(node):
	connect("play", node, "Play")
	connect("pause", node, "Pause")
# Grid Size
func set_grid(val):
	grid = val

func get_grid():
	return 5 + grid + ((grid + 5) / 7)  # /***   >>NOTE>>  <- TO DETERMINE ACTUAL GRIDSIZE   ***/

func set_diff(val):
	difff = val
	
func get_diff():
	return difff

func set_is_input_disabled(val):
	isInputDisabled = val
	
func get_is_input_disabled():
	return isInputDisabled

func set_leaderboard_level(val):
	leaderboardLevel = val
	
func get_leaderboard_level():
	return leaderboardLevel
	
func get_score():
	return score

func set_score(val):
	score = val
	
func set_Original_Score(val):
	originalScore = val
	score = val
	
func get_Original_Score():
	return originalScore
	
func toggle_is_add_button():
	isAddButton = !isAddButton

func get_is_add_button():
	return isAddButton

# Player Value
func set_player_Num(val):
	player_Num = int(val)
	
func get_player_Num():
	return player_Num
	
func set_tile_toggle(val):
	globalTileToggle = val
	
func get_tile_toggle():
	return globalTileToggle

# Max/Free Number
func set_max_val(val):
	MaxVal = val

func get_max_val():
	return MaxVal
	
func set_is_input_handled(val):
	isInputBeingHandled = val

func get_is_input_handled():
	return isInputBeingHandled

# Number of Imminents on Generation
func set_immenent_Num(val):
	immenent_Num = int(val)
	
func get_immenent_Num():
	return immenent_Num

# Custom Play Switch
func set_isCustomPlay(val):
	isCustomPlay = val

func get_isCustom():
	return isCustomPlay
	
func set_isLevelEditor(var val):
	isLevelEditor = val
	
func get_isLevelEditor():
	return isLevelEditor
	
# Tutorial Switch
func set_isTutorial(val):
	isTutorial = val

func get_isTutorial():
	return isTutorial
	
func set_isRoadMap(val):
	isRoadMap = val

func get_isRoadMap():
	return isRoadMap
	
func get_curActivePlayer():
	return currActivePlayer

func set_curActivePlayer(val):
	currActivePlayer = val

#AUTO SAVES THE PLAYERS LEVEL <- EMILIO
func set_roadMapLevel(val):
	roadMapLevel = val
	var file = File.new()
	var err = file.open("user://level.dat", File.READ)
	if err == OK:
		var currLevel = file.get_32()
		file.close()
		if currLevel < val:
			var err2 = file.open("user://level.dat", File.WRITE)
			if err2 == OK:
				file.store_32(val)
				file.close()

func get_roadMapLevel():
	return roadMapLevel
	
func set_isLevelReset(val):
	isLevelReset = val

func get_isLevelReset():
	return isLevelReset
	
func get_textureDistance():
	return textureDistance
	
func set_textureDistance(val):
	textureDistance = val
