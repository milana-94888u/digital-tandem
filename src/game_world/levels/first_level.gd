extends Node2D


var virus_active_object: GameObject


@onready var game_chat := $ChatCanvas/GameChat
@onready var mech := $MechWrapper/Mech as Mech
@onready var virus := $VirusWrapper/Virus as Virus


@export var minigame_scene: PackedScene


func _on_mech_chat_requested() -> void:
	game_chat.show_chat()
	mech.control_processed = false


func _on_virus_chat_requested() -> void:
	game_chat.show_chat()
	virus.control_processed = false


func _on_game_chat_chat_closed() -> void:
	mech.control_processed = true
	virus.control_processed = true


func _on_virus_minigame_canceled() -> void:
	virus.control_processed = true
	virus_active_object = null


func _on_virus_minigame_completed() -> void:
	virus.control_processed = true
	virus_active_object.complete_object.rpc()


func _on_virus_teleport_to_mech_requested() -> void:
	virus.position = mech.position


func _on_object_chosen(object: GameObject) -> void:
	virus.control_processed = false
	virus.start_minigame(minigame_scene.instantiate())
	virus_active_object = object


func _on_front_door_virus_door_entered(teleport_position: Vector2) -> void:
	virus.position = teleport_position - Vector2(960, 540)
