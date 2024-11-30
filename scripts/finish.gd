extends Node3D


func restart() -> void : 
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
