extends Interactable

func _ready() -> void:
	can_interact = false
	target = get_tree().get_first_node_in_group("targets")

func _interact() -> void :
	target_method = "_on_level_finish"
	target.callv(target_method, params)

func _on_body_entered(body: Node3D) -> void:
	if body.name.contains("Ball") :
		_interact()
