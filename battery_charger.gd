extends Node2D

signal spawn_enemies_with_positions(positions)

@onready var sprite = get_node("Sprite2D") 
@onready var wave_spawner = get_node("WaveSpawner")
@onready var enemy_positions = get_node("Enemy Positions")
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func charge():
	sprite.frame = 1

func uncharge():
	sprite.frame = 0	

#The game_reference variable is there for testing purposes. Occasionally the player needs to be dragged into a specific room so we dont want this to crash it in the event of.
func _on_area_2d_body_entered(body):
	player = body
	var game_reference = body.get_parent()
	if game_reference.has_method("charge_battery"):
		game_reference.charge_battery()
	charge()
	wave_spawner.start()
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	var game_reference = body.get_parent()
	if game_reference.has_method("uncharge_battery"):
		game_reference.uncharge_battery()
	uncharge()
	wave_spawner.stop()
	pass # Replace with function body.


func _on_wave_spawner_timeout():
	emit_signal("spawn_enemies_with_positions", enemy_positions.get_children())
	pass # Replace with function body.
