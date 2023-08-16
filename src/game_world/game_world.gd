extends Node2D


@rpc("any_peer", "call_local", "reliable")
func send_to_chat(message: String) -> void:
	$ChatCanvas/GameChat.new_message(message)
