extends Node2D


func _ready() -> void:
	await Server.multiplayer.connected_to_server
	Server.player_loaded.rpc_id(1, Server.player_info)
