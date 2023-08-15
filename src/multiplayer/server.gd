extends Node


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


func check_launched_server() -> bool:
	for arg in OS.get_cmdline_args():
		if arg == "--server":
			return true
	return false


func join_game(address := ""):
	if address == "":
		address = DEFAULT_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer


func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(DEFAULT_PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer










