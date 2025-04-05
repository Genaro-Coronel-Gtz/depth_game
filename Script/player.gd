extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 4
var mouse_sensitivity = 0.00050

@export var jump_velocity = 6.0
@onready var minimap_rect : TextureRect = $CanvasLayer/Control/TextureRect
@onready var capture_subviewport: SubViewport = $SubViewport
@onready var capture_camera: Camera3D = $SubViewport/CaptureCamera

var capture_camera_active = false

var shader_material : ShaderMaterial
var is_blurred : bool = false

func _init_blur_configs():
	capture_subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var blur_shader = load("res://Shaders/old_camera.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = blur_shader
	#shader_material.set_shader_parameter("blur_size", 1)
	minimap_rect.material = shader_material
	
	minimap_rect.texture = capture_subviewport.get_texture()
	
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_init_blur_configs()
	
func _process(delta) -> void:
	_sync_cameras($Camera3D, capture_camera)

func _sync_cameras(camera_from: Camera3D, camera_to: Camera3D):
	camera_to.global_transform.origin = camera_from.global_transform.origin
	camera_to.global_transform.basis = camera_from.global_transform.basis

	camera_to.fov = camera_from.fov  # Copiar el Field of View (FOV)
	camera_to.near = camera_from.near  # Copiar el near plane
	camera_to.far = camera_from.far  # Copiar el far plane
	
	
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		
		
	if event.is_action_pressed("change_cam"):
		_toggle_cam()
		
	if event.is_action_pressed("shoot_cam"):
		_shoot_cam()

func _toggle_cam():
	print("toggle camera")
	
	_sync_cameras($Camera3D, capture_camera)
	
	if capture_camera_active:
		$Camera3D.current = false
		capture_camera.current = true
		minimap_rect.visible = true
	else:
		$Camera3D.current = true
		capture_camera.current = false
		minimap_rect.visible = false

	capture_camera_active = !capture_camera_active

func _shoot_cam():
	_sync_cameras($Camera3D, capture_camera)
	
	await RenderingServer.frame_post_draw
	
	var image = null
	
	image = minimap_rect.get_viewport().get_texture().get_image()
	#image = capture_subviewport.get_viewport().get_texture().get_image()
	
	#if capture_camera_active:
		#image = minimap_rect.get_viewport().get_texture().get_image()
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
