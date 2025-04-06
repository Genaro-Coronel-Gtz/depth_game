extends CanvasLayer

var camera: Camera3D
@onready var near: Label = $Control/PanelContainer/Panel/Label2
@onready var far: Label = $Control/PanelContainer/Panel/Label3
@onready var can_shoot: Label = $Control/PanelContainer/Panel/Label4
@onready var target_lbl: Label = $Control/PanelContainer/Panel/Label5

func _ready() -> void:
	near.visible = false
	far.visible = false
	can_shoot.visible = false
	target_lbl.visible = false
	
	if GlobalPosition:
		GlobalPosition.connect("set_current_camera", Callable(self, "_set_current_camera"))
		GlobalPosition.connect("set_can_shoot", Callable(self, "_can_shoot"))
		GlobalPosition.connect("set_player_position", Callable(self, "_set_player_position"))
		
func _set_player_position(pos: Vector3):
	if GlobalPosition and GlobalPosition.current_target:
		target_lbl.visible = true
		var distance_to_target = pos.distance_to(GlobalPosition.current_target.global_transform.origin)
		target_lbl.text = "Target Distance: " + "%0.2f" % distance_to_target
	else:
		target_lbl.visible = false

func _can_shoot(can: bool) -> void:
	can_shoot.visible = can
	can_shoot.text = "¡You Can shoot!"

func _set_current_camera(cam: Camera3D):
	var attrs = cam.attributes
	if cam and attrs:
		if "dof_blur_near_distance" in attrs and "dof_blur_far_distance" in attrs:
			#print("near distance: ", attrs.dof_blur_near_distance)
			#print("far distance: ", attrs.dof_blur_far_distance)
			near.visible = true
			far.visible = true
			near.text = "Near " + str(attrs.dof_blur_near_distance)
			far.text = "Far: " + str(attrs.dof_blur_far_distance)
	else:
		near.visible = false
		far.visible = false
		# print("Camara sin DOF")
