extends Node2D


var mech: Mech


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Mech:
		mech = body
		$Timer.start()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Mech:
		mech = null
		$Timer.stop()


func _on_timer_timeout() -> void:
	if mech:
		if mech.energy < mech.max_energy:
			mech.energy = mini(mech.energy + 100, mech.max_energy)
