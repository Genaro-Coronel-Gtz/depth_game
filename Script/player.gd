extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 4
var mouse_sensitivity = 0.00050

@export var jump_velocity = 6.0
@onready var capture_camera: Camera3D = $CaptureCamera

var capture_camera_active = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		
		capture_camera.rotate_x(-event.relative.y * mouse_sensitivity)
		capture_camera.rotation.x = clampf(capture_camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		
	if event.is_action_pressed("change_cam"):
		_toggle_cam()
		
	if event.is_action_pressed("shoot_cam"):
		_shoot_cam()

func _toggle_cam():
	
	if capture_camera_active:
		capture_camera.current = true
	else:
		$Camera3D.current = true

	capture_camera_active = !capture_camera_active

func _shoot_cam():
	await RenderingServer.frame_post_draw
	
	var image = null
	
	#image = $Camera3D.get_viewport().get_texture().get_image()
	image = capture_camera.get_viewport().get_texture().get_image()
	
	#if capture_camera_active:
		#image = old_cam_layer.get_viewport().get_texture().get_image()
	#else:
		#image = capture_subviewport.get_viewport().get_texture().get_image()
		
	var timestamp = Time.get_datetime_string_from_system().replace(":", "-")
	var path = "res://screen_shots/captura_" + timestamp + ".png"
	
	var err = image.save_png(path)
	
	if err == OK:
		print(" Captura guardada en: ", path)
	else:
		print(" Error al guardar imagen: ", err)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += -gravity * delta
	else:
		# Si estamos en el suelo y se presiona espacio
		if Input.is_action_just_pressed("jump"):
			velocity.y =jump_velocity
	
	
	var input = Input.get_vector("Left", "Right", "Forward", "Backward")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)

	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	
	move_and_slide()
