extends KinematicBody2D


export var grid_size: int = 8 setget set_grid_size

onready var _anim: AnimationPlayer = $AnimationPlayer
onready var _sprite: Sprite = $Sprite
onready var _col_shape: CollisionShape2D = $CollisionShape2D 
onready var _col_shape_rect: RectangleShape2D = _col_shape.shape 

var _move_dir := Vector2.ZERO
var _half_grid_size: int = grid_size / 2

const _SPEED: int = 16 * 6


func set_grid_size(n: int):
	grid_size = n 
	_half_grid_size = n / 2 


func _unhandled_input(event: InputEvent) -> void:
	if _handle_input(event, "move_up", Vector2.UP):
		_sprite.scale.x = 1 
		_anim.play("walk_up")
		
	elif _handle_input(event, "move_down" , Vector2.DOWN ):
		_sprite.scale.x = 1
		_anim.play("walk_down")
	
	elif _handle_input(event, "move_left", Vector2.LEFT):
		_sprite.scale.x = 1
		_anim.play("walk_side") 
	
	elif _handle_input(event, "move_right", Vector2.RIGHT):
		_sprite.scale.x = -1 
		_anim.play("walk_side")
		
	else:
		return 
	

func _process(_delta: float) -> void:
	if _move_dir != Vector2.ZERO:
		if _moving_horizontally():
			_col_shape_rect.extents = Vector2(8, 2)
		else:
			_col_shape_rect.extents = Vector2(4, 4) 
			
		_col_shape.set_deferred("disabled", _vector_to_next_intersection() != Vector2.ZERO)
		
	

func _physics_process(delta: float) -> void:
	if _move_dir == Vector2.ZERO:
		return 
	
	var distance: float = _SPEED * delta
	var to_next_intersection := _vector_to_next_intersection()
	var distance_to_intersection := _cardinal_distance(to_next_intersection)
	if distance_to_intersection == 0:
		move_and_collide(_move_dir * distance)
	elif distance_to_intersection < distance:
		move_and_collide(to_next_intersection)
		#move_and_collide(_move_dir * (distance - distance_to_intersection))
	else:
		move_and_collide(to_next_intersection.normalized() * distance)
		

func _handle_input(event: InputEvent, action: String, dir: Vector2) -> bool:
	if event.is_action_pressed(action):
		_move_dir = dir 
		return true 
	elif event.is_action_released(action) && _move_dir == dir:
		_move_dir = Vector2.ZERO  
	return false 
	
	
func _vector_to_next_intersection() -> Vector2:
	if _moving_horizontally():
		var y_between := fposmod(position.y, grid_size)
		if y_between < _half_grid_size:
			return Vector2(0, -y_between)
		else:
			return Vector2(0, grid_size - y_between)
	else:
		var x_between := fposmod(position.x, grid_size)
		if x_between < _half_grid_size:
			return Vector2(-x_between, 0)
		else:
			return Vector2(grid_size - x_between, 0)
			

func _moving_horizontally() -> bool:
	return _move_dir.x != 0


func _cardinal_distance(v: Vector2) -> float:
	return abs(v.x + v.y)
