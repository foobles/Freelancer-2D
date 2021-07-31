extends Reference 

class_name DialogBuilder

const DialogScript = preload("res://classes/DialogScript.gd")

const UpdateMode = DialogScript.UpdateMode

var _inner: DialogScript = DialogScript.new() 

func then_say(speaker: String, text: String) -> DialogBuilder:
	_inner.lines.append(DialogScript.Line.new(speaker, text))
	return self 


func update_with(f: String, args: Array) -> DialogBuilder:
	_inner.update_mode = UpdateMode.UPDATE
	_set_updater(f, args)
	return self



func and_stop() -> DialogScript:
	return _inner 


func and_play(next: DialogScript) -> DialogScript:
	_inner.next_scripts = [next]
	return _inner 

	
func and_query(queries: Dictionary) -> DialogScript:
	_inner.prompts = queries.keys()
	_inner.next_scripts = queries.values()
	return _inner 


func and_play_from_update(f: String, args: Array) -> DialogScript:
	_inner.update_mode = UpdateMode.UPDATE_QUERY_BR
	_set_updater(f, args) 
	return _inner
	
	
func and_query_from_update(f: String, args: Array) -> DialogScript:
	_inner.update_mode = UpdateMode.UPDATE_QUERY_COND_BR
	_set_updater(f, args)
	return _inner
	

func _set_updater(f: String, args: Array) -> void:
	_inner.game_state_update_func = f 
	_inner.game_state_update_params = args 
