extends Interactable

func _ready() -> void:
	can_interact = false
	target = %Door

func _interact() -> void :
	target_method = "_on_level_finish"
	target.callv(target_method, params)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name.contains("Ball") :
		_interact()
