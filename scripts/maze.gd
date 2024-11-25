extends GridMap

@export var maze_size = 16
const FLOOR_IDX = 0
const WALL_IDX = 1
const CELL_SIZE = 0.2
const dirs = [Vector3i.RIGHT, Vector3i.DOWN, Vector3i.LEFT, Vector3i.UP]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Spawn maze
	# Generate walls
	var curr_coord = Vector3i(maze_size/2 * -1, maze_size/2, 0)
	for dir in dirs :
		for i in range(maze_size) :
			set_cell_item(curr_coord, WALL_IDX)
			curr_coord += dir
	# Generate maze using DFS
	curr_coord = Vector3i(randi_range(maze_size/2 * -1 + 1, maze_size/2 -1), randi_range(maze_size/2 * -1 + 1, maze_size/2 -1), 0)
	if curr_coord.x % 2 != 0 and curr_coord.y % 2 != 0 : 
		curr_coord += Vector3i(randi_range(-1, 1), randi_range(-1,1), 0)
		curr_coord = Vector3i(max(maze_size/2 * -1 + 1, curr_coord.x), max(maze_size/2 * -1 + 1, curr_coord.y), 0)
		curr_coord = Vector3i(min(maze_size/2 -1, curr_coord.x), min(maze_size/2 -1, curr_coord.y), 0)
	set_cell_item(curr_coord, FLOOR_IDX)
	# Generate walls randomly
	#for i in range(maze_size/2 * -1 + 1, maze_size/2) :
		#for j in range(maze_size/2 * -1 + 1, maze_size/2) :
			#if randf_range(0, 100) < 10 :
				#set_cell_item(Vector3i(i,j,0), WALL_IDX)
	for i in range(maze_size/2 * -1 + 1, maze_size/2) :
		for j in range(maze_size/2 * -1 + 1, maze_size/2) :
			if i % 2 != 0 and j % 2 != 0 :
				set_cell_item(Vector3i(i,j,0), WALL_IDX)
	var open_coords = [curr_coord]
	var visited = []
	var is_backtrack = false
	while not(open_coords.is_empty()) :
		curr_coord = open_coords.pop_front()
		if visited.has(curr_coord) or get_cell_item(curr_coord) == WALL_IDX :
			continue
		visited.push_front(curr_coord)
		set_cell_item(curr_coord, FLOOR_IDX)
		var check_dirs = dirs.duplicate()
		check_dirs.shuffle()
		var new_path_found = false
		for dir in check_dirs :
			if not(visited.has(curr_coord + dir)) and get_cell_item(curr_coord + dir) != WALL_IDX :
				new_path_found = true
				open_coords.push_front(curr_coord + dir)
		if not(new_path_found) :
			set_cell_item(curr_coord, WALL_IDX)
	position.y = CELL_SIZE * maze_size

#func check_avail_dir(curr_coord : Vector3i) -> Array :
	#var avail_dirs = [0,0,0,0]
	#for i in range(dirs.size()) :
		#if get_cell_item(curr_coord + dirs[i]) == FLOOR_IDX : # Found floor in dirs[i] direction
			#avail_dirs[i] = 1 
		#elif get_cell_item(curr_coord + dirs[i]) == WALL_IDX : # Found wall in dirs[i] direction
			#avail_dirs[i] = 2 
	#return avail_dirs
