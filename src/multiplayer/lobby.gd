extends Node


signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected
signal existing_nickname_used


const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 20


enum PlayerRole {
	MECHA = 0,
	VIRUS = 1,
	UNSET = 2,
}


var players := {}

var player_info := {"nickname": "", "role": PlayerRole.UNSET}


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func join_game(address := ""):
	if address == "":
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer


func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	players[1] = player_info
	player_connected.emit(1, player_info)


@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		print("new player!")


@rpc("any_peer", "call_local", "reliable")
func used_existing_nickname() -> void:
	existing_nickname_used.emit()


func check_unique_nickname(nickname: String) -> bool:
	var result := true
	for player in players.values():
		result = result and (player["nickname"] != nickname)
	return result


func _on_player_connected(id: int) -> void:
	_register_player.rpc_id(id, player_info)


@rpc("any_peer", "reliable")
func _register_player(new_player_info: Dictionary) -> void:
	var new_player_id := multiplayer.get_remote_sender_id()
	if not check_unique_nickname(new_player_info["nickname"]):
		used_existing_nickname.rpc_id(new_player_id)
		multiplayer.multiplayer_peer.disconnect_peer(new_player_id, true)
		return
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	

func _on_player_disconnected(id: int) -> void:
	players.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok() -> void:
	var peer_id := multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)


func _on_connected_fail() -> void:
	print("failed_connect")
	multiplayer.multiplayer_peer = null


func _on_server_disconnected() -> void:
	multiplayer.multiplayer_peer = null
	server_disconnected.emit()

















