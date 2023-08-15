extends CharacterBody2D


@export var speed := 500
@export var jump_power := 3000

@export var acceleration := 50
@export var friction := 70

@export var gravity := 120


func _ready() -> void:
	if Server.player_info["role"] == Server.PlayerRole.MECH:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false


func _physics_process(_delta: float) -> void:
	var input_direction := Vector2(Input.get_axis("ui_left", "ui_right"), 0.0).normalized()
	if input_direction != Vector2.ZERO:
		accelerate(input_direction)
	else:
		add_friction()
	process_jump()
	set_animation()
	move_and_slide()


func accelerate(direction) -> void:
	velocity = velocity.move_toward(speed * direction, acceleration)


func add_friction() -> void:
	velocity = velocity.move_toward(Vector2.ZERO, friction)


func process_jump() -> void:
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = -jump_power
	velocity.y += gravity


func set_animation() -> void:
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false

	if is_on_floor():
		if velocity.x == 0.0:
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("jump")









