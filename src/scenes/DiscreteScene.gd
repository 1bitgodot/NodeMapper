extends "res://scenes/DescreteScene_vars.gd"

func _ready() -> void:
#	NodeMapper.export_vars("res://scenes/DescreteScene_vars.gd", self)
	btnClear.connect("pressed", self, "on_btnClear_pressed")

func on_btnClear_pressed() -> void:
	txtContent.text = ""
	txtContent.emit_signal("text_changed")
	txtContent.grab_focus()
