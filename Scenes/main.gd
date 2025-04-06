extends Node

@onready var World: Node3D = $Prototipo
@onready var UI : CanvasLayer = $CanvasLayer
@onready var StartButton: Button = $CanvasLayer/Control/PanelContainer/Panel/Button

func _ready() -> void:
	World.visible = false
	UI.visible = true
	StartButton.pressed.connect(_on_boton_pressed)
	

func _on_boton_pressed():
	UI.visible = false
	World.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("open_ui"):
		UI.visible = true
		World.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
