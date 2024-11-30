extends Control

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var text_timer: Timer = $TextTimer
@onready var menu_timer: Timer = $MenuTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save_file = FileAccess.open("user://1000_save.save", FileAccess.WRITE)
	if GameManager.level > GameManager.high_score_level :
		GameManager.high_score_level = GameManager.level
		save_file.store_line(JSON.stringify({"highest_level" : GameManager.high_score_level}))
	var curr_time = Time.get_ticks_msec() - GameManager.start_time
	if GameManager.fastest_time > curr_time :
		GameManager.fastest_time = curr_time
		save_file.store_line(JSON.stringify({"fastest_time" : min(GameManager.fastest_time, curr_time)}))
	GameManager.survived = true
	save_file.store_line(JSON.stringify({"survived" : true}))

func _on_text_timer_timeout() -> void:
	if not(rich_text_label.visible) :
		rich_text_label.visible = true
		text_timer.wait_time = 3
		text_timer.start()
	else :
		rich_text_label.visible = false
		menu_timer.start()


func _on_menu_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
