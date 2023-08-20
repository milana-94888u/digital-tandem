extends Node


var applied_upgrades: Array[MechUpgrade.UpgradeType] = []


func apply_upgrade(upgrade: MechUpgrade.UpgradeType) -> void:
	applied_upgrades.append(upgrade)
