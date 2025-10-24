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
	{"name": "WheatNoodles", "picture": "res://picture/ingredient/WheatNoodles.png"},
	{"name": "SpringOnions", "picture": "res://picture/ingredient/SpringOnions.png"},
	{"name": "NoriSheets", "picture": "res://picture/ingredient/NoriSheets.png"},
	{"name": "Narutomaki", "picture": "res://picture/ingredient/Narutomaki.png"}

]

var secret = ["PorkBroth", "Tare", "ScentedOil", "PickledEggs", "Menma", "Chashu", "SpringOnions", "NoriSheets", "Narutomaki","WheatNoodles"]


# Références UI
@onready var shelf = $UI/IngredientsShelf
@onready var board = $UI/RecipeBoard
@onready var feedback = $UI/Feedback
@onready var validate_button = $UI/Valider
@onready var phone_feedback = $UI/dialog
var current_guess := []

func _ready():
	setup_shelf()
	setup_board()
	
	
	position_board_bottom()





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
