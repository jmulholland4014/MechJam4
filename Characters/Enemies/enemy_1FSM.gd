extends FiniteStateMachine

func _init():
	_add_state("chase")

func _ready():
	set_state(states.chase)

func _state_logic(_delta: float) -> void:
	if state == states.chase:
		parent.chase()
		parent.move()

func _get_transition():
	return -1

func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.chase:
			animation_player.play("move")
