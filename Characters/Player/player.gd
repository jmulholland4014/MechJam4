extends Character

@onready var orb = get_node("Orb")
var colliding_webs = false
func _process(delta):
	var mouse_direction = (get_global_mouse_position()- global_position).normalized()
	if mouse_direction.x > 0:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0:
		animated_sprite.flip_h = true

func _restore_previous_state():
	self.hp = SavedData.hp

func _ready(): 
	_restore_previous_state()
	
func get_input() -> void:
	mov_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		mov_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		mov_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		mov_direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		mov_direction += Vector2.UP
	
func enter_web(divisor):
	if not colliding_webs:
		acceleration /= divisor
		max_speed /= divisor
		colliding_webs = true
		
func exit_web(divisor):
	if colliding_webs:
		acceleration *= divisor
		max_speed *= divisor
		colliding_webs = false


