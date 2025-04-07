extends CanvasLayer
@onready var container = $PanelContainer/Panel/MarginContainer
@onready var message = $PanelContainer/Panel/Label3
#@onready var grid = $PanelContainer/Panel/MarginContainer/GridContainer

func load_photos_directory(ruta: String) -> Array:
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
	var path_photos = "user://screen_shots/"
	var routes = load_photos_directory(path_photos)
	print(" Se ejecuta de nuevo load photos #: ", routes.size())
	if routes.size() > 0:
		container.visible = true
		message.visible = false
		
		for child in container.get_children():
			container.remove_child(child)
			child.queue_free()
		
		var grid := GridContainer.new()
		grid.columns = 7
		grid.add_theme_constant_override("h_separation", 50)

		for route in routes:  # Ajusta este número a la cantidad de imágenes que quieras cargar
			var tex := TextureRect.new()
			
			var image = Image.new()
			var err = image.load(route)
			
			if err == OK:
				var texture = ImageTexture.create_from_image(image)
				tex.texture = texture
				# tex.texture = load(route)
				tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				tex.custom_minimum_size = Vector2(200, 200)
				tex.expand = true
				grid.add_child(tex)
			else:
				print("No se pudo cargar la imagen: %s" % err)
				
				
		container.add_child(grid)
			
	else:
		container.visible = false
		message.visible = true
		message.text = "No tienes fotos aun"

func _update_photos():
	_load_photos()
	#grid.get_parent().queue_redraw()
	

func _ready():
	if GlobalPosition:
		GlobalPosition.connect("set_update_photos", Callable(self, "_update_photos"))
	_load_photos()
