extends Control


var nickname_to_button_mapping := {}
var initial_close_error_occured := false


@onready var websocket := $WebSocket as WebSocket

@onready var login_screen := $LoginScreen as Control
@onready var waiting_screen := $WainitgScreen as Control

@onready var nickname_edit := $LoginScreen/VBoxContainer/NicknameEdit as LineEdit
@onready var role_option_button := $LoginScreen/VBoxContainer/RoleOptionButton as OptionButton

@onready var error_message_label := $LoginScreen/ErrorMessageLabel as Label

@onready var players_list := $WainitgScreen/PlayersList as VBoxContainer


func switch_to_login_screen() -> void:
	login_screen.show()
	error_message_label.hide()
	waiting_screen.hide()


func switch_to_waiting_screen() -> void:
	login_screen.hide()
	waiting_screen.show()


func show_error_message(message: String, time := 2.0) -> void:
	error_message_label.text = message
	error_message_label.show()
	get_tree().create_timer(time).timeout.connect(func(): error_message_label.hide())


func get_valid_nickname() -> String:
	var nickname: String = nickname_edit.text
	var regex := RegEx.create_from_string("\\w+")
	var regex_match := regex.search(nickname)
	if regex_match:
		if regex_match.get_string() == nickname:
			return nickname
	return ""


func get_string_role() -> String:
	return Server.PlayerRole.keys()[Server.player_info["role"]].to_lower()


func prepare_player_info() -> String:
	var nickname := get_valid_nickname()
	if nickname == "":
		show_error_message("Invalid nickname!")
		return nickname
	Server.player_info["nickname"] = nickname
	Server.player_info["role"] = role_option_button.selected
	return nickname


func _on_join_button_pressed() -> void:
	var nickname := prepare_player_info()
	if nickname == "":
		return
	websocket.route = "/ws/%s/%s" % [nickname, get_string_role()]
	websocket.connect_socket()


func _on_web_socket_connected(_url: String) -> void:
	switch_to_waiting_screen()


func _on_web_socket_connect_failed() -> void:
	switch_to_login_screen()
	show_error_message("Connection failed")


func _on_web_socket_closed(code: int, reason: String) -> void:
	switch_to_login_screen()
	if reason == "existing_nickname":
		show_error_message("Chosen nickname already exists\nUse another one")
	else:
		if initial_close_error_occured:
			show_error_message("Connection error:\nCode: %d\nReason: %s" % [code, reason])
		else:
			initial_close_error_occured = true


func split_messages(raw: String) -> Array[String]:
	var result: Array[String] = []
	var open_brackets := 0
	for symbol in raw:
		if open_brackets == 0:
			result.append("")
		if symbol == "{":
			open_brackets += 1
		elif symbol == "}":
			open_brackets -= 1
		result[-1] += symbol
	return result


func _on_web_socket_received(data: PackedByteArray) -> void:
	var raw_messages := split_messages(data.get_string_from_ascii())
	for raw_message in raw_messages:
		process_message(JSON.parse_string(raw_message))


# TODO: Add a player themself
func add_self() -> void:
	pass


func add_player(player: Dictionary) -> void:
	if player["nickname"] == Server.player_info["nickname"]:
		add_self()
		return

	var button := Button.new()
	button.text = player["nickname"]
	button.pressed.connect(choose_player.bind(button.text))
	
	match player["role"]:
		"mech":
			if Server.player_info["role"] == Server.PlayerRole.MECH:
				button.disabled = true
		"virus":
			if Server.player_info["role"] == Server.PlayerRole.VIRUS:
				button.disabled = true
	
	nickname_to_button_mapping[player["nickname"]] = button
	players_list.add_child(button)


func remove_player(player: Dictionary) -> void:
	var button: Button = nickname_to_button_mapping[player["nickname"]]
	nickname_to_button_mapping.erase(player["nickname"])
	players_list.remove_child(button)


func choose_player(nickname: String) -> void:
	websocket.send_dict({
		"action": "chose_player",
		"nickname": nickname,
	})


func check_to_connect(player: Dictionary, connection_info: Dictionary) -> void:
	if player["nickname"] != Server.player_info["nickname"]:
		return
	Server.player_info["role"] = Server.PlayerRole.get(player["role"].to_upper())
	var host: String = connection_info["host"]
	var port: int = connection_info["port"]
	
	Server.set_title(get_string_role().capitalize())
	Server.join_game(host, port)
	await Server.multiplayer.connected_to_server
	get_tree().change_scene_to_file("res://src/multiplayer/world_wrapper/world_wrapper.tscn")


func process_message(message: Dictionary) -> void:
	match message["action"]:
		"joined":
			add_player(message["player"])
		"left":
			remove_player(message["player"])
		"room_created":
			check_to_connect(message["player"], message["connection_info"])


func _ready() -> void:
	if OS.has_feature("web"):
		$LoginScreen/LocalGameMenu.hide()
	if "--server" in OS.get_cmdline_args():
		_on_host_button_pressed()


func _on_host_button_pressed() -> void:
	Server.set_title("Server")
	Server.player_info["role"] = Server.PlayerRole.UNSET
	get_tree().change_scene_to_file("res://src/multiplayer/world_wrapper/world_wrapper.tscn")
	Server.create_game()


func _on_join_local_button_pressed() -> void:
	var nickname := prepare_player_info()
	if nickname == "":
		return
	
	Server.set_title(get_string_role().capitalize())
	Server.join_game()
	await Server.multiplayer.connected_to_server
	get_tree().change_scene_to_file("res://src/multiplayer/world_wrapper/world_wrapper.tscn")







