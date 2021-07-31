extends Node2D

const Map = preload("res://classes/Map.gd")
const Player = preload("res://classes/Player.gd")

export var tween_time: float = 2.0
export var grid_size: int = 16

onready var map: Map = $Map 
onready var cam: Camera2D = $Camera2D
onready var cam_tween: Tween = $CameraTween

onready var entities: YSort = $Entities
onready var player: Player = $Entities/Player
var npcs: YSort = null
var props: YSort = null


func _ready() -> void:
	map.enable_deferred()
	call_deferred("_take_map_entities")


func _on_Map_change_map(new_map_scene: PackedScene, direction: Vector2) -> void:
	map.disable_deferred()
	var new_map: Map = new_map_scene.instance()
	new_map.position = Vector2(
		max(0, direction.x) * map.size.x + min(0, direction.x) * new_map.size.x,
		max(0, direction.y) * map.size.y + min(0, direction.y) * new_map.size.y
	)
	add_child(new_map)
	move_child(new_map, 0)
	cam_tween.interpolate_property(
		cam, 
		"position", 
		map.position, 
		new_map.position, 
		tween_time
	)
	cam_tween.interpolate_property(
		player, 
		"position", 
		player.position, 
		player.position + direction * grid_size, 
		tween_time
	)
	cam_tween.interpolate_callback(
		self,
		tween_time,
		"_finalize_map_transition",
		new_map 
	)
	#player.set_process(false)
	cam_tween.start()



func _finalize_map_transition(new_map: Map) -> void:
	map.queue_free()
	
	player.position -= new_map.position
	new_map.position = Vector2.ZERO 
	cam.position = Vector2.ZERO 
	
	new_map.enable_deferred()
	new_map.connect("change_map", self, "_on_Map_change_map")
	
	props.queue_free()
	npcs.queue_free()
	
	map = new_map 
	_take_map_entities()


func _take_map_entities() -> void:
	var props := map.detatch_props()
	var npcs := map.detatch_npcs()
	entities.add_child(props)
	entities.add_child(npcs)
	self.props = props 
	self.npcs = npcs 
