extends Enemy

const SPIDER_WEB_SCENE: PackedScene = preload("res://Characters/Enemies/spiderweb.tscn")

const MAX_DISTANCE_TO_PLAYER: int = 500
const MIN_DISTANCE_TO_PLAYER: int = 100

@export var projectile_speed: int = 150 * SavedData.difficulty_multiplier

var can_attack: bool = true

var distance_to_player: float

@onready var attack_timer: Timer = get_node("AttackTimer")

func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
		else:
			return
			if can_attack and state_machine.state == state_machine.states.idle:
				can_attack = false
				shoot_web()
				attack_timer.start()
	else:
		mov_direction = Vector2.ZERO


func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	navigation_agent.target_position = global_position + dir * 100


func shoot_web() -> void:
	var projectile = SPIDER_WEB_SCENE.instantiate()
	projectile.launch(global_position, (player.position - global_position).normalized(), projectile_speed, player.global_position)
	get_tree().current_scene.add_child(projectile)


func _on_attack_timer_timeout():
	can_attack = true
	pass # Replace with function body.


func _on_hp_changed(new_hp):
	$"CanvasLayer/Boss Healthbar/HealthBar".value = new_hp
	pass # Replace with function body.


func _on_path_timer_path_timer():
	_on_PathTimer_timeout()
	pass # Replace with function body.
