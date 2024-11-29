extends Node3D

var advance_level_amount : int = 0
var advance_level_per_goal : int = 1
var advance_level_multiplier : int = 1
@onready var button: Interactable = $Room/Button
@onready var button_2: Interactable = $Room/Button2
@onready var button_3: Interactable = $Room/Button3
@onready var door: MeshInstance3D = %Door

func _ready() -> void:
	advance_level_per_goal += (GameManager.maze_size / 2) - 4
	if GameManager.rotate_room : 
		button.target = $Room
		button_2.target = $Room
		button.target_method = "rotate_room"
		button_2.target_method = "rotate_room"
		advance_level_multiplier *= 2
	else :
		button.target = $Room/Maze
		button_2.target = $Room/Maze
		button.target_method = "rotate_maze"
		button_2.target_method = "rotate_maze"

func add_advance_level() :
	advance_level_amount += advance_level_per_goal

func advance_level(tp_hostile_maze : bool) :
	if tp_hostile_maze :
		advance_level_amount = 0
	GameManager.advance_level(advance_level_amount * advance_level_multiplier, tp_hostile_maze)

func set_rotate_room() : 
	GameManager.rotate_room = not(GameManager.rotate_room)

func _on_skip_timer_timeout() -> void:
	var skip_spawn_tween = button_3.create_tween()
	skip_spawn_tween.tween_property(button_3, "position", Vector3(button_3.position.x, 0.749, button_3.position.z), 1.5)


func _on_ball_body_entered(body: Node) -> void:
	var body_parent_name = body.get_parent().name
	if body_parent_name.contains("Wall") or body_parent_name.contains("Floor") or body_parent_name.contains("Ceiling") :
		door._on_ball_fell()
		GameManager.stop_bgm()
