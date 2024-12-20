extends MeshInstance3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var level_manager: Node3D = $"../.."
@onready var skip_timer: Timer = $"../../SkipTimer"
var tp_hostile_maze : bool = false

func _ready() -> void:
	add_to_group("targets")

func _on_level_finish(skipped : bool) -> void :
	if not(visible) :
		visible = true
		animation_player.play("spawn")
		if skipped :
			GameManager.skip_count += 1
			GameManager.maze_size = max(8, GameManager.maze_size - 2 * GameManager.skip_count)
		else :
			GameManager.skip_count = 0
			skip_timer.stop()

func _on_ball_fell() -> void : 
	mesh.surface_get_material(0).albedo_color = Color.BLACK
	tp_hostile_maze = true
	_on_level_finish(false)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player" :
		level_manager.advance_level(tp_hostile_maze)
