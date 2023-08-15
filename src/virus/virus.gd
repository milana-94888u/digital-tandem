extends Camera2D


const MIN_ZOOM := 0.1
const MAX_ZOOM := 2.0


func _ready() -> void:
	if Server.player_info["role"] == Server.PlayerRole.VIRUS:
		enabled = true
	else:
		enabled = false


func _physics_process(_delta: float) -> void:
	position += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 10
	if Input.is_action_pressed("zoom_in"):
		zoom = Vector2.ONE * minf(MAX_ZOOM, zoom.x + 0.02)
	elif Input.is_action_pressed("zoom_out"):
		zoom = Vector2.ONE * maxf(MIN_ZOOM, zoom.x - 0.02)
