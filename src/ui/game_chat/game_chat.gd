extends Control


func new_message(message_text: String) -> void:
	var label := Label.new()
	label.text = message_text
	label.add_theme_font_size_override("font_size", 36)
	$VBoxContainer.add_child(label)
	get_tree().create_timer(5.0).timeout.connect(func(): $VBoxContainer.remove_child(label))
