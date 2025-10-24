extends TextureRect


@export var ingredient_name: String

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP

func _get_drag_data(at_position):
	var drag_data = {"name": ingredient_name, "texture": texture}
	
	var preview = TextureRect.new()
	preview.texture = texture
	preview.scale = Vector2(0.75, 0.75)
	set_drag_preview(preview)
	
	return drag_data
