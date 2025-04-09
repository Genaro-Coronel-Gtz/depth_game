extends Marker3D

# Configuración para el temblor
var shake_duration: float = 0.5
var shake_strength: float = 0.1
var shake_frequency: int = 10  # Número de sacudidas

@export var SHAKE_PHOGOTRAPHED = false

func _ready():
	if GlobalPosition:
		GlobalPosition.connect("shake", Callable(self, "start_shake"))

# Método para iniciar el temblor
func start_shake():
	if not SHAKE_PHOGOTRAPHED:
		return
		
	# Creamos el tween usando create_tween()	
	var tween = create_tween()

	# Guardamos la posición original del nodo
	var original_position = position

	# Aplicamos el temblor con un for loop (simulamos varias sacudidas)
	for i in range(shake_frequency):
		# Calculamos una posición aleatoria para el temblor
		var shake_offset = Vector3(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
		# Animamos la posición para simular el temblor en el eje X, Y, Z
		tween.tween_property(self, "position", original_position + shake_offset, shake_duration / shake_frequency)
		await get_tree().create_timer(shake_duration / shake_frequency)  # Esperamos un poco entre cada movimiento

	# Restauramos la posición original después del temblor
	position = original_position
