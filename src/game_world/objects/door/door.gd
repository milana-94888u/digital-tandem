extends GameObject


func select_game_object() -> void:
	modulate = Color.RED


func deselect_game_object() -> void:
	modulate = Color.WHITE


func change_object() -> void:
	$AnimatedSprite2D.play("open")
	await $AnimatedSprite2D.animation_finished
