extends Node

@onready var World: Node3D = $Prototipo
@onready var UI : CanvasLayer = $UI
@onready var Widgets: CanvasLayer = $Widgets
@onready var StartButton: Button = $UI/Control/PanelContainer/Panel/Button

# Targets
@onready var target_box := $Prototipo/CSGBox3D
@onready var target_cilinder := $Prototipo/CSGCylinder3D
@onready var player := $Prototipo/Player

var targets : Array = []

func _get_nearset_object():
	var closest_distance = INF
	var closest_target = null
	
	# Recorremos todos los targets y calculamos la distancia más cercana
	for target in targets:
		var target_position = target.global_transform.origin
		var player_position = player.global_transform.origin
		var distance_to_target = player_position.distance_to(target_position)
			
		if distance_to_target < closest_distance:
			closest_distance = distance_to_target
			closest_target = target

		if closest_target:
			#print("El target más cercano es:", closest_target.name)
			GlobalPosition.update_target(closest_target)

func _process(delta: float) -> void:
	_get_nearset_object()

func _ready() -> void:
	targets = [target_box, target_cilinder]
	World.visible = false
	Widgets.visible = false
	UI.visible = true
	StartButton.pressed.connect(_on_boton_pressed)
	
func _on_boton_pressed():
	UI.visible = false
	World.visible = true
	Widgets.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("open_ui"):
		UI.visible = true
		World.visible = false
		Widgets.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
