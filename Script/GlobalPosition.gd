extends Node

signal set_nearest_target(target: CSGPrimitive3D)
signal set_current_camera(camera: Camera3D)
signal set_can_shoot(can: bool)
signal set_player_position(player_position: Vector3)

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
