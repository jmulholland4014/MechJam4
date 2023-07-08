extends Node2D
class_name DungeonRoom

@export var boss_room: bool = false

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Effects/spawn_explosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"E1": preload("res://Characters/Enemies/enemy_1.tscn")
}

var num_enemies: int

@onready var tilemap: TileMap = get_node("NavigationRegion2D/TileMap")
@onready var blockers: Node2D = get_node("Blockers")
@onready var door_container: Node2D = get_node("Doors")
@onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
@onready var player_detector: Area2D = get_node("PlayerDetector")


func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()
	_on_enemy_killed()
	
func _on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies <= 0:
		_open_doors()


func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()
		door.get_node("CollisionShape2D").disabled = true
	for blocker in blockers.get_children():
		blocker.open()


func _close_entrance() -> void:
	for blocker in blockers.get_children():
		blocker.call_deferred("close")

func _spawn_enemies() -> void:
	for enemy_position in enemy_positions_container.get_children():
		var enemy: CharacterBody2D
		enemy = ENEMY_SCENES.E1.instantiate()
		#if boss_room:
			#enemy = ENEMY_SCENES.SLIME_BOSS.instantiate()
			#num_enemies = 15
		#else:
			#if randi() % 1 == 0:
				#enemy = ENEMY_SCENES.E1.instantiate()
			#else:
				#enemy = ENEMY_SCENES.GOBLIN.instantiate()
		enemy.position = enemy_position.position
		call_deferred("add_child", enemy)

		var spawn_explosion: AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_explosion.position = enemy_position.position
		call_deferred("add_child", spawn_explosion)


func _on_player_detector_body_entered(body):
	if body.name == "Player":
		player_detector.queue_free()
		if num_enemies > 0:
			_close_entrance()
			_spawn_enemies()
		else:
			_close_entrance()
			_open_doors()
