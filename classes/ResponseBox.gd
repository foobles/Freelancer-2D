#tool
extends PanelContainer


export var option_columns: int = 2 setget set_option_columns
export (Array, String) var options setget set_options


var enabled := true setget set_enabled 

signal option_selected(index)

var _cur_selected: int = 0
var _num_options: int = 0
onready var _grid: GridContainer = $GridContainer


const _DIALOG_OPTION_SCENE := preload("res://scenes/DialogOption.tscn")
const DialogOption := preload("res://classes/DialogOption.gd")

func set_options(arr: Array) -> void:
	options = arr 
	_num_options = len(arr)
	_cur_selected = 0
	
	if _grid == null: 
		return
		
	for old_opt in _grid.get_children():
		old_opt.queue_free()
	
	var first := true 
	for new_opt_str in arr:
		var new_opt = _DIALOG_OPTION_SCENE.instance() 
		if first:
			new_opt.selected = true 
			first = false 
		new_opt.option_text = new_opt_str 
		_grid.add_child(new_opt)
		


func set_option_columns(n: int) -> void:
	option_columns = n 
	if _grid != null:
		_grid.columns = n 


func set_enabled(b: bool) -> void:
	enabled = b 
	set_process_input(b)


func _ready():
	_grid.columns = option_columns
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		_move_selection(-option_columns)
	elif event.is_action_pressed("ui_down"):
		_move_selection(option_columns)
	elif event.is_action_pressed("ui_left"):
		_move_selection(-1)
	elif event.is_action_pressed("ui_right"):
		_move_selection(1)
	elif event.is_action_pressed("ui_select"):
		emit_signal("option_selected", _cur_selected)
	else:
		return 
	get_tree().set_input_as_handled()
	
	
func _move_selection(n: int) -> void:
	_grid.get_child(_cur_selected).selected = false 
	_cur_selected = posmod(_cur_selected + n, _num_options)
	_grid.get_child(_cur_selected).selected = true 
