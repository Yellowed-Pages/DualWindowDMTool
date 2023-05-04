extends VBoxContainer

@onready var texture_rectangle = $TextureRect
@onready var label_widget = $Label

func show_image(texture: Texture, title: String = ""):
	texture_rectangle.texture = texture
	label_widget.text = title
