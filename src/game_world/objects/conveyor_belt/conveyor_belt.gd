extends StaticBody2D


@export var speed := 100


func _ready() -> void:
	constant_linear_velocity.x = speed


func _process(delta: float) -> void:
	($Sprite2D.texture as AtlasTexture).region.position.x -= speed * delta
