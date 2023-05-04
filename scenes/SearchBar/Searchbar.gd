extends HBoxContainer

signal filter(string: String)

@onready var text_box = $TextEdit
var text: String = ""

func _on_reset():
	text_box.text = ""
	text = ""
	emit_signal("filter", text_box.text)


func _on_text_changed():
	text = text_box.text
	emit_signal("filter", text_box.text)
