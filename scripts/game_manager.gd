extends Node

var level : int = 0
var room_count : int = 1
var maze_size : int = 8
var maze_finish_count : int = 1
var skip_count : int = 0
var rotate_room : bool = false
var ball_fell : bool = false
var bgm : AudioStreamPlayer3D
var enter_door_sound : AudioStreamPlayer3D
var high_score_level : int = 0
var fastest_time : float = INF
var survived : bool = false
const FOUR_LOOP = preload("res://assets/sounds/four_loop.mp3")
const DOOR_ENTER = preload("res://assets/sounds/DoorEnter.wav")

func _ready() -> void:
	bgm = AudioStreamPlayer3D.new()
	enter_door_sound = AudioStreamPlayer3D.new()
	add_child(bgm)
	add_child(enter_door_sound)
	bgm.stream = FOUR_LOOP
	bgm.autoplay = true
	bgm.play()
	enter_door_sound.stream = DOOR_ENTER
	if FileAccess.file_exists("user://1000_save.save") :
		var save_file = FileAccess.open("user://1000_save.save", FileAccess.READ)
		for i in range(3) :
			if save_file.get_position() < save_file.get_length() :
				var json_string = save_file.get_line()
				print(json_string)
				var json = JSON.new()
				var parse_res = json.parse(json_string)
				if parse_res == OK :
					if i == 0 :
						high_score_level = json.data["highest_level"]
					elif i == 1 :
						fastest_time = json.data["fastest_time"]
					else :
						survived = json.data["survived"]

func start_bgm() -> void :
	bgm.play()

func stop_bgm() -> void :
	bgm.stop()

func advance_level(amount: int, tp_hostile_maze : bool) -> void :
	if tp_hostile_maze :
		get_tree().change_scene_to_file("res://scenes/hostile_maze.tscn")
	else : 
		level += amount
		room_count += 1
		var save_file = FileAccess.open("user://1000_save.save", FileAccess.WRITE)
		if level > high_score_level :
			high_score_level = level
			save_file.store_line(JSON.stringify({"highest_level" : high_score_level}))
		if level >= 1000 :
			var curr_time = Time.get_ticks_msec()
			if fastest_time > curr_time :
				save_file.store_line(JSON.stringify({"fastest_time" : curr_time}))
			stop_bgm()
			get_tree().change_scene_to_file("res://scenes/finish.tscn")
		else :
			enter_door_sound.play()
			get_tree().call_deferred("reload_current_scene")
