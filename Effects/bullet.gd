extends RigidBody2D

@onready var hitbox = get_node("HitBox")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_hit_box_hit_object():
	queue_free()
	pass # Replace with function body.
