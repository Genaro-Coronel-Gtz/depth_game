extends CanvasLayer
@onready var select = $Control/PanelContainer/Panel/OptionButton

@onready var StartButton = $Control/PanelContainer/Panel/StartButton
@onready var ResetButton = $Control/PanelContainer/Panel/ResetButton

signal reset_game()

func _reset_game() -> void:
	Photos.delete_png_files()
	emit_signal("reset_game")
	ResetButton.visible = false
	StartButton.visible = true
	

func _ready() -> void:
	await RenderingServer.frame_post_draw
	
	select.add_item("Español")
	select.add_item("English")
	select.item_selected.connect(_on_option_selected)
	TranslationServer.set_locale("es")
	ResetButton.pressed.connect(_reset_game)
	_render_ui()
	if GlobalPosition:
		GlobalPosition.connect("set_finish_game", Callable(self, "_render_ui"))
	
func _update_ui() -> void:
	StartButton.text = tr("start")
	GlobalPosition.update_lang()

func _render_ui() -> void:
	var total_photos_taken = GlobalPosition.photos_number
	
	if total_photos_taken >= 2:
		ResetButton.visible = true
		StartButton.visible = false
	else:
		ResetButton.visible = false
		StartButton.visible = true
		
	_update_ui()
	
func _on_option_selected(index) -> void:
	var texto = select.get_item_text(index)
	match texto:
		"Español":
			TranslationServer.set_locale("es")
		"English":
			TranslationServer.set_locale("en")
	_update_ui()
