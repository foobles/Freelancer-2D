tool
extends Control

signal removed(line)
signal updated

var line: Dictionary = _make_empty_line() 

onready var _speech_text_edit: TextEdit = $SpeechTextEdit
onready var _speaker_line_edit: LineEdit = $VBoxContainer/Speaker/LineEdit
onready var _speaker_node_line_edit: LineEdit = $VBoxContainer/SpeakerNode/LineEdit
onready var _animation_line_edit: LineEdit = $VBoxContainer/Animation/LineEdit

func replace_line(new_line: Dictionary) -> void:
	if line == new_line:
		return
		
	_speech_text_edit.text = new_line.speech
	_speaker_line_edit.text = new_line.speaker
	_speaker_node_line_edit.text = new_line.speaker_node
	_animation_line_edit.text = new_line.animation
	line = new_line


func _on_speech_text_edit_changed() -> void:
	line.speech = _speech_text_edit.text
	emit_signal("updated")
	

func _on_speaker_line_edit_changed(new_text: String) -> void:
	line.speaker = new_text
	emit_signal("updated")


func _on_speaker_node_line_edit_changed(new_text: String) -> void:
	line.speaker_node = new_text
	emit_signal("updated")
	
	
func _on_animation_line_edit_changed(new_text: String) -> void:
	line.animation = new_text
	emit_signal("updated")
	

func _on_delete_button_pressed() -> void:
	get_parent().remove_child(self)
	emit_signal("removed", line)
	queue_free()


func _make_empty_line() -> Dictionary:
	return {
		speech = "",
		speaker = "",
		speaker_node = "",
		animation = "",
	}
