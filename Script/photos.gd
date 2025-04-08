extends Object
class_name Photos

const path_photos = "user://screen_shots/"

static func load() -> Array:
	var archivos_imagenes: Array = []
	var dir = DirAccess.open(path_photos)
	if dir:
		dir.list_dir_begin()
		var archivo = dir.get_next()
		while archivo != "":
			if not dir.current_is_dir() and archivo.ends_with(".png"):
				archivos_imagenes.append(path_photos + archivo)
			archivo = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("No se pudo abrir el directorio: " + path_photos)
	return archivos_imagenes
	
