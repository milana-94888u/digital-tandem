extends Control


var nickname_to_button_mapping := {}
var initial_close_error_occured := false


func switch_to_login_screen() -> void:
	$LoginScreen.show()
	$LoginScreen/IncorrectNicknameLabel.hide()
	$WainitgScreen.hide()


func switch_to_waiting_screen() -> void:
	$LoginScreen.hide()
	$WainitgScreen.show()


func show_error_message(message: String, time := 2.0) -> void:
	$LoginScreen/IncorrectNicknameLabel.text = message
	$LoginScreen/IncorrectNicknameLabel.show()
	get_tree().create_timer(time).timeout.connect(func(): $LoginScreen/IncorrectNicknameLabel.hide())


func get_valid_nickname() -> String:
	var nickname: String = $LoginScreen/VBoxContainer/NicknameEdit.text
	var regex := RegEx.create_from_string("\\w+")
	var regex_match := regex.search(nickname)
	if regex_match:
		if regex_match.get_string() == nickname:
			return nickname
	return ""


func get_string_role() -> String:
	match $LoginScreen/VBoxContainer/RoleOptionButton.selected:
		Server.PlayerRole.MECH:
			return "mech"
		Server.PlayerRole.VIRUS:
			return "virus"
	return "unset"


func _on_join_button_pressed() -> void:
	var nickname := get_valid_nickname()
	if nickname == "":
		show_error_message("Invalid nickname!")
		return
	Server.player_info["nickname"] = nickname
	Server.player_info["role"] = $LoginScreen/VBoxContainer/RoleOptionButton.selected
	$WebSocket.route = "/ws/%s/%s" % [nickname, get_string_role()]
	$WebSocket.connect_socket()


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


func add_player(player: Dictionary) -> void:
	var button := Button.new()
	button.text = player["nickname"]
	button.pressed.connect(choose_player.bind(button.text))
	nickname_to_button_mapping[player["nickname"]] = button
	$WainitgScreen/PlayersList.add_child(button)


func remove_player(player: Dictionary) -> void:
	var button: Button = nickname_to_button_mapping[player["nickname"]]
	nickname_to_button_mapping.erase(player["nickname"])
	$WainitgScreen/PlayersList.remove_child(button)


func choose_player(nickname: String) -> void:
	var button: Button = nickname_to_button_mapping[nickname]
	button.disabled = true


func process_message(message: Dictionary) -> void:
	match message["action"]:
		"joined":
			add_player(message["player"])
		"left":
			remove_player(message["player"])


func _ready() -> void:
	if OS.has_feature("web"):
		$LoginScreen/HostButton.hide()
	if "--server" in OS.get_cmdline_args():
		_on_host_button_pressed()


func _on_host_button_pressed() -> void:
	Server.player_info["role"] = Server.PlayerRole.UNSET
	get_tree().change_scene_to_file("res://src/multiplayer/world_wrapper/world_wrapper.tscn")
	Server.create_game()









