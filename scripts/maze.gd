extends GridMap

@export var maze_size = 16
const FLOOR_IDX = 0
const WALL_IDX = 1
const FINISH_IDX = 2
const CELL_SIZE = 0.2
var dirs = [Vector3i.RIGHT, Vector3i.DOWN, Vector3i.LEFT, Vector3i.UP]
@onready var ball: RigidBody3D = %Ball
const MAZE_FINISH = preload("res://scenes/maze_finish.tscn")
var rotate_tween
var target_angle = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Spawn maze
	# Generate walls
	var curr_coord = Vector3i(maze_size/2 * -1 -1, maze_size/2 + 1, 0)
	for dir in dirs :
		for i in range(maze_size + 2) :
			set_cell_item(curr_coord, WALL_IDX)
			curr_coord += dir
	# Generate maze using DFS
	curr_coord = Vector3i(randi_range(maze_size/2 * -1, maze_size/2), randi_range(maze_size/2 * -1, maze_size/2), 0)
	if curr_coord.x % 2 != 0 and curr_coord.y % 2 != 0 : 
		curr_coord += Vector3i(randi_range(-1, 1), randi_range(-1,1), 0)
		curr_coord = Vector3i(max(maze_size/2 * -1, curr_coord.x), max(maze_size/2 * -1, curr_coord.y), 0)
		curr_coord = Vector3i(min(maze_size/2, curr_coord.x), min(maze_size/2, curr_coord.y), 0)
	set_cell_item(curr_coord, FLOOR_IDX)
	for i in range(maze_size/2 * -1, maze_size/2) :
		for j in range(maze_size/2 * -1, maze_size/2) :
			if i % 2 != 0 and j % 2 != 0 :
				set_cell_item(Vector3i(i,j,0), WALL_IDX)
	var open_coords = [curr_coord]
	var visited = []
	var is_backtrack = false
	var last_floor_coord = curr_coord
	ball.position = map_to_local(curr_coord) + Vector3i.BACK * 0.05
	ball.call_deferred("reparent", $"..")
	while not(open_coords.is_empty()) :
		curr_coord = open_coords.pop_front()
		if visited.has(curr_coord) or get_cell_item(curr_coord) == WALL_IDX :
			continue
		visited.push_front(curr_coord)
		set_cell_item(curr_coord, FLOOR_IDX)
		last_floor_coord = curr_coord
		dirs.shuffle()
		var new_path_found = false
		for dir in dirs :
			if not(visited.has(curr_coord + dir)) and get_cell_item(curr_coord + dir) != WALL_IDX :
				new_path_found = true
				open_coords.push_front(curr_coord + dir)
		if not(new_path_found) :
			set_cell_item(curr_coord, WALL_IDX)
	position.y = CELL_SIZE * maze_size
	set_cell_item(last_floor_coord, FINISH_IDX)
	var maze_finish_area = MAZE_FINISH.instantiate()
	add_child(maze_finish_area)
	maze_finish_area.position = map_to_local(last_floor_coord)

func rotate_maze(angle : float) -> void:
	if rotate_tween :
		rotate_tween.kill()
	target_angle += angle
	rotate_tween = create_tween()
	rotate_tween.tween_property(self, "rotation_degrees", Vector3(0,0, target_angle), 1)
	await rotate_tween.finished
