extends InteractTarget

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var door: MeshInstance3D = $"."

func _on_trigger() -> void :
	if not(door.visible) :
		door.visible = true
		animation_player.play("spawn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player" :
		get_tree().call_deferred("reload_current_scene")
