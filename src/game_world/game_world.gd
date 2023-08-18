extends Node2D


var virus_active_object: Node2D


func _ready() -> void:
	pass
#	$MechWrapper/Mech/Camera2D.enabled = true


func _on_mech_chat_requested() -> void:
	$ChatCanvas/GameChat.show_chat()
	$MechWrapper/Mech.control_processed = false


func _on_virus_chat_requested() -> void:
	$ChatCanvas/GameChat.show_chat()
	$VirusWrapper/Virus.control_processed = false


func _on_game_chat_chat_closed() -> void:
	$MechWrapper/Mech.control_processed = true
	$VirusWrapper/Virus.control_processed = true


func _on_door_object_chosen(object: Node2D) -> void:
	$VirusWrapper/Virus.control_processed = false
	$VirusWrapper/Virus.start_minigame(preload("res://src/minigames/captcha/captcha_minigame.tscn").instantiate())
	virus_active_object = object


func _on_virus_minigame_canceled() -> void:
	$VirusWrapper/Virus.control_processed = true
	virus_active_object = null


func _on_virus_minigame_completed() -> void:
	$VirusWrapper/Virus.control_processed = true
	virus_active_object.open_door.rpc()
