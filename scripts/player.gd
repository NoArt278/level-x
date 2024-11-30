extends CharacterBody3D


const SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5
const RAY_LENGTH : float = 30
var mouse_sensitivity : float = 0.002 
var mouse_pos_delta : Vector2 = Vector2.ZERO
var curr_interactable : Interactable
var can_move : bool = true
@onready var camera_3d: Camera3D = $Camera3D
@onready var reticle: ColorRect = $HUD/Reticle
@onready var red_death: ColorRect = $HUD/RedDeath
@onready var rich_text_label: RichTextLabel = $HUD/RedDeath/RichTextLabel
@onready var hurt_sfx: AudioStreamPlayer3D = $HurtSFX
@onready var menu_timer: Timer = $HUD/MenuTimer

func _physics_process(delta: float) -> void:
	if not is_on_floor() and not is_on_ceiling():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_ceiling()):
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if can_move :
		move_and_slide()
	
	if mouse_pos_delta.length() < 50 and can_move :
		rotate_y(mouse_pos_delta.x * mouse_sensitivity)
		$Camera3D.rotate_x(mouse_pos_delta.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	
	mouse_pos_delta = Vector2.ZERO
	# raycast
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_visible_rect().size / 2.0

	var origin = camera_3d.project_ray_origin(mousepos)
	var end = origin + camera_3d.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	var collider = result.get("collider")
	if collider and collider.get_parent() is Interactable and collider.get_parent().can_interact :
		curr_interactable = collider.get_parent()
		reticle.visible = true
	else :
		curr_interactable = null
		reticle.visible = false
	
	if Input.is_action_just_pressed("interact") :
		if curr_interactable :
			curr_interactable._interact()

func die() -> void :
	hurt_sfx.play()
	can_move = false
	var fall_tween = create_tween()
	fall_tween.tween_property(self, "rotation_degrees", Vector3(0, 0, 90), 0.5)
	var death_tween = red_death.create_tween()
	death_tween.tween_property(red_death, "color", Color.RED, 1.5)
	await death_tween.finished
	rich_text_label.visible = true
	menu_timer.start()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion :
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED :
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_pos_delta = -event.relative


func _on_menu_timer_timeout() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/menu.tscn")
