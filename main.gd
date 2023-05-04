extends Control

var player_window_scene = preload("res://Players.tscn")
var player_window
var tree: AssetNode = null

@onready var search_bar = $MarginContainer/VBoxContainer/HBoxContainer2/Searchbar
@onready var directory_dialog = $FileDialog
@onready var tree_widget = $MarginContainer/VBoxContainer/HBoxContainer/TreeView
@onready var preview_widget = $MarginContainer/VBoxContainer/HBoxContainer/ImagePreview

func _ready():
	spawn_players_window()


func spawn_players_window():
	player_window = player_window_scene.instantiate()
	get_viewport().set_embedding_subwindows(false)
	add_child(player_window)
	player_window.visible = true


func show_image(path: String):
	var image = Image.load_from_file(path)
	var texture = ImageTexture.create_from_image(image)
	preview_widget.show_image(texture, path.get_file())
	player_window.image.texture = texture


func _on_button_pressed():
	directory_dialog.visible = true


func _on_select_directory(dir):
	tree = AssetNode.from_path(dir)
	tree_widget.show_tree(tree)


func _on_filter(value):
	if tree == null:
		return
	tree_widget.show_tree(tree.get_subtree(value))
