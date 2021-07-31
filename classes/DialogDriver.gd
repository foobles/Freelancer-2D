extends Node

const DialogScript = preload("res://classes/DialogScript.gd")

var game_state
var dialogs: Dictionary
var cur_dialog: DialogScript 

var _cur_line_idx := 0
onready var _ui = $DialogBox

func _ready() -> void:
	_ui.call_deferred("hide_menu")


func run_dialog(dialogs: Dictionary, start: String) -> void:
	self.dialogs = dialogs
	self.cur_dialog = dialogs[start]
	self.cur_dialog.contextualize(game_state)
	_ui.show_menu()
	_cur_line_idx = 0
	_play_next_line()
	

func _play_next_line() -> void:
	if _cur_line_idx < len(cur_dialog.lines):
		var line: DialogScript.Line = cur_dialog.lines[_cur_line_idx]
		var auto_continue := cur_dialog.line_leads_to_option(_cur_line_idx)
		_ui.play_message(line.speaker, line.text, auto_continue)
		_cur_line_idx += 1
	elif len(cur_dialog.prompts) > 0:
		_ui.ask_options(cur_dialog.prompts)
	else:
		_run_next_script()


func _run_next_script(idx: int = 0) -> void:
	_cur_line_idx = 0
	var new_script: DialogScript = cur_dialog.get_next_script(dialogs, idx)
	if new_script == null:
		_ui.hide_menu()
		return 

	new_script.contextualize(game_state)
	cur_dialog = new_script
	_play_next_line()
	
	


func _on_DialogBox_dialog_option_selected(idx):
	_run_next_script(idx)


func _on_DialogBox_dialog_line_done():
	_play_next_line()
