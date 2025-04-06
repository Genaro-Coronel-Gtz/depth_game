extends Node

signal set_nearest_target(target: CSGPrimitive3D)
var current_target : CSGPrimitive3D = null

func update_target(target: CSGPrimitive3D):
	current_target = target
	emit_signal("set_nearest_target", target)
