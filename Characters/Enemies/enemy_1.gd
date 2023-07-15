extends Enemy

@onready var hitbox = get_node("HitBox")

func _process(delta):
	if is_instance_valid(hitbox):
		hitbox.knockback_direction = velocity.normalized()
	pass
