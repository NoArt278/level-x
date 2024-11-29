extends Interactable

class_name InteractButton

@export var button_color : Color = Color.RED
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var the_button:  = $TheButton
const BUTTON_CLICK_SOUND_EFFECT = preload("res://assets/sounds/button-click-sound-effect-cc0-public-domain-sound.wav")
var button_sound : AudioStreamPlayer3D
var button_material

func _ready() -> void:
	can_interact = true
	button_sound = AudioStreamPlayer3D.new()
	button_sound.stream = BUTTON_CLICK_SOUND_EFFECT
	button_sound.max_db = 13
	button_sound.volume_db = 13
	add_child(button_sound)
	if the_button :
		button_material = the_button.mesh.material.duplicate()
		button_material.albedo_color = button_color
		the_button.mesh.material = button_material

func _interact() -> void :
	if animation_player :
		if animation_player.is_playing() :
			animation_player.stop()
		animation_player.play("interact")
	if button_sound.playing : 
		button_sound.stop()
	button_sound.play()
	target.callv(target_method, params)
