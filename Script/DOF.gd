extends Camera3D

@export var target_path: NodePath
var target: Node3D
var camera_attributes: CameraAttributesPractical

func _ready():
	# Obtener el objetivo (por ejemplo, una esfera)
	target = get_node_or_null(target_path)
	
	# Crear y asignar atributos de cámara
	camera_attributes = CameraAttributesPractical.new()
	self.camera_attributes = camera_attributes

	# Activar el DOF
	#enable_dof()

func _process(delta):
	if target and camera_attributes:
		var distance = global_position.distance_to(target.global_position)
		
		# Ajustar el enfoque dinámicamente
		camera_attributes.dof_blur_far_distance = lerp(camera_attributes.dof_blur_far_distance, distance, delta * 5.0)
		camera_attributes.dof_blur_near_distance = lerp(camera_attributes.dof_blur_near_distance, distance * 0.5, delta * 5.0)

func enable_dof():
	# Activar desenfoque lejano
	camera_attributes.dof_blur_far_enabled = true
	camera_attributes.dof_blur_far_distance = 10.0
	camera_attributes.dof_blur_far_transition = 5.0
	
	# Activar desenfoque cercano
	camera_attributes.dof_blur_near_enabled = true
	camera_attributes.dof_blur_near_distance = 2.0
	camera_attributes.dof_blur_near_transition = 2.0
	
	# Intensidad general del desenfoque
	camera_attributes.dof_blur_amount = 0.6
