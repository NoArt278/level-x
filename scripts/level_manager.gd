extends Node3D

var advance_level_amount : int = 0
var advance_level_per_goal : int = 1
@onready var button: Node3D = $Button
@onready var button_2: Node3D = $Button2

func _ready() -> void:
	advance_level_per_goal += (GameManager.maze_size / 2) - 4

func add_advance_level() :
	advance_level_amount += advance_level_per_goal

func advance_level() :
	GameManager.advance_level(advance_level_amount)
