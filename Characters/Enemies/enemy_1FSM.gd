extends FiniteStateMachine
func _init():
	_add_state("chase")
	_add_state("hurt")
	_add_state("dead")

func _ready():
	set_state(states.chase)

func _state_logic(_delta: float) -> void:
	if state == states.chase:
		parent.chase()
		parent.move()

func _get_transition():
	match state:
		states.hurt:
			if not animation_player.is_playing():
				return states.chase
	return -1

func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.chase:
			animation_player.play("move")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animated_sprite.animation = "death"
			animation_player.play("death")
			
