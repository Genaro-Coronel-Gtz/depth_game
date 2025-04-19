extends CanvasLayer

var camera: Camera3D
@onready var can_shoot :Label = $Control/PanelContainer/Panel/CanShootLabel
@onready var main_timer :Timer = $MainTimer
@onready var main_timer_label :Label = $Control/PanelContainer/Panel/MainTimerLabel
@onready var counter_photos: Label = $Control/PanelContainer/Panel/CounterPhotosLabel

@export var show_mini_seconds: bool = 1

var capture_camera_active = false
var is_current_target_photographed: bool = false
var can_shoot_lbl_txt :String = ""

var time_left: float = 120.0

func _timer_init():
	main_timer.one_shot = true
	main_timer.wait_time = time_left
	main_timer.start()
	
func _main_timer_time_out():
	print(" Finish time ")
	GlobalPosition.update_finish_game(true)
	
func update_label_timer():
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	var ms = int((time_left - int(time_left)) * 100)

	if show_mini_seconds:
		main_timer_label.text = "%02d:%02d.%02d" % [minutes, seconds, ms]
	else:
		main_timer_label.text = "%02d:%02d" % [minutes, seconds]
	

func _tick_timer(_delta):
	if main_timer.is_stopped():
		return
		
	time_left -= _delta
	if time_left < 0:
		time_left = 0
	
	update_label_timer()

func _process(_delta):
	_tick_timer(_delta)

func _ready() -> void:
	_timer_init()
	_set_photos_number(1)
	can_shoot.visible = false
	
	if GlobalPosition:
		GlobalPosition.connect("set_current_camera", Callable(self, "_set_current_camera"))
		GlobalPosition.connect("set_can_shoot", Callable(self, "_can_shoot"))
		GlobalPosition.connect("set_player_position", Callable(self, "_set_player_position"))
		GlobalPosition.connect("set_is_photographed", Callable(self, "_set_is_photographed"))
		GlobalPosition.connect("set_photos_number", Callable(self, "_set_photos_number"))
		
func _set_photos_number(number: int) -> void:
	#print(" llego a set photos ", number)
	counter_photos.text = "Photos: " + str(number)
	
		
func _set_player_position(pos: Vector3):
	if capture_camera_active and GlobalPosition and GlobalPosition.current_target:
		var distance_to_target = pos.distance_to(GlobalPosition.current_target.global_transform.origin)

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
			capture_camera_active = true
	else:
		capture_camera_active = false
		can_shoot.visible = false
