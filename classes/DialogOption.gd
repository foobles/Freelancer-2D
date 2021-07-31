tool
extends HBoxContainer

var selected := false setget set_selected 
var option_text: String = "" setget set_option_text, get_option_text


func set_selected(val: bool) -> void:
	selected = val 
	$SelectIcon.visible_characters = int(val) 
	property_list_changed_notify()

func set_option_text(s: String) -> void:
	$Text.text = s 
	property_list_changed_notify()
	
func get_option_text() -> String:
	return $Text.text 
