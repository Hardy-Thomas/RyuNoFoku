extends Node2D

const INGREDIENTS = [
	{"name": "ChickenBroth","category": "Broth", "picture": "res://picture/ingredient/ChickenBroth.png"},
	{"name": "VegetableBroth","category": "Broth", "picture": "res://picture/ingredient/VegetableBroth.png"},
	{"name": "PorkBroth","category": "Broth", "picture": "res://picture/ingredient/PorkBroth.png"},
	{"name": "Tare","category": "Tare", "picture": "res://picture/ingredient/Tare.png"},
	{"name": "ScentedOil","category": "ScentedOil", "picture": "res://picture/ingredient/ScentedOil.png"},
	{"name": "PickledEggs","category": "trim", "picture": "res://picture/ingredient/PickledEggs.png"},
	{"name": "Menma","category": "trim", "picture": "res://picture/ingredient/Menma.png"},
	{"name": "Chashu","category": "trim", "picture": "res://picture/ingredient/Chashu.png"},
	{"name": "RiceNoodles ","category": "Noodles", "picture": "res://picture/ingredient/RiceNoodles.png"},
	{"name": "WheatNoodles","category": "Noodles", "picture": "res://picture/ingredient/WheatNoodles.png"},
	{"name": "SpringOnions","category": "condiment", "picture": "res://picture/ingredient/SpringOnions.png"},
	{"name": "NoriSheets","category": "condiment", "picture": "res://picture/ingredient/NoriSheets.png"},
	{"name": "Narutomaki","category": "condiment", "picture": "res://picture/ingredient/Narutomaki.png"}
]

var secret = ["PorkBroth", "Tare", "ScentedOil", "PickledEggs", "Menma", "Chashu", "SpringOnions", "NoriSheets", "Narutomaki","WheatNoodles"]


# Références UI
@onready var category_dropdown = $UI/IngredientsShelf/CategoryDropdown
@onready var ingredient_dropdown = $UI/IngredientsShelf/IngredientDropdown
@onready var shelf = $UI/IngredientsShelf
@onready var board = $UI/RecipeBoard
@onready var feedback = $UI/Feedback
@onready var validate_button = $UI/Valider
@onready var phone_feedback = $UI/dialog

var current_guess := []
var ingredients_by_category := {}

func _ready():
	print("dificulty :", Global.difficulty)
	test_difficulty()
	organize_ingredients_by_category()
	setup_dropdowns()
	setup_board()
	position_board_bottom()
	validate_button.pressed.connect(on_validate)
	
	# SUPPRIMER la connexion du bouton Add et utiliser directement le dropdown
	ingredient_dropdown.item_selected.connect(on_ingredient_selected)
	
	# Créer les icons initiaux
	update_shelf_icons()

func organize_ingredients_by_category():
	ingredients_by_category = {}
	for ingredient in INGREDIENTS:
		var category = ingredient["category"]
		if not ingredients_by_category.has(category):
			ingredients_by_category[category] = []
		ingredients_by_category[category].append(ingredient)

func setup_dropdowns():
	# Setup category dropdown
	category_dropdown.clear()
	var categories = ingredients_by_category.keys()
	categories.sort()
	
	for category in categories:
		category_dropdown.add_item(category.capitalize())
	
	# Connect signal
	category_dropdown.item_selected.connect(on_category_selected)
	
	# Setup initial ingredient dropdown
	update_ingredient_dropdown(0)

func on_category_selected(index):
	update_ingredient_dropdown(index)
	update_shelf_icons()

func update_ingredient_dropdown(category_index):
	ingredient_dropdown.clear()
	
	var categories = ingredients_by_category.keys()
	categories.sort()
	var selected_category = categories[category_index]
	var ingredients = ingredients_by_category[selected_category]
	
	for ingredient in ingredients:
		ingredient_dropdown.add_item(ingredient["name"])

func on_ingredient_selected(index):
	# Quand un ingrédient est sélectionné dans le dropdown, créer l'icon directement
	var category_index = category_dropdown.selected
	var categories = ingredients_by_category.keys()
	categories.sort()
	var selected_category = categories[category_index]
	var ingredients = ingredients_by_category[selected_category]
	var selected_ingredient = ingredients[index]
	
	create_ingredient_icon(selected_ingredient)

func update_shelf_icons():
	# Vider la shelf actuelle
	for child in shelf.get_children():
		if child.has_method("_get_drag_data"): # C'est un IngredientIcon
			child.queue_free()
	
	# Créer les icons pour la catégorie actuelle
	var category_index = category_dropdown.selected
	var categories = ingredients_by_category.keys()
	categories.sort()
	var selected_category = categories[category_index]
	var ingredients = ingredients_by_category[selected_category]
	
	for ingredient in ingredients:
		create_ingredient_icon(ingredient)

func create_ingredient_icon(ingredient):
	var icon = preload("res://scenes/ingredient_icon.tscn").instantiate()
	icon.texture = load(ingredient["picture"])
	icon.ingredient_name = ingredient["name"]
	icon.custom_minimum_size = Vector2(64, 64)
	icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	shelf.add_child(icon)
	print("Icon créé: ", ingredient["name"])

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
		slot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
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

func randomize_secret():
	var available_ingredients = INGREDIENTS.duplicate()
	var new_secret = []
	
	var exclusive_categories = ["Broth", "Noodles"]
	var used_categories = {}
	
	var num_ingredients = randi() % (available_ingredients.size() - 5) + 5
	
	while new_secret.size() < num_ingredients and available_ingredients.size() > 0:
		var random_index = randi() % available_ingredients.size()
		var ingredient = available_ingredients[random_index]
		
		var can_add = true
		
		if ingredient["category"] in exclusive_categories:
			if used_categories.has(ingredient["category"]):
				can_add = false
		
		if can_add:
			new_secret.append(ingredient["name"])
			
			if ingredient["category"] in exclusive_categories:
				used_categories[ingredient["category"]] = true
			
			available_ingredients.remove_at(random_index)
		else:
			available_ingredients.remove_at(random_index)
	
	secret = new_secret
	return new_secret

func test_difficulty():
	if Global.difficulty == "random":
		randomize_secret()
		print("secret :", secret)



func validations():
	var guessed_recipe = []
	for slot in board.get_children():
		if slot is TextureRect and slot.ingredient_name != "":
			guessed_recipe.append(slot.ingredient_name)
	var good = 0 #comptabilisation des bons ingrédients
	var score = 0.0
	for ingredient in guessed_recipe:
		if ingredient in secret: 
			score += 1  # bon ingrédient
			good += 1
			print(score)
		else:
			print(ingredient)
			print(secret)
			if " " == ingredient:
				print(" ")
				if not(" " in secret) : 
					print("VOVOOVOVOOVOVOODSFJFGMKSDJGHMLKSDJGFMLKDSMLKGMSLDKGMDSKGMLKSDGMKDSMLGK") 
			score -= 2  # ingrédient mauvais ingrédient
			print("MALUS")

	#MISSING INGREDIENT YOU SUCK LOL
	for ingredient in secret:
		if ingredient not in guessed_recipe:
			print(ingredient)
			score -= 1  # ingrédient manquant 
			print("looser")
		#BON J'AI IMPROVISE LE SCORRING
	print('HAAAAAAAAAAAAAAAa')
	
	print(score)
	print(score/len(secret))
	print(score*5/len(secret))	
	score = score/len(secret)*5

	if score < 0:
		score = 0
		
	print("Score final :", score)
	return [score,good]

func on_validate():
	var guess = []
func _on_texture_button_pressed() -> void:
	var guess = ""
	for slot in board.get_children():
		if slot is TextureRect and slot.ingredient_name != "":
			if guess != "":
				current_guess.append(slot.ingredient_name)
				guess = guess + " and " + slot.ingredient_name
			else:
				guess = "You served a ramen ball with " + slot.ingredient_name
	var score 
	var good
	var valid = validations()
	score = valid[0]
	good = valid[1]
	phone_feedback.display("Anon",guess + "\n You Have got " +str(good) + " ingredients just like your grandmother receipe",score)
	print("Recette proposée :", guess)
