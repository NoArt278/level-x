extends Node3D

var rotate_tween
var target_angle = 0
@onready var scrape_sfx: AudioStreamPlayer3D = $ScrapeSFX

func rotate_room(angle : float) -> void:
	if scrape_sfx.playing :
		scrape_sfx.stop()
	scrape_sfx.play()
	if rotate_tween :
		rotate_tween.kill()
	target_angle += angle
	rotate_tween = create_tween()
	rotate_tween.tween_property(self, "rotation_degrees", Vector3(0,0, target_angle), 1)
	await rotate_tween.finished
