extends Interactable

@export var target : Node
@export var target_method : String
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	can_interact = true

func _interact() -> void :
	animation_player.play("interact")
	target.call(target_method)
