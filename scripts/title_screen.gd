extends Control

@onready var play_button: Button = $MenuButtons/PlayButton
@onready var options_button: Button = $MenuButtons/OptionsButton
@onready var quit_button: Button = $MenuButtons/QuitButton

func _ready() -> void:
	# Connecter les signaux des boutons
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Mettre le focus sur le premier bouton
	play_button.grab_focus()

func _on_play_pressed() -> void:
	Global.difficulty = "normal"
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_options_pressed() -> void:
	Global.difficulty = "random"
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
