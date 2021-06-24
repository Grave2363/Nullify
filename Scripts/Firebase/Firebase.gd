extends Node

const API_KEY = "AIzaSyBUgMFy969D1wPQF_dLBzZZIFnqtcSKDqI" # key for api interaction, remove if this repo is ever made public 
const Project_ID = "nullify-46cff"
const Regester_Url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + API_KEY
const Login_Url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key="  +API_KEY
const Pass_Reset = "https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=" + API_KEY
const Anon_regester = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + API_KEY
const FireStore_Url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % Project_ID
var User_info = {}

func _get_user_info(result: Array) -> Dictionary:
	var result_body = JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return {
		"token": result_body.idToken,
		"id": result_body.localId
	}

func _get_request_header() -> PoolStringArray:
	return PoolStringArray([
		"Content-Type: application/json",
		"Authorization : Bearer %s" % User_info.token
	])

func register(email: String, password: String, http: HTTPRequest)-> void:
	var body:= {
		"email": email,
		"password": password
	}
	http.request(Regester_Url, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		User_info = _get_user_info(result)

func save_doc(path: String, fields: Dictionary, http: HTTPRequest):
	var doc = {"fields": fields}
	var body = to_json(doc)
	var url = FireStore_Url + path
	http.request(url, _get_request_header(), false, HTTPClient.METHOD_POST, body)

func get_doc(path : String, http: HTTPRequest):
	var url = FireStore_Url + path
	http.request(url, _get_request_header(), false, HTTPClient.METHOD_GET)

func update_doc(path: String, fields: Dictionary, http: HTTPRequest):
	var doc = {"fields": fields}
	var body = to_json(doc)
	var url = FireStore_Url + path
	http.request(url, _get_request_header(), false, HTTPClient.METHOD_PATCH, body)

func delete_doc(path:String, http:HTTPRequest):
	var url = FireStore_Url + path
	http.request(url, _get_request_header(), false, HTTPClient.METHOD_DELETE)

func login(email: String, password: String, http: HTTPRequest)-> void:
	var body:= {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
	http.request(Login_Url, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		User_info = _get_user_info(result)
