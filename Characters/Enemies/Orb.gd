extends CharacterBody2D
var speed = 300
@onready var boss = get_parent()
func _ready():
	look_at(boss.global_position)
	velocity = Vector2(speed,0).rotated(rotation)
func _physics_process(delta):
	look_at(boss.global_position)
	if global_position.distance_to(boss.global_position)< 200:
		velocity = Vector2(-speed,0).rotated(rotation)
	move_and_slide()


func _on_hitbox_hit_object(body):
	if body.name != boss.name:
		velocity = Vector2(speed,0).rotated(rotation)
	pass # Replace with function body.
