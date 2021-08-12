tool
extends EditorProperty

const DialogScriptGuiScene = preload("res://addons/DialogEditor/DialogScriptGui.tscn")
const DialogScriptGui = preload("res://addons/DialogEditor/DialogScriptGui.gd")

var _dialog_script_gui: DialogScriptGui = null
var _updating: bool = false

func _init():
	_dialog_script_gui = DialogScriptGuiScene.instance() 
	_dialog_script_gui.connect("blocks_updated", self, "_on_dialog_script_blocks_updated")
	_dialog_script_gui.connect("start_updated", self, "_on_dialog_script_start_updated")
	add_child(_dialog_script_gui)
	set_bottom_editor(_dialog_script_gui)


func update_property() -> void:
	if _updating:
		_updating = false 
		return
		
	_dialog_script_gui.replace_dialog_script(get_edited_object())


func _on_dialog_script_blocks_updated() -> void:
	emit_changed("blocks", _dialog_script_gui.dialog_script.blocks)
	_updating = true 
	
	
func _on_dialog_script_start_updated() -> void:
	emit_changed("start", _dialog_script_gui.dialog_script.start)
	_updating = true 
	
	
