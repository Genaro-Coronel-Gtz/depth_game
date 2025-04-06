extends CanvasLayer

@onready var container = $PanelContainer/Panel/MarginContainer

func _load_photos():
	var grid := GridContainer.new()
	grid.columns = 2  # 2 columnas
	grid.add_theme_constant_override("separation", 10)  # Espacio entre imágenes
	var control := Control.new()

	for i in range(4):  # Ajusta este número a la cantidad de imágenes que quieras cargar
		var tex := TextureRect.new()
		tex.texture = load("res://screen_shots/captura_2025-04-06T00-15-55.png")
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex.expand = true
		
		control.add_child(tex)
		print("add ", tex)
	
	grid.add_child(control)
	container.add_child(grid)

func _ready():
	_load_photos()
