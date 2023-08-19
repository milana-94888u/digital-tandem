extends GameObject

func change_object() -> void:
	remove_child($Light)
	remove_child($StaticBody2D)
