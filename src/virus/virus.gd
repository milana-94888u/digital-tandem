extends Camera2D
class_name Virus


signal chat_requested


var control_processed := true


const MIN_ZOOM := 0.1
const MAX_ZOOM := 2.0


func _physics_process(_delta: float) -> void:
	if not control_processed:
		return
	position += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 10
	if Input.is_action_pressed("zoom_in"):
		zoom = Vector2.ONE * minf(MAX_ZOOM, zoom.x + 0.02)
	elif Input.is_action_pressed("zoom_out"):
		zoom = Vector2.ONE * maxf(MIN_ZOOM, zoom.x - 0.02)


func _input(event: InputEvent) -> void:
	if not control_processed:
		return
	if event.is_action_pressed("ui_chat"):
		chat_requested.emit()













