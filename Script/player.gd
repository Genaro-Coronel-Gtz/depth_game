extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 4
var mouse_sensitivity = 0.00050

@export var jump_velocity = 6.0
@onready var capture_camera: Camera3D = $CaptureCamera
@onready var target: CSGPrimitive3D = null
@onready var timer = $Timer

var capture_camera_active = false
var NEAR_DISTANCE : float = 0
var FAR_DISTANCE : float = 0
const COLLISION_MASK_OBSTACLES = 1
var target_id = null
var current_target_photographed :bool = false

func _config_limits() -> void:
	NEAR_DISTANCE = capture_camera.attributes.dof_blur_near_distance
	FAR_DISTANCE = capture_camera.attributes.dof_blur_far_distance

func _ready() -> void:
	_config_limits()
	if GlobalPosition:
		GlobalPosition.connect("set_nearest_target", Callable(self, "_set_current_target"))
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func is_visible_to_player():
	var space_state = get_world_3d().direct_space_state
	
	var ray_origin = global_transform.origin
	var ray_target = target.global_transform.origin
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target)
	query.collision_mask = COLLISION_MASK_OBSTACLES
	
	var ground = get_node("/root/Node/Prototipo/Ground")
	query.exclude = [self.get_rid(), ground.get_rid()]
	
	var result = space_state.intersect_ray(query)
	
	if result:
		return result["collider"] == target
	else:
		return true
	

func _check_distance():
	GlobalPosition.update_player_position(position)
	if target and capture_camera_active:
		var target_position = target.global_transform.origin
		if capture_camera.is_position_in_frustum(target_position):
			var distance = global_transform.origin.distance_to(target_position)
			if distance >= NEAR_DISTANCE  and distance <= FAR_DISTANCE:
				if is_visible_to_player():
					_is_target_photographed()
					GlobalPosition.update_can_shoot(true)
				else:
					GlobalPosition.update_can_shoot(false)
			else:
				GlobalPosition.update_can_shoot(false)
		else:
			GlobalPosition.update_can_shoot(false)
	else:
		GlobalPosition.update_can_shoot(false)
			#print(" Esta visible ", target.name, "distance ", distance)


func _set_current_target(current_target: CSGPrimitive3D):
	target = current_target
	target_id = current_target.get_meta("id")

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
		_check_distance()
		_shoot_cam()

func _toggle_cam():
	if not capture_camera_active:
		capture_camera.current = true
		GlobalPosition.set_camera(capture_camera)
	else:
		$Camera3D.current = true
		GlobalPosition.set_camera($Camera3D)
		GlobalPosition.update_can_shoot(false)

	capture_camera_active = !capture_camera_active

func _on_timer_timeout():
	GlobalPosition.update_photos()

func directory_exists(path: String) -> void:
	var dir = DirAccess.open("user://")
	if dir == null:
		push_error("No se pudo acceder a user://")
		return

	if not dir.dir_exists(path):
		var result = dir.make_dir(path)
		if result == OK:
			print("Directorio creado: user://%s" % path)
		else:
			push_error("No se pudo crear el directorio: %s (código: %s)" % [path, result])

func _is_target_photographed() -> void:
	var photos_phat = Photos.load()
	var current_tphoto_path = "user://screen_shots/obj_" + target_id + ".png" 
	if current_tphoto_path in photos_phat:
		GlobalPosition.update_object_photographed(true)
		current_target_photographed = true
	else:
		GlobalPosition.update_object_photographed(false)
		current_target_photographed = false

func _shoot_cam():
	if GlobalPosition.can_shoot:
		directory_exists("screen_shots")
		if current_target_photographed:
			return
			
		timer.start(0.5)
		await RenderingServer.frame_post_draw
		var image = null

		image = capture_camera.get_viewport().get_texture().get_image()
		
		var timestamp = Time.get_datetime_string_from_system().replace(":", "-")
		var path = "user://screen_shots/obj_" + target_id + ".png"
		var err = image.save_png(path)
		if err == OK:
			print(" Captura guardada en: ", path)
		else:
			print(" Error al guardar imagen: ", err)
	else:
		print("No puedes tomar la foto, no esta en foco!")

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
	
	_check_distance()
	move_and_slide()
