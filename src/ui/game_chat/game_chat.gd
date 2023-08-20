extends Control


signal chat_closed


@onready var scrollbar := $MarginContainer/VBoxContainer/ScrollContainer.get_v_scroll_bar() as VScrollBar
@onready var chat_messages := $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer as VBoxContainer
@onready var current_message := $MarginContainer/CurrentMessage as Label
@onready var history_messages := $MarginContainer/VBoxContainer as VBoxContainer
@onready var chat_line := $MarginContainer/VBoxContainer/LineEdit


func show_chat() -> void:
	current_message.hide()
	history_messages.show()
	chat_line.grab_focus()
	chat_line.call_deferred("clear")


@rpc("any_peer", "call_local", "reliable")
func send_message(message_text: String) -> void:
	var label := Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = message_text
	chat_messages.add_child(label)
	
	if not history_messages.visible:
		current_message.text = message_text
		current_message.show()
		get_tree().create_timer(5.0).timeout.connect(func(): current_message.hide())


func _ready() -> void:
	scrollbar.changed.connect(autoscroll)


func autoscroll() -> void:
	if scrollbar.value < scrollbar.max_value:
		scrollbar.value = scrollbar.max_value


func _on_line_edit_text_submitted(new_text: String) -> void:
	chat_line.clear()
	send_message.rpc("%s: %s" % [Server.player_info["nickname"], new_text])


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		history_messages.hide()
		chat_closed.emit()
