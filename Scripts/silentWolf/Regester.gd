extends Control

var thisScene = "res://Scenes/backEnd/Regester.tscn"
var player_name = ""
var email = ""
var password = ""
var confirm_password = ""
onready var msg : Label = $UI/Menu/Error_msg
onready var http_req : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $UI/Menu/VBoxContainer/Username/User_edit
onready var pass1 : LineEdit = $UI/Menu/VBoxContainer/Pass/Pass1
onready var pass2 : LineEdit = $UI/Menu/VBoxContainer/Confirm_pass/Pass2

func _ready():
	SilentWolf.Auth.connect("sw_registration_succeeded", self, "_on_registration_succeeded")
	SilentWolf.Auth.connect("sw_registration_failed", self, "_on_registration_failed")

func _on_registration_succeeded():
	print("Registration succeeded!")

func _on_registration_failed(error):
	print("Error: " + str(error))


func _on_Settings_pressed():
	ChangeScenes.set_prev_scene(thisScene)
	ChangeScenes.change_scene("res://Scenes/UI/UI_Settings.tscn", "Fade")


func _on_Return_pressed():
	ChangeScenes.go_back("Fade")


func _on_Regester_pressed():
	ChangeScenes.change_scene("res://Scenes/backEnd/Sign_in.tscn", "Fade")


func _on_User_edit_text_changed(new_text):
	email = new_text


func _on_Pass1_text_changed(new_text):
	password = new_text


func _on_Pass2_text_changed(new_text):
	confirm_password = new_text


func _on_Submit_pressed():
	Global.set_username(player_name)
	SilentWolf.Auth.register_player(player_name, email, password, confirm_password)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.


func _on_screen_name_text_changed(new_text):
	player_name = new_text
