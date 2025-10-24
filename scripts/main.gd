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


func setup_shelf():
	for ing in INGREDIENTS:
		var icon = preload("res://scenes/ingredient_icon.tscn").instantiate()
		icon.texture = load(ing.picture)
		icon.ingredient_name = ing.name
		icon.custom_minimum_size = Vector2(64, 64)
		shelf.add_child(icon)


func setup_board():
	for i in range(secret.size()):
		var slot = preload("res://scenes/slot.tscn").instantiate()
		slot.texture = load("res://picture/empty_slot.png")
		slot.custom_minimum_size = Vector2(64, 64)
		board.add_child(slot)
