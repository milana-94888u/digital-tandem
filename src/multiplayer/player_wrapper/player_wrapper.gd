extends Node2D
class_name PlayerWrapper


@rpc("authority", "call_local", "reliable")
func change_authority(id: int) -> void:
#	var camera: Camera2D = get_child(0).get_camera()
	set_multiplayer_authority(id)
	if not is_multiplayer_authority():
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
	else:
		set_process(true)
		set_physics_process(true)
		set_process_input(true)
