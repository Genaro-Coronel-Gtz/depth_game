extends CanvasLayer
@onready var container = $PanelContainer/Panel/MarginContainer
@onready var message = $PanelContainer/Panel/Label3
@onready var photosLbl = $PanelContainer/Panel/Label2


func _update_ui() -> void:
	photosLbl.text = tr("photos")

func _render_photos():
	var routes = Photos.load()
	
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
	_render_photos()

func _ready():
	#pause_mode = Node.PROCESS_MODE_ALWAYS
	if GlobalPosition:
		GlobalPosition.connect("set_update_photos", Callable(self, "_update_photos"))
		GlobalPosition.connect("set_lang", Callable(self, "_update_ui"))
	_render_photos()
	_update_ui()
