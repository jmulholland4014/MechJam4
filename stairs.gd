extends Area2D

@onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")

var difficulty_addition =.15
func _on_body_entered(body):
	collision_shape.set_deferred("disabled", true)
	SavedData.difficulty_multiplier += difficulty_addition
	SceneTransistor.start_transition_to("res://game.tscn")

func reveal():
	self.visible = true
	collision_shape.disabled = false
