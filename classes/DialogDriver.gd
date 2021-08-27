extends Node

const DialogScenario = preload("res://classes/DialogScenario.gd")
const DialogCharacter = preload("res://classes/DialogCharacter.gd")
const DialogScript = preload("res://classes/DialogScript/DialogScript.gd")
const Block = preload("res://classes/DialogScript/Block.gd")
const Line = preload("res://classes/DialogScript/Line.gd")
const DialogBox = preload("res://classes/DialogBox.gd")


var _game_state
var _dialog_scenario: DialogScenario 
var _dialog_script: DialogScript 
var _cur_block: Block
var _cur_line_idx := 0
onready var _ui: DialogBox = $DialogBox


func _ready() -> void:
	_ui.call_deferred("hide_menu")
	

func run_dialog_scenario(scenario: DialogScenario, game_state) -> void:
	_game_state = game_state
	_dialog_scenario = scenario
	add_child(scenario)
	move_child(scenario, 0)
	_dialog_script = scenario.packed_dialog_script.unpack()
	_cur_block = _dialog_script.blocks[_dialog_script.start]
	_cur_line_idx = 0
	_ui.show_menu()
	_play_next_line()
	

func _play_next_line() -> void:
	if _cur_line_idx < len(_cur_block.lines):
		var line: Line = _cur_block.lines[_cur_line_idx]
		var auto_continue := _cur_block.line_leads_to_query(_cur_line_idx)
		_ui.play_message(line.speaker, line.speech, auto_continue)
		_animate_line(line)
		_cur_line_idx += 1
	elif _cur_block.is_query():
		_ui.ask_options(_cur_block.update_and_get_query(_game_state))
	else:
		_run_next_block(_cur_block.update_and_get_next_block(_game_state))


func _run_next_block(block: String) -> void:
	_cur_line_idx = 0
	if len(block) == 0:
		_dialog_scenario.queue_free()
		_ui.hide_menu()
		return 
		
	_cur_block = _dialog_script.blocks[block]
	_play_next_line()
	
	
func _on_DialogBox_dialog_option_selected(next_block: String):
	_run_next_block(next_block)


func _on_DialogBox_dialog_line_done():
	_play_next_line()


func _animate_line(line: Line) -> void:
	var anim_required := len(line.animation) > 0
	var speaker: DialogCharacter = null
	if len(line.speaker_node) > 0:
		 speaker = _dialog_scenario.get_node(line.speaker_node)
	
	if speaker != null:
		if anim_required:
			speaker.call(line.animation)
		speaker.animating_speech = true 
		_ui.connect("dialog_display_line_complete", self, "_stop_line_animation", [speaker], CONNECT_ONESHOT)
	elif anim_required:
		assert(false, "Animation required with no speaker present")
	
	
func _stop_line_animation(character: DialogCharacter) -> void:
	character.animating_speech = false
