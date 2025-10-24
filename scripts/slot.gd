extends TextureRect

var ingredient_name: String = ""

func _ready():
	# CRITIQUE : Ces deux lignes sont ESSENTIELLES
	mouse_filter = Control.MOUSE_FILTER_PASS
	expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	
	custom_minimum_size = Vector2(64, 64)
	
	# Texture vide par défaut
	if texture == null:
		var empty_texture = load("res://picture/empty_slot.png")
		if empty_texture:
			texture = empty_texture
	
	print("Slot initialisé: ", name)

# FONCTION ABSOLUMENT NÉCESSAIRE
func _can_drop_data(_at_position, data):
	print("_can_drop_data appelé, data: ", data)
	return data is Dictionary and data.has("texture")

# FONCTION ABSOLUMENT NÉCESSAIRE  
func _drop_data(_at_position, data):
	print("_drop_data appelé!")
	if data is Dictionary and data.has("texture"):
		texture = data["texture"]
		ingredient_name = data["name"]
		print("Ingredient déposé: ", ingredient_name)
