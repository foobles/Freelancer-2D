enum UpdateType {
	OFF, UPDATE, UPDATE_GET_NEXT, UPDATE_GET_QUERY
}

var lines: Array 
var update_type: int 
var next_block: String 
var query: Dictionary
var update_func: String


func line_leads_to_query(idx: int) -> bool:
	return is_query() && (idx == len(lines) - 1)
	
	
func is_query() -> bool:
	return len(query) > 0 || update_type == UpdateType.UPDATE_GET_QUERY


func update_and_get_next_block(game_state: Object) -> String:
	match update_type:
		UpdateType.OFF: 
			return next_block 
		UpdateType.UPDATE:
			game_state.call(update_func)
			return next_block 
		UpdateType.UPDATE_GET_NEXT:
			return game_state.call(update_func)
	
	assert(false, "update_and_get_next_block called with invalid update type")
	return ""
	
	
func update_and_get_query(game_state: Object) -> Dictionary:
	match update_type:
		UpdateType.OFF: 
			return query 
		UpdateType.UPDATE:
			game_state.call(update_func)
			return query 
		UpdateType.UPDATE_GET_QUERY:
			return game_state.call(update_func)
	
	assert(false, "update_and_get_query called with invalid update type")
	return {}
	
