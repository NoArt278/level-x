extends Interactable

@export var button_color : Color = Color.RED
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var the_button: MeshInstance3D = $TheButton

func _ready() -> void:
	can_interact = true
	var button_material = the_button.mesh.material.duplicate()
	button_material.albedo_color = button_color
	the_button.mesh.material = button_material

func _interact() -> void :
	animation_player.play("interact")
	target.callv(target_method, params)
