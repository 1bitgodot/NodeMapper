# NodeMapper
Godot plugin to map nodes to variables

## How to use

The following image shows a sample scene tree. In the scene script, declare variables for the nodes that you wish to access, even if those nodes are in a sub-scene. However all node names must be unique except for those in discrete scenes. __NodeMapper__ will report an error when more than one node tries to map to the same variable. Discrete scene node names must be prefixed with the _$_ character. In the root scene where the variables reside, call __map_nodes()__ function in __NodeMapper__ to assign the nodes to those variables. This operation must be done in the __\_ready()__ function before accessing node variables.

![Scene Tree](https://raw.githubusercontent.com/1bitgodot/NodeMapper/main/res/scene_tree.png?token=APHSK4AW3BDV7SH5IMSDXITASY6AU)

```gdscript
# res://scenes/Main.gd
extends Panel

var lblVersion
var txtName
var btnClear
var btnSave
var DiscreteScene

func _ready():
	NodeMapper.map_nodes(self)
```

Once __map_nodes()__ function returns, you can access the nodes through the variables. If you get a __null__ error, check to make sure the variable and node name is exactly the same. For discrete nodes, the variable name will be the node name but without the _$_ character prefix. __NodeMapper__ does not map the children of discrete nodes but can still map the discrete node itself. This allows sub-scenes to perform their own mapping. The parent scene can still access the children nodes through variables in the sub-scenes once they are mapped. Node names will not need to be unique across discrete scenes. 

```gdscript
func _ready():
	NodeMapper.map_nodes(self)
	DiscreteScene.txtContent.connect("text_changed", self, "on_txtContent_changed")
	btnClear.connect("pressed", self, "on_btnClear_pressed")
	lblVersion.text = NodeMapper.VERSION
	txtName.grab_focus()

func on_btnClear_pressed() -> void:
	txtName.text = ""
	txtName.grab_focus()

func on_txtContent_changed() -> void:
	btnSave.disabled = DiscreteScene.txtContent.text == ""
```

Each scene that has its own mapping can be instanced in a parent scene as discrete. By prefixing the node name with _$_ character, __NodeMapper__ will not attempt to map the nodes in the scene to variables in the root scene. The root scene can still access the nodes through the variables in the discrete scene.

```gdscript
# res://scenes/DiscreteScene.gd
extends PanelContainer

var txtContent
var btnClear

func _ready() -> void:
	NodeMapper.map_nodes(self)
	btnClear.connect("pressed", self, "on_btnClear_pressed")

func on_btnClear_pressed() -> void:
	txtContent.text = ""
	txtContent.emit_signal("text_changed")
	txtContent.grab_focus()
```

## Exporting variables

Scanning through the scene tree to map nodes to variables can be time consuming especially when you have a large and complex scene tree. While __NodeMapper__ is essential during development, we can remove its use in production by first exporting the mapped variables. Call __export_vars()__ function instead of __map_nodes()__ to export the mapping to an external script.

```gdscript
func _ready():
	NodeMapper.export_vars("res://scenes/Main_vars.gd", self)
	DiscreteScene.txtContent.connect("text_changed", self, "on_txtContent_changed")
	btnClear.connect("pressed", self, "on_btnClear_pressed")
	lblVersion.text = NodeMapper.VERSION
	txtName.grab_focus()
 ```
 
 The following shows the content of the exported file.

```gdscript
# res://scenes/Main_vars.gd
extends Panel

onready var lblVersion: Label = get_node("Examples/SameScene/lblVersion")
onready var txtName: LineEdit = get_node("Examples/SubScene/Form/txtName")
onready var btnClear: Button = get_node("Examples/SubScene/Form/btnClear")
onready var btnSave: Button = get_node("Examples/SubScene/Form/btnSave")
onready var DiscreteScene: PanelContainer = get_node("Examples/$DiscreteScene")
```

You can now remove the variables from the scene script and inherit instead them from the exported file. Once your scene tree is stabilized, you can remark off the __export_vars()__ statement. Make sure to re-export if you make changes to your scene tree that includes the name and position of existing nodes or adding new nodes that require variable mapping. If you change the _base type_ of your root scene node, you must also update the _base node type_ in the export file.

```gdscript
# res://scenes/Main.gd
extends "res://scenes/Main_vars.gd"

func _ready():
#	NodeMapper.export_vars("res://scenes/Main_vars.gd", self)
	DiscreteScene.txtContent.connect("text_changed", self, "on_txtContent_changed")
	btnClear.connect("pressed", self, "on_btnClear_pressed")
	lblVersion.text = NodeMapper.VERSION
	txtName.grab_focus()

func on_btnClear_pressed() -> void:
	txtName.text = ""
	txtName.grab_focus()

func on_txtContent_changed() -> void:
	btnSave.disabled = DiscreteScene.txtContent.text == ""
```
 
```gdscript
# res://scenes/DiscreteScene.gd
extends "res://scenes/DescreteScene_vars.gd"

func _ready() -> void:
#	NodeMapper.export_vars("res://scenes/DescreteScene_vars.gd", self)
	btnClear.connect("pressed", self, "on_btnClear_pressed")

func on_btnClear_pressed() -> void:
	txtContent.text = ""
	txtContent.emit_signal("text_changed")
	txtContent.grab_focus()
```
