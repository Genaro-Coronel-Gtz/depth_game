extends Node

signal set_nearest_target(target: CSGPrimitive3D)
signal set_current_camera(camera: Camera3D)
signal set_can_shoot(can: bool)
signal set_player_position(player_position: Vector3)
signal set_update_photos
signal set_is_photographed(photographed: bool)
signal set_lang()
signal shake()

var current_target: CSGPrimitive3D = null
var current_camera: Camera3D = null
var can_shoot: bool = false
var player_position: Vector3

func update_target(target: CSGPrimitive3D):
	current_target = target
	emit_signal("set_nearest_target", target)

func set_camera(camera: Camera3D):
	current_camera = camera
	emit_signal("set_current_camera", camera)
	
func update_can_shoot(can : bool):
	can_shoot = can
	emit_signal("set_can_shoot", can)
	
func update_player_position(pos: Vector3):
	player_position = pos
	emit_signal("set_player_position", pos)

func update_photos():
	emit_signal("set_update_photos")
	
func update_object_photographed(photographed: bool):
	emit_signal("set_is_photographed", photographed)
	
func update_lang() -> void:
	emit_signal("set_lang")
	
func update_shake() -> void:
	emit_signal("shake")
