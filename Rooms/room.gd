extends Node2D
class_name DungeonRoom

@export var boss_room: bool = false

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Effects/spawn_explosion.tscn")

const ENEMY_SCENES = {
	"ENEMY_1": preload("res://Characters/Enemies/enemy_1.tscn"),
	"SPIDER": preload("res://Characters/Enemies/spider.tscn")
}
const BOSS_SCENES = {
	"MAGMODIAS": preload("res://Characters/Enemies/electric_boss.tscn")
}

var num_enemies: int

@onready var tilemap: TileMap = get_node("NavigationRegion2D/TileMap")
@onready var blockers: Node2D = get_node("Blockers")
@onready var door_container: Node2D = get_node("Doors")
@onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
@onready var player_detector: Area2D = get_node("PlayerDetector")
@onready var stairs = get_node("Stairs")
var battery_color_array = [0,.48,.93, 1]
var default_color_array = [1,1,1,1]
func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()
	if "SpawnRoom" in name:
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
	if is_instance_valid(stairs):
		stairs.reveal()


func _close_entrance() -> void:
	for blocker in blockers.get_children():
		blocker.call_deferred("close")

func _spawn_enemies() -> void:
	for enemy_position in enemy_positions_container.get_children():
		_spawn_enemies_helper(enemy_position, default_color_array)
		
func _spawn_enemies_helper(enemy_position, color_change):
	var enemy: CharacterBody2D
	enemy = get_random_enemy().instantiate()
	enemy.set_modulate(Color(color_change[0], color_change[1], color_change[2], color_change[3]))
	if boss_room or randi() % 4096 ==1:
		enemy = BOSS_SCENES.MAGMODIAS.instantiate()
		num_enemies = 1
	#else:
		#if randi() % 1 == 0:`
			#enemy = ENEMY_SCENES.E1.instantiate()
		#else:
			#enemy = ENEMY_SCENES.GOBLIN.instantiate()
	enemy.position = enemy_position.position
	call_deferred("add_child", enemy)
	var spawn_explosion: AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
	spawn_explosion.position = enemy_position.position
	call_deferred("add_child", spawn_explosion)
func _on_battery_charger_spawn_enemies_with_positions(positions):
	for enemy_position in positions:
		if randi() % positions.size() == 0:
			var enemy_position_copy = enemy_position.duplicate()
			enemy_position_copy.position += $BatteryCharger.position
			_spawn_enemies_helper(enemy_position_copy, battery_color_array)
func get_random_enemy():
	var keys = ENEMY_SCENES.keys()
	var enemy_key = keys[randi() % keys.size()]
	return ENEMY_SCENES[enemy_key]

func _on_player_detector_body_entered(body):
	if body.name == "Player":
		player_detector.queue_free()
		if num_enemies > 0:
			_close_entrance()
			_spawn_enemies()
		else:
			_close_entrance()
			_open_doors()



