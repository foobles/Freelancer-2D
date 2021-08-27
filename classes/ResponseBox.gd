#tool
extends PanelContainer


export var option_columns: int = 2 setget set_option_columns
var options: Dictionary setget set_options


var enabled := true setget set_enabled 
var pending_resize := false

signal option_selected(val)

var _cur_selected: int = 0
var _option_vals: Array 
var _num_options: int = 0
onready var _grid: GridContainer = $GridContainer


const _DIALOG_OPTION_SCENE := preload("res://scenes/DialogOption.tscn")
const DialogOption := preload("res://classes/DialogOption.gd")

func set_options(opts: Dictionary) -> void:
	pending_resize = pending_resize || _change_will_cause_resize(
		options,
		option_columns,
		opts,
		option_columns
	)
	
	options = opts 
	_option_vals = opts.values()
	_num_options = len(opts)
	_cur_selected = 0
	
	if _grid == null: 
		return
		
	for old_opt in _grid.get_children():
		_grid.remove_child(old_opt)
		old_opt.queue_free()
	
	var first := true 
	for opt_key in opts:
		var new_opt = _DIALOG_OPTION_SCENE.instance() 
		if first:
			new_opt.selected = true 
			first = false 
		new_opt.option_text = opt_key 
		_grid.add_child(new_opt)
		


func set_option_columns(n: int) -> void: 
	pending_resize = pending_resize || _change_will_cause_resize(
		options,
		option_columns,
		options,
		n
	)
	option_columns = n 
	_grid.columns = n 


func set_enabled(b: bool) -> void:
	enabled = b 
	set_process_input(b)


func _ready():
	_grid.columns = option_columns
	pending_resize = true
	

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
		emit_signal("option_selected", _option_vals[_cur_selected])
	else:
		return 
	get_tree().set_input_as_handled()
	
	
func _move_selection(n: int) -> void:
	_grid.get_child(_cur_selected).selected = false 
	_cur_selected = posmod(_cur_selected + n, _num_options)
	_grid.get_child(_cur_selected).selected = true 


func _change_will_cause_resize(
	old_opts: Dictionary, 
	old_cols: int, 
	new_opts: Dictionary, 
	new_cols: int
) -> bool:
	var old_len := len(old_opts)
	var new_len := len(new_opts)
	
	var old_rows := (old_len / old_cols) + int(old_len % old_cols != 0)
	var new_rows := (new_len / new_cols) + int(new_len % new_cols != 0)
	return old_rows != new_rows


func _on_OptionArea_resized() -> void:
	pending_resize = false
