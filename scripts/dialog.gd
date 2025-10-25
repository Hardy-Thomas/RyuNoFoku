extends Control

@onready var _customer : Label = $VBoxContainer/Name
@onready var _Grade : Label = $VBoxContainer/Grade
@onready var _Note : Label = $VBoxContainer/Note


func display(Name: String,Line : String = "", Grade : float = -1):
	_customer.text = Name
	_Grade.text = str(Grade) + "/5"
	_Note.text = Line
	open()
func open():
	visible = true
	
func close():
	visible = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func not_matchin_ingredient(liste1: Array, liste2: Array) -> Array:
	var liste3 =[]
	# Renvoie les éléments de liste1 qui ne sont pas dans liste2
	for item in liste1 :
		if not(item in liste2):
			liste3.append(item) 
	return liste3
func get_cat(ingredients: Array, secret: Array, ingredient: String) -> String:
	for item in ingredients:
		if item["name"] == ingredient:
			return item["category"]
	return "Unknown"


func count_cat(cat_list: Array) -> Dictionary:
	var counts: Dictionary = {}
	for cat in cat_list:
		if counts.has(cat):
			counts[cat] += 1
		else:
			counts[cat] = 1
	return counts
# Called every frame. 'delta' is the elapsed time since the previous frame.
func grandma_text(missing_dict: Dictionary) -> String:
	var parts: Array = []
	for k in missing_dict.keys():
		var v = missing_dict[k]
		var name = k if v == 1 else k + "s"
		parts.append(str(v) + " " + name)
	
	var text: String
	if parts.size() > 1:
		text = ", ".join(parts.slice(0, parts.size() - 1)) + " and " + parts[-1]
	else:
		text = parts[0]
	
	return "Your ancient grandma’s recipe called for %s, but it looks like you forgot to add them. " % text


func _on_button_pressed() -> void:

	close()
