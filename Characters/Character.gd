extends CharacterBody2D
class_name Character 

const FRICTION: float = .15
@export var acceleration = 40
@export var max_speed = 100
var mov_direction = Vector2.ZERO
@onready var animated_sprite = get_node("AnimatedSprite2D")
func _physics_process(delta):
	move()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
func move():
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * acceleration
	move_and_slide()
	
