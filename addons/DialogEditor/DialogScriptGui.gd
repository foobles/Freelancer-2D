tool
extends Control

signal start_updated
signal blocks_updated

const BlockGuiScene = preload("res://addons/DialogEditor/BlockGui.tscn")
const BlockGui = preload("res://addons/DialogEditor/BlockGui.gd")

var dialog_script: PackedDialogScript = PackedDialogScript.new()

onready var _start_line_edit: LineEdit = $Start/LineEdit
onready var _block_list: VBoxContainer = $BlockListMargin/BlockList
onready var _add_block_button: Button = $AddBlockButton


func replace_dialog_script(new_dialog_script: PackedDialogScript) -> void:
	_start_line_edit.text = new_dialog_script.start
	for block_gui in _block_list.get_children():
		_block_list.remove_child(block_gui)
		block_gui.queue_free()
		
	for block in new_dialog_script.blocks:
		_add_block(block)
		
	dialog_script = new_dialog_script
	

func _on_start_line_edit_changed(new_text: String) -> void:
	dialog_script.start = new_text
	emit_signal("start_updated")
	
func _on_add_block_button_pressed() -> void:
	_add_block({})
	emit_signal("blocks_updated")
	

func _add_block(new_block: Dictionary) -> BlockGui:
	var block_gui: BlockGui = BlockGuiScene.instance()
	block_gui.connect("removed", self, "_on_block_removed")
	block_gui.connect("updated", self, "_on_block_updated")  
	_block_list.add_child(block_gui)
	if len(new_block) > 0:
		block_gui.replace_block(new_block)
	
	dialog_script.blocks.append(block_gui.block)
	return block_gui

func _on_block_removed(block: Dictionary) -> void:
	dialog_script.blocks.erase(block)
	emit_signal("blocks_updated")
	
func _on_block_updated() -> void:
	emit_signal("blocks_updated")
