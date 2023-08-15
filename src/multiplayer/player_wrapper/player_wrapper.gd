extends Node2D
class_name PlayerWrapper


@rpc("authority", "call_local", "reliable")
func change_authority(id: int) -> void:
	set_multiplayer_authority(id)
	if not is_multiplayer_authority():
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
