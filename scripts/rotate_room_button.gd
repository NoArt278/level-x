extends InteractButton

func _ready() -> void:
	super()
	if GameManager.rotate_room : 
		button_color = Color("#FFFFFF")
	else :
		button_color = Color("#333333")
	button_material.albedo_color = button_color

func _interact() -> void:
	if button_sound.playing :
		button_sound.stop()
	button_sound.play()
	target.callv(target_method, params)
	if GameManager.rotate_room : 
		button_color = Color("#FFFFFF")
	else :
		button_color = Color("#333333")
	button_material.albedo_color = button_color
