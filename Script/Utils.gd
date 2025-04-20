extends Object
class_name Utils

static func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		print("Error al cargar el archivo de configuración.")
		return
	
	var language = config.get_value("general", "language", "en") # valor por defecto "en"
	var total_photos = config.get_value("general", "total_photos", 0)
	var settings = {
		"language": language,
		"total_photos": total_photos
	}

	GlobalPosition.update_settings(settings)
	return settings
	
