extends Node


signal player_connected(peer_id: int, player_info: Dictionary)
signal player_disconnected(peer_id: int)
signal server_disconnected


const DEFAULT_PORT := 7000
const DEFAULT_IP := "localhost"


var players_count := 0
var mech_authority := 0
var virus_authority := 0


enum PlayerRole {
	MECH = 0,
	VIRUS = 1,
	UNSET = 2,
}


var player_info := {"nickname": "", "role": PlayerRole.UNSET}
var players := {}

var game_scene := preload("res://src/world/world.tscn").instantiate()


func check_launched_server() -> bool:
	for arg in OS.get_cmdline_args():
		if arg == "--server":
			return true
	return false

#
#func _ready() -> void:
#	if check_launched_server():
#		create_game()
#	else:
#		join_game()
#	multiplayer.peer_connected.connect(_on_player_connected)
#	multiplayer.peer_disconnected.connect(_on_player_disconnected)


func join_game(address := ""):
	if address == "":
		address = DEFAULT_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(_connected_ok)


func create_game():
#	print("Server started")
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(DEFAULT_PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_player_connected)
	


func _process(delta: float) -> void:
	if multiplayer.is_server() and len(players) == 2:
		for player_peer in players:
			player_peer


func _on_player_connected(id: int) -> void:
	return
	print(multiplayer.get_unique_id(), " ", player_info)
	_register_player.rpc_id(id, player_info)


func _on_player_disconnected(id: int) -> void:
	players.erase(id)
	player_disconnected.emit(id)


@rpc("any_peer", "reliable")
func _register_player(new_player_info: Dictionary) -> void:
	var new_player_id := multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)


@rpc("any_peer", "call_local", "reliable")
func player_loaded(player_info: Dictionary):
	if multiplayer.is_server():
		var mech := get_tree().current_scene.get_node("Mech")
		var virus := get_tree().current_scene.get_node("Virus")
		if player_info["role"] == PlayerRole.MECH:
			mech_authority = multiplayer.get_remote_sender_id()
		elif player_info["role"] == PlayerRole.VIRUS:
			virus_authority = multiplayer.get_remote_sender_id()
		players_count += 1
		if players_count == 2:
			mech.change_authority.rpc(mech_authority)
			virus.change_authority.rpc(virus_authority)
			resume_game.rpc()


func _connected_ok() -> void:
	print("connected!")
	var peer_id := multiplayer.get_unique_id()
	players[peer_id] = player_info
#	player_connected.emit(peer_id, player_info)


@rpc("authority", "call_local", "reliable")
func resume_game() -> void:
	get_tree().paused = false











