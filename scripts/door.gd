extends MeshInstance3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var level_manager: Node3D = $".."

func _ready() -> void:
	add_to_group("targets")

func _on_level_finish() -> void :
	if not(visible) :
		visible = true
		animation_player.play("spawn")
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player" :
		level_manager.advance_level()
		get_tree().call_deferred("reload_current_scene")
