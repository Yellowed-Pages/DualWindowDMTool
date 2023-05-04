class_name AssetNode

var value: String = ""
var full_path: String = ""
var is_leaf: bool = true
var children: Array[AssetNode] = []

func get_subtree(filter: String) -> AssetNode:
	if is_leaf:
		if filter.is_empty() or value.to_lower().contains(filter.to_lower()):
			return self
		else:
			return null
	var map_child = func (child): return child.get_subtree(filter)
	var filter_child = func (child): return child != null
	var node = AssetNode.new()
	node.value = value
	node.full_path = full_path
	node.is_leaf = false
	for child in children.map(map_child).filter(filter_child):
		node.children.append(child)
	return null if node.children.is_empty() else node
	

static func from_path(path: String, name: String = "") -> AssetNode:
	var node = AssetNode.new()
	node.value = path if name.is_empty() else name
	node.full_path = path
	if DirAccess.dir_exists_absolute(path):
		node.is_leaf = false
		var dir = DirAccess.open(path)
		for directory in dir.get_directories():
			var sub_path = path + "/" + directory
			node.children.append(AssetNode.from_path(sub_path, directory))
		for file in dir.get_files():
			var sub_path = path + "/" + file
			node.children.append(AssetNode.from_path(sub_path, file))
	return node

func _to_string() -> String:
	if is_leaf:
		return value
	var child_name = func (child: AssetNode) -> String: return child._to_string()
	return value + "(" + ",".join(children.map(child_name)) + ")"
