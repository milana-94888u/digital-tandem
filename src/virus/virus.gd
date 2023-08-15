extends Camera2D


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	if Server.player_info["role"] == Server.PlayerRole.VIRUS:
		enabled = true
	else:
		enabled = false


func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		position += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 10
