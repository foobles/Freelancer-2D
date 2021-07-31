extends Control

onready var vp: Viewport = $Viewport
onready var vp_height := vp.size.y 

const DialogScript = preload("res://classes/DialogScript.gd")

func _unhandled_input(event: InputEvent):
	vp.input(event)
	if !vp.is_input_handled():
		vp.unhandled_input(event)
	
	
func _ready():
	var scr1 = DialogBuilder.new().then_say("x", "you took the left hand path!").then_say("x", "okay then").and_stop()
	var scr2 = DialogBuilder.new().then_say("y", "you went down the right road huh?").and_stop()
	
	var scr = DialogBuilder.new() \
		.then_say("Foo", "Please, select one of the following options, i beg of you") \
		.and_query({
			left = "scr1",
			right = null,
		})
		
	var dialogs = {
		"scr1": scr1,
		"scr2": scr2,
		"scr": scr
	}
	$DialogDriver.call_deferred("run_dialog", dialogs, "scr")
