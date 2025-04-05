extends CanvasLayer

@onready var old_cam_layer : TextureRect = $Control/TextureRect
var shader_material : ShaderMaterial

func _init_blur_configs():
	var blur_shader = load("res://Shaders/old_camera.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = blur_shader
	old_cam_layer.material = shader_material
	old_cam_layer.visible = true
	print(" old cam visible")
	
func _ready() -> void:
	_init_blur_configs()
