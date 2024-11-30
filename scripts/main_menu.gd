extends Control

@onready var right_button_timer: Timer = $RightButtonTimer
@onready var left_button_timer: Timer = $LeftButtonTimer
@onready var button: InteractButton = $"../Room/Button"
@onready var button_2: InteractButton = $"../Room/Button2"
@onready var title: RichTextLabel = $Title
@onready var fastest_time: RichTextLabel = $FastestTime
@onready var survived_text: RichTextLabel = $SurvivedText

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GameManager.start_bgm()
	right_button_timer.wait_time = randf_range(0.7, 3.0)
	left_button_timer.wait_time = randf_range(0.7, 3.0)
	right_button_timer.start()
	left_button_timer.start()
	title.text = "Level :\n" + str(GameManager.high_score_level)
	if GameManager.fastest_time < INF :
		var sec_time = roundi(GameManager.fastest_time / 1000)
		var minutes = roundi(sec_time/60.0)
		var secs = roundi(sec_time % 60)
		fastest_time.text = "Fastest time : " + str(minutes) + ":" + str(secs)
	if GameManager.survived :
		survived_text.text = "Survive Ending Unlocked"

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_right_button_timer_timeout() -> void:
	button_2._interact()
	right_button_timer.wait_time = randf_range(0.7, 3.0)
	right_button_timer.start()


func _on_left_button_timer_timeout() -> void:
	button._interact()
	left_button_timer.wait_time = randf_range(0.7, 3.0)
	left_button_timer.start()
