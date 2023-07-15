extends CharacterBody2D

var direction = Vector2.ZERO
var web_speed = 200
var target = Vector2.ZERO
@onready var hitbox_collision_shape = get_node("Hitbox/CollisionShape2D")
func launch(initial_position, dir, speed, player_pos):
	position = initial_position
	direction = dir
	target = player_pos
	
func _physics_process(delta):
	if position.distance_to(target) >10:
		position += direction * web_speed *delta
	elif hitbox_collision_shape.disabled:
		hitbox_collision_shape.disabled = false

