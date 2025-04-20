extends Object
class_name Photos

const path_photos = "user://screen_shots/"

static func delete_png_files():
	var dir = DirAccess.open(path_photos)
	
	if dir == null:
		push_error("No se pudo abrir el directorio: " + path_photos)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".png"):
			var file_path = path_photos + file_name
			var error = dir.remove(file_path)
			if error != OK:
				push_error("No se pudo eliminar el archivo: " + file_path)
			else:
				print("Archivo eliminado:", file_path)
		file_name = dir.get_next()

	dir.list_dir_end()


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
		
	var photos_number = archivos_imagenes.size()
	GlobalPosition.update_photos_number(photos_number)
	
	return archivos_imagenes
	
