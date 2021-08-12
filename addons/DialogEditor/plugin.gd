tool
extends EditorPlugin

var _inspector_plugin: EditorInspectorPlugin = null

func _enter_tree() -> void:
	_inspector_plugin = DialogInspectorPlugin.new()
	add_inspector_plugin(_inspector_plugin)

func _exit_tree() -> void:
	remove_inspector_plugin(_inspector_plugin)


class DialogInspectorPlugin extends EditorInspectorPlugin:
	func can_handle(object: Object) -> bool:
		return object is PackedDialogScript
		
	func parse_begin(object: Object) -> void:
		add_property_editor_for_multiple_properties(
			"Dialog Script",
			[
				"start",
				"blocks"
			],
			preload("res://addons/DialogEditor/DialogScriptEditor.gd").new()
		)
