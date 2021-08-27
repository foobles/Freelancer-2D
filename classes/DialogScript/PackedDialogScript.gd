class_name PackedDialogScript
extends Resource

export var start: String = ""
export var blocks: Array  = []

const DialogScript = preload("res://classes/DialogScript/DialogScript.gd")
const Block = preload("res://classes/DialogScript/Block.gd")
const UpdateType = Block.UpdateType
const Line = preload("res://classes/DialogScript/Line.gd")

func unpack() -> DialogScript:
	var dialog_script := DialogScript.new()
	dialog_script.start = start.strip_edges()
	for packed_block in blocks:
		var block := Block.new()
		for packed_line in packed_block.lines:
			var line := Line.new()
			line.speech = packed_line.speech 
			line.speaker = packed_line.speaker
			line.speaker_node = packed_line.speaker_node.strip_edges() 
			line.animation = packed_line.animation.strip_edges()
			block.lines.append(line)
		
		block.update_type = packed_block.update_type
		block.next_block = packed_block.next_block.strip_edges()
		for packed_option in packed_block.query:
			block.query[packed_option.key] = packed_option.val.strip_edges()
			
		block.update_func = packed_block.update_func.strip_edges()
		dialog_script.blocks[packed_block.name.strip_edges()] = block
			
	return dialog_script
