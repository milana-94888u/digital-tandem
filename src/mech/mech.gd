extends CharacterBody2D
class_name Mech


var active_door: FrontDoor


signal chat_requested


var control_processed := true


@export var speed := 600
@export var jump_power := 4000

@export var acceleration := 50
@export var friction := 70

@export var gravity := 120

@export var max_health := 100:
	set(value):
		max_health = value
		$UICanvas/MechUI.update_max_health(value)
		$FloatingUI.update_max_health(value)
@export var health := 100:
	set(value):
		health = value
		$UICanvas/MechUI.update_health(value)
		$FloatingUI.update_health(value)

@export var max_energy := 10000:
	set(value):
		max_energy = value
		$UICanvas/MechUI.update_max_energy(value)
		$FloatingUI.update_max_energy(value)
@export var energy := 10000:
	set(value):
		energy = value
		$UICanvas/MechUI.update_energy(value)
		$FloatingUI.update_energy(value)


enum AttackType {NONE, MEELE, SHOOT}
enum MoveType {WALK, RUN, CROACH}

var current_attack := AttackType.NONE
var current_move := MoveType.WALK


func _physics_process(_delta: float) -> void:
	set_animation()
	move_and_slide()
	if velocity:
		self.energy -= int(absf(velocity.x) / 120.0) + (5 if velocity.y > 0 else 0)


func _process(_delta: float) -> void:
	var input_direction := Vector2(Input.get_axis("ui_left", "ui_right"), 0.0).normalized() if control_processed else Vector2.ZERO
	if input_direction != Vector2.ZERO:
		accelerate(input_direction)
	else:
		add_friction()
	process_jump()


func accelerate(direction) -> void:
	velocity = velocity.move_toward(speed * direction, acceleration)


func add_friction() -> void:
	velocity = velocity.move_toward(Vector2.ZERO, friction)


func process_jump() -> void:
	if control_processed and Input.is_action_just_pressed("ui_up"):
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


func _on_mouse_entered() -> void:
	modulate = Color.WHEAT
	$FloatingUI.show()


func _on_mouse_exited() -> void:
	modulate = Color.WHITE
	$FloatingUI.hide()


func _input(event: InputEvent) -> void:
	if not control_processed:
		return
	if event.is_action_pressed("ui_chat"):
		chat_requested.emit()
	elif event.is_action_pressed("interact"):
		if active_door:
			position = active_door.teleport() - Vector2(1000, 392.691)


func set_active_door(door: FrontDoor) -> void:
	active_door = door


func remove_active_door(door: FrontDoor) -> void:
	if active_door == door:
		active_door = null
























