extends Interactable

var level_manager: Node3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	if get_tree().current_scene.name == "LevelManager" :
		print("main scene")
		level_manager = $"../../.."
	target = get_tree().get_first_node_in_group("targets")

func _interact() -> void :
	if target : 
		target.callv(target_method, params)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Ball" :
		_interact()
		level_manager.add_advance_level()
		GameManager.maze_finish_count += 1
		if audio_stream_player_3d.playing : 
			audio_stream_player_3d.stop()
		audio_stream_player_3d.play()
	elif body.name.contains("Player") :
		if audio_stream_player_3d.playing : 
			audio_stream_player_3d.stop()
		audio_stream_player_3d.play()
		get_tree().change_scene_to_file("res://scenes/survived.tscn")
