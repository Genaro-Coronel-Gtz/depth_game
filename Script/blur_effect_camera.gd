extends Camera3D

@onready var attrs := CameraAttributesPractical.new()

func _ready():
	# Activamos el desenfoque cercano
	attrs.dof_blur_near_enabled = true
	
	attrs.dof_blur_near_distance = 3.0  # A partir de aquí empieza el enfoque
	#attrs.dof_blur_near_transition = 1.0  # Transición suave desde 1.5m antes

	# Activamos el desenfoque lejano
	attrs.dof_blur_far_enabled = true
	attrs.dof_blur_far_distance = 5.0  # A partir de aquí empieza el desenfoque lejano
	#sattrs.dof_blur_far_transition = 1.0  # Transición de enfoque hasta 9m

	# Intensidad del desenfoque
	attrs.dof_blur_amount = 0.5  # Puedes subirlo si deseas un efecto más fuerte

	self.attributes = attrs

#esto es para que se enfoque de acuerdo a una posicion que se le envia (target.global_position)
#y la posicion actual de la camara
#var focus_distance = global_position.distance_to(target.global_position)
#self.dof_blur_far_distance = lerp(self.dof_blur_far_distance, focus_distance, delta * 5.0)
#self.dof_blur_near_distance = lerp(self.dof_blur_near_distance, focus_distance * 0.5, delta * 5.0)
