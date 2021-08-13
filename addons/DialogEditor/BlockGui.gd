tool
extends Control

signal removed(block)
signal updated 

var block: Dictionary = _make_empty_block()

const UpdateType = preload("res://classes/DialogScript/Block.gd").UpdateType

const LineGuiScene = preload("res://addons/DialogEditor/LineGui.tscn")
const LineGui = preload("res://addons/DialogEditor/LineGui.gd")

const OptionGuiScene = preload("res://addons/DialogEditor/OptionGui.tscn")
const OptionGui = preload("res://addons/DialogEditor/OptionGui.gd")

onready var _name_line_edit: LineEdit = $Content/Toolbar/NameLineEdit
onready var _delete_button: Button = $Content/Toolbar/DeleteButton

onready var _lines_list: VBoxContainer = $Content/Lines/List
onready var _add_line_button: Button = $Content/Lines/AddLineButton

onready var _update_type_option_button: OptionButton = $Content/UpdateType/OptionButton

onready var _is_query_section: HBoxContainer = $Content/IsQuery
onready var _is_query_checkbox: CheckBox = $Content/IsQuery/CheckBox

onready var _next_block_section: HBoxContainer = $Content/NextBlock
onready var _next_block_line_edit: LineEdit = $Content/NextBlock/LineEdit

onready var _query_section: HBoxContainer = $Content/Query
onready var _query_add_option_button: Button = $Content/Query/Options/Button
onready var _query_option_list: VBoxContainer = $Content/Query/Options/List

onready var _update_func_section: HBoxContainer = $Content/UpdateFunc
onready var _update_func_line_edit: LineEdit = $Content/UpdateFunc/LineEdit

func replace_block(new_block: Dictionary) -> void:
	if block == new_block:
		return
		
	_name_line_edit.text = new_block.name
	for line_gui in _lines_list.get_children():
		_lines_list.remove_child(line_gui)
		line_gui.queue_free()
		
	for line in new_block.lines:
		_add_line(line)
		
	_update_type_option_button.selected = _update_type_option_button.get_item_index(new_block.update_type)
	_is_query_checkbox.pressed = (len(new_block.query) > 0)
	_next_block_line_edit.text = new_block.next_block
	
	for option_gui in _query_option_list.get_children():
		_query_option_list.remove_child(option_gui)
		option_gui.queue_free() 
		
	for option in new_block.query:
		_add_option(option)
		
	_update_func_line_edit.text = new_block.update_func
	_show_relevant_sections()
	block = new_block


func _ready() -> void:
	if get_tree().edited_scene_root != self:
		_update_type_option_button.add_item("Off", UpdateType.OFF)
		_update_type_option_button.add_item("Update", UpdateType.UPDATE)
		_update_type_option_button.add_item("Update + Get Next Block", UpdateType.UPDATE_GET_NEXT)
		_update_type_option_button.add_item("Update + Get Query", UpdateType.UPDATE_GET_QUERY)
		_update_type_option_button.selected = 0 
		_show_relevant_sections()
		

func _on_name_line_edit_changed(new_text: String) -> void:
	block.name = new_text
	emit_signal("updated")
	
func _on_delete_button_pressed() -> void:
	get_parent().remove_child(self)
	emit_signal("removed", block)
	queue_free()

func _on_add_line_button_pressed() -> void:
	_add_line({})
	emit_signal("updated")

func _on_update_type_option_button_item_selected(index: int) -> void:
	block.update_type = _update_type_option_button.get_selected_id()
	_show_relevant_sections()
	emit_signal("updated")

func _on_is_query_checkbox_toggled(pressed: bool) -> void:
	_show_relevant_block_section()
	emit_signal("updated")
	
func _on_next_block_line_edit_changed(new_text: String) -> void:
	block.next_block = new_text
	emit_signal("updated")

func _on_query_add_option_button_pressed() -> void:
	_add_option({})
	emit_signal("updated")

func _on_update_func_line_edit_changed(new_text: String) -> void:
	block.update_func = new_text
	emit_signal("updated")

	
func _show_relevant_sections() -> void:
	var selected_option: int = _update_type_option_button.get_selected_id()
	match selected_option:
		UpdateType.OFF:
			_set_next_block_section_visible(true)
			_set_update_func_visible(false)
			
		UpdateType.UPDATE:
			_set_next_block_section_visible(true)
			_set_update_func_visible(true)
		
		UpdateType.UPDATE_GET_NEXT, UpdateType.UPDATE_GET_QUERY:
			_set_next_block_section_visible(false)
			_set_update_func_visible(true)


func _set_next_block_section_visible(v: bool) -> void:
	_is_query_section.visible = v
	if v:
		_show_relevant_block_section()
	else:
		_next_block_section.visible = false
		_query_section.visible = false
		block.next_block = ""
		block.query = []
	
	
func _show_relevant_block_section() -> void:
	var is_query := _is_query_checkbox.pressed
	_next_block_section.visible = !is_query
	_query_section.visible = is_query
	
	if !is_query:
		block.next_block = _get_next_block()
		block.query = []
	else:
		block.next_block = ""
		block.query = _get_query() 
		

	
func _set_update_func_visible(v: bool) -> void:
	_update_func_section.visible = v 
	if v:
		block.update_func = _get_update_func()
	else:
		block.update_func = "" 
	

func _add_line(new_line: Dictionary) -> LineGui:
	var line_gui: LineGui = LineGuiScene.instance()
	line_gui.connect("removed", self, "_on_line_removed")
	line_gui.connect("updated", self, "_on_line_updated")
	_lines_list.add_child(line_gui)
	if len(new_line) > 0:
		line_gui.replace_line(new_line)
	
	block.lines.append(line_gui.line)
	return line_gui
	
func _on_line_removed(line: Dictionary) -> void:
	block.lines.erase(line)
	emit_signal("updated")
	
func _on_line_updated() -> void:
	emit_signal("updated") 


func _add_option(new_option: Dictionary) -> OptionGui:
	var option_gui: OptionGui = OptionGuiScene.instance()
	option_gui.connect("removed", self, "_on_option_removed")
	option_gui.connect("updated", self, "_on_option_updated")
	_query_option_list.add_child(option_gui)
	if len(new_option) > 0:
		option_gui.replace_option(new_option)
		
	block.query.append(option_gui.option)
	return option_gui
	
func _on_option_removed(option: Dictionary) -> void:
	block.query.erase(option)
	emit_signal("updated")
	
func _on_option_updated() -> void:
	emit_signal("updated")



func _get_next_block() -> String:
	return _next_block_line_edit.text
	
func _get_query() -> Array:
	var ret := []
	for option_gui in _query_option_list.get_children():
		ret.append(option_gui.option)
	return ret 
	
func _get_update_func() -> String:
	return _update_func_line_edit.text


func _make_empty_block() -> Dictionary:
	return {
		name = "",
		lines = [],
		update_type = UpdateType.OFF,
		next_block = "",
		query = [],
		update_func = "",
	}
