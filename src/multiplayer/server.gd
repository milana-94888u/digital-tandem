extends Node


const DEFAULT_PORT := 4444
const DEFAULT_IP := "localhost"


@export var server_port := DEFAULT_PORT
@export var server_ip := DEFAULT_IP


var players_count := 0
var mech_authority := 0
var virus_authority := 0


enum PlayerRole {
	UNSET = 0,
	MECH = 1,
	VIRUS = 2,
}


var game_end := false


var player_info := {"nickname": "", "role": PlayerRole.UNSET}


func join_game(address := server_ip, port := server_port):
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
	OS.set_restart_on_exit(true, OS.get_cmdline_args())
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(DEFAULT_PORT, 2) # 2 for 2 max players
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_disconnected.connect(
		func(peer: int):
			print("disconnected %d" % peer)
			multiplayer.multiplayer_peer.close()
			get_tree().quit()
	)










