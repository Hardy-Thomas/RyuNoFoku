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
@onready var phone_feedback = $UI/dialog
var current_guess := []

func _ready():
	setup_shelf()
	setup_board()


func setup_shelf():
	for ing in INGREDIENTS:
		var icon = preload("res://scenes/ingredient_icon.tscn").instantiate()
		icon.texture = load(ing.picture)
		icon.ingredient_name = ing.name
		icon.custom_minimum_size = Vector2(64, 64)
		icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
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

func _on_texture_button_pressed() -> void:
	var guess = ""
	for slot in board.get_children():
		if slot is TextureRect and slot.ingredient_name != "":
			current_guess.append(slot.ingredient_name)
			guess = guess + " and " + slot.ingredient_name

	phone_feedback.display(guess)
	print("Recette proposée :", guess)
