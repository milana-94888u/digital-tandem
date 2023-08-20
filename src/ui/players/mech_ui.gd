extends Control


@onready var energy_bar := $VBoxContainer/EnergyBar as TextureProgressBar
@onready var energy_label := $VBoxContainer/EnergyBar/Label as Label
@onready var health_bar := $VBoxContainer/HealthBar as TextureProgressBar
@onready var health_label := $VBoxContainer/HealthBar/Label as Label


func update_max_energy(value: int) -> void:
	var delta := value - energy_bar.max_value
	energy_bar.max_value = value
	update_energy(int(energy_bar.value + delta))


func update_energy(value: int) -> void:
	energy_bar.value = value
	energy_label.text = "%d/%d" % [energy_bar.value, energy_bar.max_value]


func update_max_health(value: int) -> void:
	var delta := value - health_bar.max_value
	health_bar.max_value = value
	update_health(int(health_bar.value + delta))


func update_health(value: int) -> void:
	health_bar.value = value
	health_label.text = "%d/%d" % [health_bar.value, health_bar.max_value]
