extends RigidBody3D

const ROLL_SPEED : float = 20.0
const MOVE_SPEED : float = 4.5
@export var movement_target : Node3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready():
	set_physics_process(false)
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta):
	navigation_agent_3d.target_position = movement_target.global_position
	
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent_3d.get_next_path_position()

	angular_velocity = current_agent_position.direction_to(next_path_position) * ROLL_SPEED
	linear_velocity = current_agent_position.direction_to(next_path_position) * MOVE_SPEED
