extends Interactable

@onready var level_manager: Node3D = $"../../.."

func _ready() -> void:
	target = get_tree().get_first_node_in_group("targets")

func _interact() -> void :
	target.callv(target_method, params)

func _on_body_entered(body: Node3D) -> void:
	if body.name.contains("Ball") :
		_interact()
		level_manager.add_advance_level()
