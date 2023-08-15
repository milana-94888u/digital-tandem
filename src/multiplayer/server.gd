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


@rpc("any_peer", "call_local", "reliable")
func player_loaded(new_player_info: Dictionary):
	if multiplayer.is_server():
		var mech := get_tree().current_scene.get_node("Mech")
		var virus := get_tree().current_scene.get_node("Virus")
		if new_player_info["role"] == PlayerRole.MECH:
			mech_authority = multiplayer.get_remote_sender_id()
		elif new_player_info["role"] == PlayerRole.VIRUS:
			virus_authority = multiplayer.get_remote_sender_id()
		players_count += 1
		if players_count == 2:
			mech.change_authority.rpc(mech_authority)
			virus.change_authority.rpc(virus_authority)
			resume_game.rpc()


@rpc("authority", "call_local", "reliable")
func resume_game() -> void:
	get_tree().paused = false











