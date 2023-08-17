extends Node2D


func _ready() -> void:
	pass
	$MechWrapper/Mech/Camera2D.enabled = true


func _on_mech_chat_requested() -> void:
	$ChatCanvas/GameChat.show_chat()
	$MechWrapper/Mech.control_processed = false


func _on_virus_chat_requested() -> void:
	$ChatCanvas/GameChat.show_chat()
	$VirusWrapper/Virus.control_processed = false


func _on_game_chat_chat_closed() -> void:
	$MechWrapper/Mech.control_processed = true
	$VirusWrapper/Virus.control_processed = true
