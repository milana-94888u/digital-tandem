extends Node2D
class_name WorldWrapper


var mech_peer := 0
var virus_peer := 0


@rpc("any_peer", "call_local", "reliable")
func pause_game() -> void:
	get_tree().paused = true


@rpc("any_peer", "call_local", "reliable")
func resume_game() -> void:
	get_tree().paused = false


@rpc("any_peer", "call_local", "reliable")
func player_loaded(new_player_info: Dictionary) -> void:
	if not multiplayer.is_server():
		return

	if new_player_info["role"] == Server.PlayerRole.MECH:
		mech_peer = multiplayer.get_remote_sender_id()
	elif new_player_info["role"] == Server.PlayerRole.VIRUS:
		virus_peer = multiplayer.get_remote_sender_id()

	if mech_peer and virus_peer:
		$GameWorld/MechWrapper.change_authority.rpc(mech_peer)
		$GameWorld/VirusWrapper.change_authority.rpc(virus_peer)
		resume_game.rpc()


func _ready() -> void:
	pause_game()
	player_loaded.rpc_id(1, Server.player_info)















