extends VBoxContainer

signal file_selected(path: String)

@onready var tree_widget = $Tree
@onready var results_widget = $HBoxContainer/Results

func show_tree(tree: AssetNode):
	tree_widget.clear()
	if tree != null:
		results_widget.text = str(tree.leaves().size())
		_build_tree(tree)

func _build_tree(subtree, subtree_widget = null):
	var root = tree_widget.create_item(subtree_widget)
	root.set_text(0, subtree.value)
	root.set_meta("path", subtree.full_path)
	for child in subtree.children:
		_build_tree(child, root)

func _on_selected():
	var node = tree_widget.get_selected()
	if not node.get_children().is_empty():
		return
	emit_signal("file_selected", node.get_meta("path"))
