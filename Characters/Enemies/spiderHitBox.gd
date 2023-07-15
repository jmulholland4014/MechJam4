extends Hitbox

@export var divisor = 10.0 * SavedData.difficulty_multiplier
func _collide(body):
	if is_instance_valid(body) and body.has_method("enter_web"):
		body.enter_web(divisor)
func leaving_body(_body):
	if is_instance_valid(_body) and _body.has_method("exit_web"):
		_body.exit_web(divisor)
