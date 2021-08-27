extends VBoxContainer

export var padding_size: int = 20 

signal dialog_line_done()
signal dialog_display_line_complete()
signal dialog_option_selected(idx)

const ResponseBox = preload("res://classes/ResponseBox.gd")

onready var _speech_area: PanelContainer = $SpeechArea
onready var _response_box: ResponseBox = $ResponseBox 
onready var _name_label: Label = $SpeechArea/VBoxContainer/NameLabel
onready var _speech_label: RichTextLabel = $SpeechArea/VBoxContainer/TextBox

onready var _tween: Tween = $Tween
onready var _char_timer: Timer = $CharTimer
onready var _message_delay_timer: Timer = $MessageDelayTimer

var _text_auto_continue := false
var _text_completed := false 

const _OPT_COLUMNS := 2
const _TWEEN_SPEED := 1.0 / 8
const _TEXT_SPEED := 1.0 / 15


func play_message(name: String, msg: String, auto_continue: bool) -> void:
	_text_completed = false 
	_name_label.text = name 
	_text_auto_continue = auto_continue
	_speech_label.visible_characters = 0
	_speech_label.text = msg 
	_char_timer.start()


func ask_options(opts: Dictionary) -> void:
	_response_box.options = opts
	if _response_box.pending_resize:
		yield(self, "resized")
	show_options()



func show_options() -> void:
	_response_box.enabled = true 
	_tween.interpolate_property(
		self, 
		"margin_top", 
		margin_top, 
		-(rect_size.y + padding_size), 
		_TWEEN_SPEED
	)
	_tween.start()


func hide_options() -> void:
	_response_box.enabled = false 
	_tween.interpolate_property(
		self, 
		"margin_top", 
		margin_top, 
		-(_speech_area.rect_size.y + padding_size), 
		_TWEEN_SPEED
	)
	_tween.start()


func show_menu() -> void:
	set_process_input(true) 
	_response_box.enabled = false 
	_tween.interpolate_property(
		self, 
		"margin_top", 
		margin_top, 
		-(_speech_area.rect_size.y + padding_size), 
		_TWEEN_SPEED
	)
	_tween.start()


func hide_menu() -> void:
	set_process_input(false)
	_response_box.enabled = false  
	_tween.interpolate_property(
		self, 
		"margin_top", 
		margin_top, 
		padding_size, 
		_TWEEN_SPEED
	)
	_tween.start()



func _ready() -> void:
	add_constant_override("separation", padding_size)
	margin_left = padding_size
	margin_right = -padding_size


func _complete_text() -> void:
	_text_completed = true
	_speech_label.visible_characters = -1 
	_char_timer.stop()
	emit_signal("dialog_display_line_complete")
	if _text_auto_continue:
		_message_delay_timer.start()
		yield(_message_delay_timer, "timeout")
		emit_signal("dialog_line_done")


func _input(event: InputEvent) -> void:
	get_tree().set_input_as_handled()
	if event.is_action_pressed("ui_select"):
		if _text_completed:
			emit_signal("dialog_line_done")
			_message_delay_timer.stop()
		else:
			_complete_text()



func _on_CharTimer_timeout() -> void:
	_speech_label.visible_characters += 1 
	if _speech_label.visible_characters >= len(_speech_label.text): 
		_complete_text()



func _on_ResponseBox_option_selected(val) -> void:
	_message_delay_timer.start()
	yield(_message_delay_timer, "timeout")
	hide_options()
	emit_signal("dialog_option_selected", val)
