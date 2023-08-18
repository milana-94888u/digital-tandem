extends Minigame


@export var captcha_images: Array[CompressedTexture2D]


var captcha: String


func _ready() -> void:
	randomize()
	var image := captcha_images[randi() % captcha_images.size()]
	$VBoxContainer/TextureRect.texture = image
	captcha = image.resource_path.get_file().trim_suffix(".png")


func _on_line_edit_text_submitted(new_text: String) -> void:
	if captcha == new_text:
		$MistakeLabel.text = "Correct!"
		$MistakeLabel.show()
		completed.emit()
	else:
		$MistakeLabel.show()
		get_tree().create_timer(1.0).timeout.connect(func(): $MistakeLabel.hide())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		canceled.emit()
