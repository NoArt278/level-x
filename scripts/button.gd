extends Interactable

@export var button_color : Color = Color.RED
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var the_button:  = $TheButton

func _ready() -> void:
	can_interact = true
	if the_button :
		var button_material = the_button.mesh.material.duplicate()
		button_material.albedo_color = button_color
		the_button.mesh.material = button_material

func _interact() -> void :
	if animation_player :
		if animation_player.is_playing() :
			animation_player.stop()
		animation_player.play("interact")
	target.callv(target_method, params)
