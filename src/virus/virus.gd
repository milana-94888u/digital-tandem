extends CharacterBody2D
class_name Virus


signal chat_requested

signal minigame_completed
signal minigame_canceled

signal teleport_to_mech_requested


var control_processed := true


const MIN_ZOOM := 0.34
const MAX_ZOOM := 2.0


func _process(_delta: float) -> void:
	if not control_processed:
		return
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 600 / $Camera2D.zoom.x
	var is_move := velocity != Vector2.ZERO
	move_and_slide()
	if Input.is_action_pressed("zoom_in"):
		is_move = true
		$Camera2D.zoom = Vector2.ONE * maxf(MIN_ZOOM, $Camera2D.zoom.x + 0.02)
	elif Input.is_action_pressed("zoom_out"):
		is_move = true
		$Camera2D.zoom = Vector2.ONE * maxf(MIN_ZOOM, $Camera2D.zoom.x - 0.02)
	if is_move:
		if not $MovePlayer.playing:
			$MovePlayer.play()
	else:
		$MovePlayer.stop()


func _input(event: InputEvent) -> void:
	if not control_processed:
		return
	if event.is_action_pressed("ui_chat"):
		chat_requested.emit()
	elif event.is_action_pressed("ui_accept"):
		teleport_to_mech_requested.emit() 


func finish_minigame(minigame: Minigame, result: Signal) -> void:
	$UICanvas.remove_child(minigame)
	result.emit()


func start_minigame(minigame: Minigame) -> void:
	$UICanvas.add_child(minigame)
	minigame.completed.connect(finish_minigame.bind(minigame, minigame_completed))
	minigame.canceled.connect(finish_minigame.bind(minigame, minigame_canceled))











