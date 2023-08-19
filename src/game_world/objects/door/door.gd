extends GameObject


func select_game_object() -> void:
	modulate = Color.RED


func deselect_game_object() -> void:
	modulate = Color.WHITE


func change_object() -> void:
	$AnimatedSprite2D.play("open")
	$AudioStreamPlayer2D.play()
	await $AnimatedSprite2D.animation_finished
	remove_child($StaticBody2D)
