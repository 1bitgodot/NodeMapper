extends Panel

var lblVersion
var txtName
var btnClear
var btnSave
var DiscreteScene

func _ready():
	var vars = NodeMapper.map_nodes(self)
	NodeMapper.export_vars("res://scenes/Main_vars.gd", self, vars)
	DiscreteScene.txtContent.connect("text_changed", self, "on_txtContent_changed")
	btnClear.connect("pressed", self, "on_btnClear_pressed")
	lblVersion.text = NodeMapper.VERSION
	txtName.grab_focus()

func on_btnClear_pressed() -> void:
	txtName.text = ""
	txtName.grab_focus()

func on_txtContent_changed() -> void:
	btnSave.disabled = DiscreteScene.txtContent.text == ""
