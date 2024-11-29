extends Node

var level : int = 0
var room_count : int = 1
var maze_size : int = 8
var maze_finish_count : int = 1
var skip_count : int = 0
var rotate_room : bool = false
var ball_fell : bool = false

func advance_level(amount: int, tp_hostile_maze : bool) -> void :
	level += amount
	room_count += 1
	if level >= 1000 :
		get_tree().change_scene_to_file("res://scenes/finish.tscn")
	else :
		if tp_hostile_maze :
			get_tree().change_scene_to_file("res://scenes/hostile_maze.tscn")
		else :
			get_tree().call_deferred("reload_current_scene")
