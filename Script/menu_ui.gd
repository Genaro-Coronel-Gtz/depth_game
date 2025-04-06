extends CanvasLayer
@onready var container = $PanelContainer/Panel/MarginContainer
@onready var message = $PanelContainer/Panel/Label3

func load_photos(ruta: String) -> Array:
	var archivos_imagenes: Array = []
	var dir = DirAccess.open(ruta)
	if dir:
		dir.list_dir_begin()
		var archivo = dir.get_next()
		while archivo != "":
			if not dir.current_is_dir() and archivo.ends_with(".png"):
				archivos_imagenes.append(ruta + archivo)
			archivo = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("No se pudo abrir el directorio: " + ruta)
	return archivos_imagenes

func _load_photos():
	var path_photos = "res://screen_shots/"
	var routes = load_photos(path_photos)
	if routes.size() > 0:
		container.visible = true
		message.visible = false
		var grid := GridContainer.new()
		grid.columns = 4  # 2 columnas
		grid.add_theme_constant_override("h_separation", 50)  # Espacio entre imágenes

		for route in routes:  # Ajusta este número a la cantidad de imágenes que quieras cargar
			var tex := TextureRect.new()
			tex.texture = load(route)
			tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tex.custom_minimum_size = Vector2(200, 200)
			tex.expand = true
			
			grid.add_child(tex)

		container.add_child(grid)
	else:
		container.visible = false
		message.visible = true
		message.text = "No tienes fotos aun"
		print(" NO TIENES NINGUNA FOTO AUN ")

func build_image(url: String) -> TextureRect:
	var imagen = TextureRect.new()
	imagen.texture = load(url)
	#imagen.expand_mode = TextureRect.EXPAND_KEEP_ASPECT_CENTERED
	imagen.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	imagen.custom_minimum_size = Vector2(100, 100)
	return imagen

func _ready():
	_load_photos()
