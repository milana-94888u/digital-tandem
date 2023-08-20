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


func _on_mech_upgrade_upgrade_picked(upgrade: MechUpgrade) -> void:
	MechUpgradeManager.apply_upgrade(upgrade.upgrade_type)
	mech.apply_upgrade(upgrade.upgrade_type)
	match upgrade.upgrade_type:
		MechUpgrade.UpgradeType.JUMP_UNLOCK:
			game_chat.send_message("The mech unlocked jump")
		MechUpgrade.UpgradeType.RUN_UNLOCK:
			game_chat.send_message("The mech unlocked run")
		MechUpgrade.UpgradeType.HEALTH_UP:
			game_chat.send_message("The mech health increased")
		MechUpgrade.UpgradeType.ENERGY_UP:
			game_chat.send_message("The mech energy increased")
	$GameObjects/MechUpgrades.call_deferred("remove_child", upgrade)

@rpc("any_peer", "call_local", "reliable")
func restart_level() -> void:
	$MechWrapper/Mech/AnimatedSprite2D.play("die")
	_on_virus_teleport_to_mech_requested()
	mech.control_processed = false
	virus.control_processed = false
	game_chat.send_message("The mech died")
	game_chat.show_chat()
	await $MechWrapper/Mech/AnimatedSprite2D.animation_finished
	get_tree().reload_current_scene()


func _on_mech_mech_dead() -> void:
	restart_level.rpc()

