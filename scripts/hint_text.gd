extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.room_count == 1 :
		mesh.text = "Get the ball\n to the\n yellow goal"
	elif GameManager.room_count == 2 : 
		mesh.text = "Reach level\n 1000\n to win"
	else :
		mesh.text = ""
