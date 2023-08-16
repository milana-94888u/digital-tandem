extends Node


const DEFAULT_PORT := 4444
const DEFAULT_IP := "localhost"


var players_count := 0
var mech_authority := 0
var virus_authority := 0


enum PlayerRole {
	UNSET = 0,
	MECH = 1,
	VIRUS = 2,
}


var player_info := {"nickname": "", "role": PlayerRole.UNSET}


func join_game(address := DEFAULT_IP, port := DEFAULT_PORT):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	multiplayer.server_disconnected.connect(
		func():
			print("-server")
			get_tree().change_scene_to_file("res://src/ui/menu.tscn")
	)


func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(DEFAULT_PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_disconnected.connect(
		func(peer: int):
			print("disconnected %d" % peer)
			multiplayer.multiplayer_peer.close()
			get_tree().change_scene_to_file("res://src/ui/menu.tscn")
	)










