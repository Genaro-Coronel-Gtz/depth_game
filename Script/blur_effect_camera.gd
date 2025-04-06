extends Camera3D

@onready var attrs := CameraAttributesPhysical.new()

func _ready():
	print(" se ejecuta el attrs de capture camera ")
	attributes = attrs

	# Establece la distancia al plano de enfoque (en unidades del mundo 3D)
	attrs.frustum_focus_distance = 5.0
	# Controla la fuerza del desenfoque: entre más pequeño el número, más desenfoque
	attrs.exposure_aperture = 0.2

	# Longitud focal (zoom): afecta cuánto cambia la profundidad de campo
	attrs.frustum_focal_length = 50.0  # en mm, típicamente entre 35 - 85

	# Establece los límites del frustum (opcional)
	attrs.frustum_near = 1
	attrs.frustum_far = 20

	# Asigna los atributos físicos a la cámara
	self.attributes = attrs
