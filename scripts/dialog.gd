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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
  

func _on_button_pressed() -> void:

	close()
