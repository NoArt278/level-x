extends Node

var level = 0
var room_count = 1
var maze_size = 8
var maze_finish_count = 1
var skip_count = 0

func advance_level(amount: int) -> void :
	level += amount
	room_count += 1
	if level >= 1000 :
		var is_finished = true
