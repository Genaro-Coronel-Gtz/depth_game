extends CanvasLayer

signal rest_dialogue

@onready var dialogue_label = $PanelContainer/Panel/MarginContainer/VBoxContainer/DialogueLabel
@onready var options_container = $PanelContainer/Panel/MarginContainer/VBoxContainer/OptionsContainer
@onready var dialogue_panel = $PanelContainer/Panel
@onready var vBoxContainer = $PanelContainer/Panel/MarginContainer/VBoxContainer
@onready var cooldown_timer = Timer.new()

@export var bg_color: Color

var margin_offset: int = 20
var border_radius: int = 20
var dialogue_size: Vector2 = Vector2(400, 200)
var margin_offset_vector: Vector2 = Vector2(margin_offset, margin_offset)

var dialogue_open = false
var can_trigger_dialogue = true

# 🎬 Variables para diálogo secuencial
var dialogue_lines: Array = []
var current_line_index: int = 0
var end_action: Callable

# ⌨️ Variables para máquina de escribir
var full_text: String = ""
var typing_speed := 0.02  # Velocidad entre letras
var typing_timer := Timer.new()
var current_char_index := 0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_dialogue()

	add_child(cooldown_timer)
	cooldown_timer.wait_time = 2.0
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_reset_dialogue_trigger)

	# Timer para máquina de escribir
	typing_timer.wait_time = typing_speed
	typing_timer.one_shot = false
	typing_timer.timeout.connect(_type_next_character)
	add_child(typing_timer)

# 📜 Mostrar diálogo con varias líneas
func show_dialogue_sequence(lines: Array, on_complete: Callable):
	if lines.is_empty():
		return

	dialogue_lines = lines
	current_line_index = 0
	end_action = on_complete

	_show_current_line()

# 🖊️ Mostrar línea actual con efecto máquina de escribir
func _show_current_line():
	if current_line_index >= dialogue_lines.size():
		hide_dialogue()
		if end_action != null:
			end_action.call()
		return

	dialogue_open = true
	can_trigger_dialogue = false
	dialogue_panel.visible = true
	visible = true

	# Preparar texto
	full_text = dialogue_lines[current_line_index]
	dialogue_label.text = ""
	current_char_index = 0

	options_container.hide()
	for child in options_container.get_children():
		child.queue_free()

	typing_timer.start()

	_styleish_dialogue()

# ⌨️ Mostrar cada letra progresivamente
func _type_next_character():
	if current_char_index < full_text.length():
		dialogue_label.text += full_text[current_char_index]
		current_char_index += 1
	else:
		typing_timer.stop()
		_show_accept_button()

# ➡️ Mostrar botón aceptar cuando termina el texto
func _show_accept_button():
	var accept_button = Button.new()
	accept_button.text = "Aceptar"
	accept_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	accept_button.connect("pressed", Callable(self, "_on_next_dialogue_line"))
	options_container.add_child(accept_button)
	options_container.show()

# ⏭️ Avanza al siguiente diálogo
func _on_next_dialogue_line():
	current_line_index += 1
	_show_current_line()

# 🧼 Ocultar diálogo
func hide_dialogue():
	dialogue_open = false
	rest_dialogue.emit()
	visible = false
	dialogue_panel.visible = false

# 🔁 Reset
func _reset_dialogue_trigger():
	can_trigger_dialogue = true

# 🎨 Estilo visual
func _styleish_dialogue():
	var style = StyleBoxFlat.new()
	style.bg_color = bg_color
	style.corner_radius_top_left = border_radius
	style.corner_radius_top_right = border_radius
	style.corner_radius_bottom_left = border_radius
	style.corner_radius_bottom_right = border_radius
	style.expand_margin_left = margin_offset
	style.expand_margin_right = margin_offset
	style.expand_margin_top = margin_offset
	style.expand_margin_bottom = margin_offset

	dialogue_panel.add_theme_stylebox_override("panel", style)
	dialogue_panel.custom_minimum_size = dialogue_size

	var viewport_size = get_viewport().get_visible_rect().size
	dialogue_panel.position = (viewport_size - dialogue_panel.size - margin_offset_vector) / 2
