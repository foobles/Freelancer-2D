extends Node2D

var animating_speech: bool = false setget set_animating_speech

var still_anim: String
var speaking_anim: String

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _sprite: Sprite = $Sprite

func set_animating_speech(b: bool) -> void:
	animating_speech = b
	if b:
		_animation_player.play(speaking_anim)
	else:
		_animation_player.play(still_anim)
			
