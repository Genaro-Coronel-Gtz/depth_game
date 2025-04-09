extends CanvasLayer
@onready var select = $Control/PanelContainer/Panel/OptionButton
@onready var btnStart = $Control/PanelContainer/Panel/Button

func _ready() -> void:
	select.add_item("Español")
	select.add_item("English")
	select.item_selected.connect(_on_option_selected)
	TranslationServer.set_locale("es")
	
func _update_ui() -> void:
	btnStart.text = tr("start")
	GlobalPosition.update_lang()

func _init_ui() -> void:
	_update_ui()
	
func _on_option_selected(index) -> void:
	var texto = select.get_item_text(index)
	match texto:
		"Español":
			TranslationServer.set_locale("es")
			print("Español")
		"English":
			TranslationServer.set_locale("en")
			
			print("Ingles")
	_update_ui()
