extends StaticBody2D

signal npc_interact_dialogue(dialogs, start)

onready var _notif_sprite: Sprite = $SpeechNotif

var _ready_to_talk: bool = false

	
func _unhandled_input(event: InputEvent) -> void:
	if _ready_to_talk && event.is_action_pressed("ui_select"):
		print("talk!")


func _on_InteractionArea_area_entered(area):
	_set_speech_ready(true)
	
	

func _on_InteractionArea_area_exited(area):
	_set_speech_ready(false)
	
	
func _set_speech_ready(b: bool) -> void:
	_ready_to_talk = b 
	_notif_sprite.visible = b 
