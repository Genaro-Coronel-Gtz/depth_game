extends CanvasLayer

var camera: Camera3D
@onready var near: Label = $Control/PanelContainer/Panel/Label2
@onready var far: Label = $Control/PanelContainer/Panel/Label3
@onready var can_shoot: Label = $Control/PanelContainer/Panel/Label4
@onready var target_lbl: Label = $Control/PanelContainer/Panel/Label5

var capture_camera_active = false
var is_current_target_photographed: bool = false
var can_shoot_lbl_txt :String = ""

func _ready() -> void:
	near.visible = false
	far.visible = false
	can_shoot.visible = false
	target_lbl.visible = false
	
	if GlobalPosition:
		GlobalPosition.connect("set_current_camera", Callable(self, "_set_current_camera"))
		GlobalPosition.connect("set_can_shoot", Callable(self, "_can_shoot"))
		GlobalPosition.connect("set_player_position", Callable(self, "_set_player_position"))
		GlobalPosition.connect("set_is_photographed", Callable(self, "_set_is_photographed"))
		
func _set_player_position(pos: Vector3):
	if capture_camera_active and GlobalPosition and GlobalPosition.current_target:
		target_lbl.visible = true
		var distance_to_target = pos.distance_to(GlobalPosition.current_target.global_transform.origin)
		target_lbl.text = "Target Distance: " + "%0.2f" % distance_to_target
	else:
		target_lbl.visible = false

func _can_shoot(can: bool) -> void:
	can_shoot.visible = can
	var settings := LabelSettings.new()
	settings.font_size = 25
	
	if is_current_target_photographed:
		can_shoot_lbl_txt = tr("already_photographed")
		settings.font_color = Color.html("#b10004")
		can_shoot.label_settings = settings
	else:
		can_shoot_lbl_txt = tr("shoot")
		settings.font_color = Color.html("#97ff93")
		can_shoot.label_settings = settings
	_update_label_texts()

func _update_label_texts():
	can_shoot.text = can_shoot_lbl_txt
	
func _set_is_photographed(photographed: bool):
	is_current_target_photographed = photographed
	
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
			capture_camera_active = true
	else:
		capture_camera_active = false
		near.visible = false
		far.visible = false
		can_shoot.visible = false
		target_lbl.visible = false
		# print("Camara sin DOF")
