extends Node2D

export(String, FILE, "*.tscn") var map_up
export(String, FILE, "*.tscn") var map_down
export(String, FILE, "*.tscn") var map_left
export(String, FILE, "*.tscn") var map_right

export var size := Vector2(16 * 18, 16 * 10)

export var enabled: bool = false 

signal change_map(map, direction)


onready var _hitboxes = [
	$HBUp/CollisionShape2D,
	$HBDown/CollisionShape2D,
	$HBLeft/CollisionShape2D,
	$HBRight/CollisionShape2D
]


func set_enabled(b):
	enabled = b 
	for hb in _hitboxes:
		hb.disabled = !b


func enable_deferred():
	self.call_deferred("set_enabled", true)


func disable_deferred():
	self.call_deferred("set_enabled", false)


func defer_emit_change_map(map: String, dir: Vector2) -> void:
	if len(map) > 0:
		call_deferred("emit_signal", "change_map", load(map), dir)
		

func detatch_props() -> YSort:
	var props: YSort = $Props
	remove_child(props)
	return props 
	
	
func detatch_npcs() -> YSort:
	var npcs: YSort = $Npcs
	remove_child(npcs)
	return npcs 


func _on_HBUp_area_entered(_area):
	defer_emit_change_map(map_up, Vector2.UP)


func _on_HBDown_area_entered(_area):
	defer_emit_change_map(map_down, Vector2.DOWN)


func _on_HBLeft_area_entered(_area):
	defer_emit_change_map(map_left, Vector2.LEFT)


func _on_HBRight_area_entered(_area):
	defer_emit_change_map(map_right, Vector2.RIGHT)
