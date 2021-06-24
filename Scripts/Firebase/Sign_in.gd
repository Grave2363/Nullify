extends Control

var thisScene = "res://Scenes/Firebase/Sign_in.tscn"
onready var msg : Label = $UI/Menu/error_msg
onready var http_req : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $UI/Menu/VBoxContainer/Username/User_edit
onready var pass1 : LineEdit = $UI/Menu/VBoxContainer/Pass/Pass_edit

func _ready():
	SilentWolf.Auth.connect("sw_login_succeeded", self, "_on_login_succeeded")
	SilentWolf.Auth.connect("sw_login_failed", self, "_on_login_failed")

func _on_login_succeeded():
	print("Login succeeded!")
	print("logged in as: " + str(SilentWolf.Auth.logged_in_player))

func _on_login_failed(error):
	print("Error: " + str(error))
	msg.text = "Error: " + str(error)

func _on_User_edit_text_changed(new_text):
	pass # Replace with function body.


func _on_Pass_edit_text_changed(new_text):
	pass # Replace with function body.


func _on_Submit_pressed():
	MusicPlayer.onConfirm()
	if username.text.empty() || pass1.text.empty():
		msg.test = "Invalid Username or Password"
		return
	Global.set_user(username.text)
	SilentWolf.Auth.login_player(username.text, pass1.text)

func _on_Regester_pressed():
	MusicPlayer.onConfirm()
	ChangeScenes.change_scene("res://Scenes/Firebase/Regester.tscn", "Fade")



func _on_Return_pressed():
	MusicPlayer.onBackButton()
	ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")

func _notification(what):
# this is primarily for Windows quit, but it doesnt seem like an issue	
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
#		pass
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		MusicPlayer.onBackButton()
		ChangeScenes.change_scene("res://Scenes/UI/UI_HomeScreen.tscn", "Fade")

func _on_Settings_pressed():
	MusicPlayer.onConfirm()
	ChangeScenes.set_prev_scene(thisScene)
	ChangeScenes.change_scene("res://Scenes/UI/UI_Settings.tscn", "Fade")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
