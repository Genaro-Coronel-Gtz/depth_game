extends Node

@onready var World: Node3D = $Prototipo
@onready var UI : CanvasLayer = $UI
@onready var Widgets: CanvasLayer = $WidgetsUI
@onready var DialogueUI: CanvasLayer = $DialogueUI
@onready var MenuUI: CanvasLayer = $MenuUI
@onready var FinishGameUI: CanvasLayer = $FinishGameUI

@onready var StartButton: Button = $UI/Control/PanelContainer/Panel/StartButton
@onready var ResumeButton: Button = $MenuUI/PanelContainer/Panel/Resume
@onready var MainMenuButton: Button = $FinishGameUI/Control/PanelContainer/Panel/MainMenuBtn

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
			GlobalPosition.update_target(closest_target)

func _process(delta: float) -> void:
	_get_nearset_object()
	
func _reset_game():
	print(" Reset game on main.gd ")
	GlobalPosition.update_photos()
	GlobalPosition.update_can_shoot(false)
	GlobalPosition.update_photos_number(0)
	GlobalPosition.update_object_photographed(false)
	_init_main_screen()

func _ready() -> void:
	_set_targets()
	_init_ui()
	
	if UI:
		UI.connect("reset_game", Callable(self, "_reset_game"))
	if GlobalPosition:
		GlobalPosition.connect("set_finish_game", Callable(self, "_finish_game"))
		
func _finish_game() -> void:
	print(" Finish game in main.gd")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	UI.visible = false
	World.visible = false
	Widgets.visible = false
	MenuUI.visible = false
	FinishGameUI.visible = true

func _set_targets() -> void:
	target_box.set_meta("id", "box_model")
	target_cilinder.set_meta("id", "cilinder_model")
	targets = [target_box, target_cilinder]
	
	
func _init_main_screen():
	World.visible = false
	Widgets.visible = false
	DialogueUI.visible = false
	MenuUI.visible = false
	FinishGameUI.visible = false
	UI.visible = true
	
func _init_ui():
	_init_main_screen()
	StartButton.pressed.connect(_start_game)
	ResumeButton.pressed.connect(_resume_game)
	MainMenuButton.pressed.connect(_init_main_screen)
	
func _start_intro():
	World.visible = false
	Widgets.visible = false
	UI.visible = false
	MenuUI.visible = false
	DialogueUI.visible = true
	FinishGameUI.visible = false
	var gui = DialogueUI
	gui.show_dialogue_sequence(
		[
			"¡Hola! Bienvenido a la aventura.",
			"Tu misión será explorar este mundo misterioso.",
			"Cuando estés listo... ¡comencemos!"
		],
		func _start():
			_start_game()
	)
	
func _resume_game():
	get_tree().paused = false
	_start_game()

func _start_game():
	UI.visible = false
	World.visible = true
	Widgets.visible = true
	MenuUI.visible = false
	FinishGameUI.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


	
func _show_menu():
	UI.visible = false
	World.visible = false
	Widgets.visible = false
	MenuUI.visible = true
	FinishGameUI.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event):
	if event.is_action_pressed("menu_ui"):
		#get_tree().paused = true
		_show_menu()
