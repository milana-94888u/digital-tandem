extends Node2D
class_name MechUpgrade


signal upgrade_picked(upgrade: MechUpgrade)


enum UpgradeType {
	JUMP_UNLOCK,
	RUN_UNLOCK,
	HEALTH_UP,
	ENERGY_UP,
}


@export var upgrade_type := UpgradeType.ENERGY_UP


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Mech:
		upgrade_picked.emit(self)
