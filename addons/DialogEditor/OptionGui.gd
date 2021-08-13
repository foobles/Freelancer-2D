tool
extends Control

signal removed(option)
signal updated

var option = _make_empty_option()

onready var _key_line_edit: LineEdit = $KeyLineEdit
onready var _val_line_edit: LineEdit = $ValLineEdit
onready var _delete_button: Button = $DeleteButton

func replace_option(new_option: Dictionary) -> void:
	if option == new_option:
		return
		
	_key_line_edit.text = new_option.key
	_val_line_edit.text = new_option.val 
	option = new_option


func _on_delete_button_pressed() -> void:
	get_parent().remove_child(self)
	emit_signal("removed", option)
	queue_free() 


func _on_key_line_edit_changed(new_text: String) -> void:
	option.key = new_text
	emit_signal("updated")
	

func _on_val_line_edit_changed(new_text: String) -> void:
	option.val = new_text
	emit_signal("updated")


func _make_empty_option() -> Dictionary:
	return {
		key = "",
		val = "",
	}
