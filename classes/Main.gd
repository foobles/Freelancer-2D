extends Control

onready var vp: Viewport = $Viewport
onready var vp_height := vp.size.y 

const DialogScenario = preload("res://classes/DialogScenario.gd")

func _unhandled_input(event: InputEvent):
	vp.input(event)
	if !vp.is_input_handled():
		vp.unhandled_input(event)
	
	
func _ready():
	pass





func _on_top_down_play_dialog(dialog_scenario_scene: PackedScene):
	var scenario: DialogScenario = dialog_scenario_scene.instance()
	$DialogDriver.run_dialog_scenario(scenario, null)
