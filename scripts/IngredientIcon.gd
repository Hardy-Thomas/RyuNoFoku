extends TextureRect

@export var ingredient_name: String

func _ready():
	# CRITIQUE : MOUSE_FILTER_STOP pour le drag
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(64, 64)
	expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL

func _get_drag_data(_at_position):
	print("Début du drag pour: ", ingredient_name)
	
	var drag_data = {
		"name": ingredient_name, 
		"texture": texture,
		"type": "ingredient"
	}
	
	# Créer un preview
	var preview = TextureRect.new()
	preview.texture = texture
	preview.custom_minimum_size = Vector2(48, 48)
	preview.size = Vector2(48, 48)
	preview.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	
	set_drag_preview(preview)
	
	print("🚀 Drag data créé: ", drag_data)
	return drag_data
