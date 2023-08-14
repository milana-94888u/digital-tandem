extends CharacterBody2D


const GRAVITY = Vector2.DOWN * 1024

@export var speed := 65536


func go_right(delta: float) -> void:
	$AnimatedSprite2D.play("walk")
	$AnimatedSprite2D.flip_h = false
	velocity = Vector2.RIGHT * speed * delta + GRAVITY


func go_left(delta: float) -> void:
	$AnimatedSprite2D.play("walk")
	$AnimatedSprite2D.flip_h = true
	velocity = Vector2.LEFT * speed * delta + GRAVITY


func move() -> void:
	move_and_slide()


func stay() -> void:
	$AnimatedSprite2D.play("idle")


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		go_right(delta)
		move()
	elif Input.is_action_pressed("ui_left"):
		go_left(delta)
		move()
	else:
		stay()
	if not is_on_floor():
		velocity = GRAVITY
		move_and_slide()
