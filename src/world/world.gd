extends Node2D


func _ready() -> void:
	get_tree().paused = true
	await Server.multiplayer.connected_to_server
	Server.player_loaded.rpc(Server.player_info)
