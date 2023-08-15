extends Camera2D


const MIN_ZOOM := 0.1
const MAX_ZOOM := 2.0


@rpc("authority", "call_local", "reliable")
func change_authority(id: int) -> void:
	set_multiplayer_authority(id)


func _enter_tree() -> void:
#	set_multiplayer_authority(name.to_int())
	if Server.player_info["role"] == Server.PlayerRole.VIRUS:
		enabled = true
	else:
		enabled = false


func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		position += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 10
		if Input.is_action_pressed("zoom_in"):
			zoom = Vector2.ONE * minf(MAX_ZOOM, zoom.x + 0.02)
		elif Input.is_action_pressed("zoom_out"):
			zoom = Vector2.ONE * maxf(MIN_ZOOM, zoom.x - 0.02)
