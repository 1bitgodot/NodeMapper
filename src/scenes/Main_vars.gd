extends Panel

onready var lblVersion: Label = get_node("Examples/SameScene/lblVersion")
onready var txtName: LineEdit = get_node("Examples/SubScene/Form/txtName")
onready var btnClear: Button = get_node("Examples/SubScene/Form/btnClear")
onready var btnSave: Button = get_node("Examples/SubScene/Form/btnSave")
onready var DiscreteScene: PanelContainer = get_node("Examples/$DiscreteScene")
