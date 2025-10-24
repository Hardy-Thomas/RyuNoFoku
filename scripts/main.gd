extends Node2D

const INGREDIENTS = [
	{"name": "ChickenBroth", "picture": "res://picture/ingredient/ChickenBroth.png"},
	{"name": "VegetableBroth", "picture": "res://picture/ingredient/VegetableBroth.png"},
	{"name": "PorkBroth", "picture": "res://picture/ingredient/PorkBroth.png"},
	{"name": "Tare", "picture": "res://picture/ingredient/Tare.png"},
	{"name": "ScentedOil", "picture": "res://picture/ingredient/ScentedOil.png"},
	{"name": "PickledEggs", "picture": "res://picture/ingredient/PickledEggs.png"},
	{"name": "Menma", "picture": "res://picture/ingredient/Menma.png"},
	{"name": "Chashu", "picture": "res://picture/ingredient/Chashu.png"},
	{"name": "RiceNoodles ", "picture": "res://picture/ingredient/RiceNoodles.png"},
	{"name": "WheatNoodles ", "picture": "res://picture/ingredient/WheatNoodles.png"},
	{"name": "SpringOnions", "picture": "res://picture/ingredient/SpringOnions.png"},
	{"name": "NoriSheets", "picture": "res://picture/ingredient/NoriSheets.png"},
	{"name": "Narutomaki", "picture": "res://picture/ingredient/Narutomaki.png"}
]

var secret = ["PorkBroth", "Tare", "ScentedOil", "PickledEggs", "Menma", "Chashu", "WheatNoodles", "SpringOnions", "NoriSheets", "Narutomaki"]


# Références UI
@onready var shelf = $UI/IngredientsShelf
@onready var board = $UI/RecipeBoard
@onready var feedback = $UI/Feedback
@onready var validate_button = $UI/Valider

var current_guess := []

func _ready():
	setup_shelf()
	setup_board()
	position_board_bottom()
	validate_button.pressed.connect(on_validate)


func setup_shelf():
	if shelf is HBoxContainer:
		convert_to_grid_container(shelf)
	
	for ing in INGREDIENTS:
		var icon = preload("res://scenes/ingredient_icon.tscn").instantiate()
		icon.texture = load(ing.picture)
		icon.ingredient_name = ing.name
		icon.custom_minimum_size = Vector2(64, 64)
		shelf.add_child(icon)


func setup_board():
	# Vide le board au cas où
	for child in board.get_children():
		child.queue_free()
	
	for i in range(secret.size()):
		var slot = preload("res://scenes/slot.tscn").instantiate()
		
		# Configuration critique
		slot.custom_minimum_size = Vector2(64, 64)
		slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		board.add_child(slot)
		print("Slot ", i, " créé - Parent: ", slot.get_parent().name)

func position_board_bottom():
	# Positionnement plus robuste
	var screen_size = get_viewport().get_visible_rect().size
	board.position = Vector2(0, screen_size.y - 100)
	board.size = Vector2(screen_size.x, 80)


func convert_to_grid_container(container):
	var grid = GridContainer.new()
	grid.name = container.name
	
	# Configuration du GridContainer
	grid.columns = 11  # Nombre d'éléments par ligne
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	
	# Remplacer l'ancien container
	var parent = container.get_parent()
	var index = container.get_index()
	
	parent.remove_child(container)
	parent.add_child(grid)
	parent.move_child(grid, index)
	
	# Mettre à jour la référence
	if container == shelf:
		shelf = grid
	elif container == board:
		board = grid
	
	container.queue_free()


func on_validate():
	var guess = []
	for slot in board.get_children():
		guess.append(slot.ingredient_name)
	print("Recette proposée :", guess)
