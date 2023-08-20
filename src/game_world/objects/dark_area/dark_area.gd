extends GameObject


var mech: Mech


func select_game_object() -> void:
	if has_node("Light"):
		$Light.color = Color.SKY_BLUE


func deselect_game_object() -> void:
	if has_node("Light"):
		$Light.color = Color.WHITE


func change_object() -> void:
	remove_child($Light)
	remove_child($StaticBody2D)
	remove_child($Area2D)
	remove_child($MechDamageTimer)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Mech:
		mech = body
		$MechDamageTimer.start()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Mech:
		mech = null
		$MechDamageTimer.stop()


func _on_mech_damage_timer_timeout() -> void:
	if mech:
		if mech.is_alive:
			mech.health -= 1
