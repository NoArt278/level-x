extends Interactable

var level_manager: Node3D

func _ready() -> void:
	if get_tree().current_scene.name == "LevelManager" :
		print("main scene")
		level_manager = $"../../.."
	target = get_tree().get_first_node_in_group("targets")

func _interact() -> void :
	target.callv(target_method, params)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Ball" :
		_interact()
		level_manager.add_advance_level()
		GameManager.maze_finish_count += 1
	elif body.name.contains("Player") :
		get_tree().change_scene_to_file("res://scenes/finish.tscn")
