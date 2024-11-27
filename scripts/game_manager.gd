extends Node

var level = 0
var maze_size = 8

func advance_level(amount: int) -> void :
	level += amount
	if level >= 1000 :
		var is_finished = true
