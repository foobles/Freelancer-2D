extends Node2D

export(Resource) var packed_dialog_script_resource = null
var packed_dialog_script: PackedDialogScript setget , get_packed_dialog_script

func get_packed_dialog_script() -> PackedDialogScript:
	return packed_dialog_script_resource
