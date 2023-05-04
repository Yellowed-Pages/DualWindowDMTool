extends Control

var player_window_scene = preload("res://Players.tscn")
var player_window
var tree: AssetNode = null

@onready var search_bar = $MarginContainer/HBoxContainer/VBoxContainer2/Searchbar
@onready var directory_dialog = $FileDialog
@onready var file_tree = $MarginContainer/HBoxContainer/VBoxContainer2/Tree
@onready var preview = $MarginContainer/HBoxContainer/VBoxContainer/TextureRect

func _ready():
	spawn_players_window()


func spawn_players_window():
	player_window = player_window_scene.instantiate()
	get_viewport().set_embedding_subwindows(false)
	add_child(player_window)
	player_window.visible = true


func show_image(path):
	var image = Image.load_from_file(path)
	var texture = ImageTexture.create_from_image(image)
	preview.texture = texture
	player_window.image.texture = texture


func _on_button_pressed():
	directory_dialog.visible = true


func _on_select_directory(dir):
	tree = AssetNode.from_path(dir)
	file_tree.clear()
	draw_tree(null, tree)


func _on_filter(value):
	if tree == null:
		return
	file_tree.clear()
	var subtree = tree.get_subtree(value)
	draw_tree(null, subtree)


func draw_tree(file_subtree, subtree: AssetNode):
	if subtree == null:
		return
	var root = file_tree.create_item(file_subtree)
	root.set_text(0, subtree.value)
	for child in subtree.children:
		draw_tree(root, child)


func _on_file_selected():
	var node = file_tree.get_selected()
	if not node.get_children().is_empty():
		return
	var path = PackedStringArray([node.get_text(0)])
	while node.get_parent() != null:
		node = node.get_parent()
		path.append(node.get_text(0))
	path.reverse()
	var full_path = "/".join(path)
	show_image(full_path)
