extends VBoxContainer

# Vitesse de défilement en pixels par seconde
var scroll_speed : float = 50.0

func _process(delta):
	# Déplacer le container vers le haut
	position.y -= scroll_speed * delta
	
	# Quand tout le texte est sorti, revenir au menu
	if position.y + size.y < -650:
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
