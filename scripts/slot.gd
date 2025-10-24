extends TextureRect


var ingredient_name: String = ""

func can_drop_data(_pos, data):
	return data.has("name")

func drop_data(_pos, data):
	texture = data["texture"]
	ingredient_name = data["name"]
