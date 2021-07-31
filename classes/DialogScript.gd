extends Resource

var contextualized := false 

var lines: Array = []
var prompts: Array = [] setget , get_prompts
var next_scripts: Array = [null]

var game_state_update_func: String = ""
var game_state_update_params: Array = []
var update_mode: int = UpdateMode.OFF 

enum UpdateMode {
	OFF, UPDATE, UPDATE_QUERY_BR, UPDATE_QUERY_COND_BR
} 


func get_next_script(dialogs: Dictionary, response: int = 0):
	assert(contextualized)
	var name = next_scripts[response]
	if name == null:
		return null
	else:
		return dialogs[name]


func contextualize(game_state) -> void:
	contextualized = true 
	match update_mode:
		UpdateMode.OFF:
			pass
		UpdateMode.UPDATE:
			game_state.callv(game_state_update_func, game_state_update_params)
		UpdateMode.UPDATE_QUERY_BR:
			next_scripts = [game_state.callv(game_state_update_func, game_state_update_params)]
		UpdateMode.UPDATE_QUERY_COND_BR:
			var opts: Dictionary = game_state.callv(game_state_update_func, game_state_update_params)
			prompts = opts.keys()
			next_scripts = opts.values()


func line_leads_to_option(idx: int) -> bool:
	return (idx + 1 == len(lines)) && (len(prompts) > 0)
	

func get_prompts() -> Array:
	assert(contextualized)
	return prompts


class Line:
	var speaker: String
	var text: String
	
	var speaker_name_override: String = ""
	var new_animation: String = ""
	
	
	func _init(speaker: String, text: String):
		self.text = text 
		self.speaker = speaker 
		
	
