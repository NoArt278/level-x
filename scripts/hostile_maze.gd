extends GridMap

const MAZE_SIZE = 32
const FLOOR_IDX = 0
const WALL_IDX = 1
const FINISH_IDX = 2
const CELL_SIZE = 4
var dirs = [Vector3i.RIGHT, Vector3i.FORWARD, Vector3i.LEFT, Vector3i.BACK]
@onready var player: CharacterBody3D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_maze()

func generate_maze() -> void:
	# Spawn maze
	# Generate walls
	var curr_coord = Vector3i(MAZE_SIZE/2 * -1 -1, 0, MAZE_SIZE/2 + 1)
	for dir in dirs :
		for i in range(MAZE_SIZE + 2) :
			set_cell_item(curr_coord, WALL_IDX)
			curr_coord += dir
	# Generate maze using DFS
	curr_coord = Vector3i(randi_range(MAZE_SIZE/2 * -1, MAZE_SIZE/2), 0, randi_range(MAZE_SIZE/2 * -1, MAZE_SIZE/2))
	if curr_coord.x % 2 != 0 and curr_coord.y % 2 != 0 : 
		curr_coord += Vector3i(randi_range(-1, 1), 0, randi_range(-1,1))
		curr_coord = Vector3i(max(MAZE_SIZE/2 * -1, curr_coord.x), 0, max(MAZE_SIZE/2 * -1, curr_coord.z))
		curr_coord = Vector3i(min(MAZE_SIZE/2, curr_coord.x), 0, min(MAZE_SIZE/2, curr_coord.z))
	set_cell_item(curr_coord, FLOOR_IDX)
	for i in range(MAZE_SIZE/2 * -1, MAZE_SIZE/2) :
		for j in range(MAZE_SIZE/2 * -1, MAZE_SIZE/2) :
			if i % 2 != 0 and j % 2 != 0 :
				set_cell_item(Vector3i(i,0,j), WALL_IDX)
	var open_coords = [curr_coord]
	var start_coord = curr_coord
	var visited = []
	var is_backtrack = false
	var last_floor_coord = start_coord
	player.position = map_to_local(start_coord) + Vector3i.UP * 0.2
	player.call_deferred("reparent", $"..")
	while not(open_coords.is_empty()) :
		curr_coord = open_coords.pop_front()
		if visited.has(curr_coord) or get_cell_item(curr_coord) == WALL_IDX :
			continue
		visited.push_front(curr_coord)
		set_cell_item(curr_coord, FLOOR_IDX)
		if last_floor_coord.distance_to(start_coord) < curr_coord.distance_to(start_coord) :
			last_floor_coord = curr_coord
		dirs.shuffle()
		var new_path_found = false
		for dir in dirs :
			if not(visited.has(curr_coord + dir)) and get_cell_item(curr_coord + dir) != WALL_IDX :
				new_path_found = true
				open_coords.push_front(curr_coord + dir)
		if not(new_path_found) :
			set_cell_item(curr_coord, WALL_IDX)
	if last_floor_coord == start_coord :
		# Regenerate maze
		generate_maze()
	else : 
		set_cell_item(last_floor_coord, FINISH_IDX)
