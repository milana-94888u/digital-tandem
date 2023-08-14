extends Control


var labels := {}


func _ready() -> void:
	Lobby.player_connected.connect(add_player)
	Lobby.player_disconnected.connect(remove_player)


func _on_create_server_button_pressed() -> void:
	Lobby.player_info["name"] = $ConnectMenu/NameEdit.text
	Lobby.create_game()
	Lobby.player_loaded.rpc_id(1)


func _on_connect_button_pressed() -> void:
	Lobby.player_info["name"] = $ConnectMenu/NameEdit.text
	Lobby.join_game()
#	Lobby.player_loaded.rpc_id(1)


func add_player(id: int, info: Dictionary) -> void:
	var label := Label.new()
	label.text = info["name"]
	labels[id] = label
	$PlayersList.add_child(label)


func remove_player(id: int) -> void:
	$PlayersList.remove_child(labels[id])
