extends Control

const ScoreItem = preload("res://Scenes/Firebase/ScoreObject.tscn")
const SWLogger = preload("res://addons/silent_wolf/utils/SWLogger.gd")
var scores = []
var list_index = 0
var ld_name = "5x5"
func _ready():
	print("SilentWolf.Scores.leaderboards: " + str(SilentWolf.Scores.leaderboards))
	print("SilentWolf.Scores.ldboard_config: " + str(SilentWolf.Scores.ldboard_config))
	ld_name = Global.get_leaderboard_level()
	print(ld_name)
	#var scores = SilentWolf.Scores.scores
	var scores = []
	if ld_name in SilentWolf.Scores.leaderboards:
		scores = SilentWolf.Scores.leaderboards[ld_name]
	var local_scores = SilentWolf.Scores.local_scores
	
	if len(scores) > 0: 
		render_board(scores, local_scores)
	else:
		# use a signal to notify when the high scores have been returned, and show a "loading" animation until it's the case...
		#add_loading_scores_message()
		yield(SilentWolf.Scores.get_high_scores(0 ,ld_name), "sw_scores_received")
		print(str(SilentWolf.Scores.leaderboards[ld_name]))
		render_board(SilentWolf.Scores.scores, local_scores)

func render_board(scores, local_scores):
	var all_scores = scores
	if ld_name in SilentWolf.Scores.ldboard_config and is_default_leaderboard(SilentWolf.Scores.ldboard_config[ld_name]):
		all_scores = merge_scores_with_local_scores(scores, local_scores)
		if !scores and !local_scores:
			pass # place msg about no scores
	else:
		if !scores:
			pass # place msg about no scores
	for score in scores:
		add_item(score.player_name, str(int(score.score)))

func add_item(player_name, score):
	var item = ScoreItem.instance()
	list_index += 1
	item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("Score").text = score
	item.margin_top = list_index * 100
	$UI/ScrollContainer/ScoreContainer.add_child(item)

func merge_scores_with_local_scores(scores, local_scores, max_scores=10):
	if local_scores:
		for score in local_scores:
			var in_array = score_in_score_array(scores, score)
			if !in_array:
				scores.append(score)
			scores.sort_custom(self, "sort_by_score");
	var return_scores = scores
	if scores.size() > max_scores:
		return_scores = scores.resize(max_scores)
	return return_scores

func is_default_leaderboard(ld_config):
	var default_insert_opt = (ld_config.insert_opt == "keep")
	var not_time_based = !("time_based" in ld_config)
	return  default_insert_opt and not_time_based

func score_in_score_array(scores, new_score):
	var in_score_array =  false
	if new_score and scores:
		for score in scores:
			if score.score_id == new_score.score_id: 
				in_score_array = true
	return in_score_array

func sort_by_score(a, b):
	if a.score > b.score:
		return true;
	else:
		if a.score < b.score:
			return false;
		else:
			return true;


func _on_BackButton_pressed():
	MusicPlayer.onBackButton()
	ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard_Selection.tscn", "Fade")

func _notification(what):
# this is primarily for Windows quit, but it doesnt seem like an issue	
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
#		pass
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		MusicPlayer.onBackButton()
		ChangeScenes.change_scene("res://Scenes/Firebase/LeaderBoard_Selection.tscn", "Fade")

func _on_Settings_pressed():
	MusicPlayer.onConfirm()
