extends Interactable

@export var target : InteractTarget
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _interact() -> void :
	animation_player.play("interact")
	target._on_trigger()
