extends TextureRect

@export var ingredient_name: String

func _ready():
	# CRITIQUE : MOUSE_FILTER_STOP pour le drag
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(64, 64)
	expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	
	# Ajouter le name tag permanent sur l'image statique
	setup_static_name_tag()

func setup_static_name_tag():
	# Créer un label pour le name tag permanent
	var name_label = Label.new()
	name_label.text = ingredient_name
	name_label.name = "StaticNameTag"
	
	# Style du label
	name_label.add_theme_font_size_override("font_size", 10)
	name_label.add_theme_color_override("font_color", Color.WHITE)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Fond semi-transparent pour le name tag statique
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0, 0, 0, 0.6)  # Fond noir semi-transparent
	stylebox.corner_radius_top_left = 4
	stylebox.corner_radius_top_right = 4
	stylebox.corner_radius_bottom_left = 4
	stylebox.corner_radius_bottom_right = 0
	stylebox.border_width_bottom = 1
	stylebox.border_color = Color.GOLD
	name_label.add_theme_stylebox_override("normal", stylebox)
	
	## Position en bas de l'icon - taille adaptée
	#name_label.size = Vector2(self.size.x, 16)
	#name_label.position = Vector2(0, self.size.y - 16)
	
	add_child(name_label)

func _get_drag_data(_at_position):
	print("Début du drag pour: ", ingredient_name)
	
	var drag_data = {
		"name": ingredient_name, 
		"texture": texture,
		"type": "ingredient"
	}
	
	# Taille FIXE pour le preview (ajustez selon vos besoins)
	var preview_size = Vector2(58, 58)
	
	# Créer un TextureRect pour l'image
	var texture_rect = TextureRect.new()
	texture_rect.texture = texture
	texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	# Créer un Control parent pour FORCER la taille
	var preview_container = Control.new()
	preview_container.custom_minimum_size = preview_size
	preview_container.size = preview_size
	preview_container.rotation = deg_to_rad(-5)
	
	# Ajouter le TextureRect au container et le centrer
	preview_container.add_child(texture_rect)
	texture_rect.size = preview_size
	texture_rect.position = Vector2.ZERO
	
	# Ajouter le name tag au preview de drag
	var drag_name_label = Label.new()
	drag_name_label.text = ingredient_name
	drag_name_label.add_theme_font_size_override("font_size", 9)
	drag_name_label.add_theme_color_override("font_color", Color.WHITE)
	drag_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	drag_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Style pour le name tag du drag
	var drag_stylebox = StyleBoxFlat.new()
	drag_stylebox.bg_color = Color(0, 0, 0, 0.7)
	drag_stylebox.corner_radius_top_left = 3
	drag_stylebox.corner_radius_top_right = 3
	drag_stylebox.corner_radius_bottom_left = 4
	drag_stylebox.corner_radius_bottom_right = 4
	drag_name_label.add_theme_stylebox_override("normal", drag_stylebox)
	
	drag_name_label.size = Vector2(preview_size.x, 14)
	drag_name_label.position = Vector2(0, preview_size.y - 26)
	
	preview_container.add_child(drag_name_label)
	
	set_drag_preview(preview_container)
	
	print("🚀 Drag data créé avec taille: ", preview_size)
	return drag_data
