extends CharacterBody2D
class_name Character 

const FRICTION: float = .15

@export var hp = 2 
signal hp_changed(new_hp)
@export var acceleration = 40
@export var max_speed = 100
@onready var state_machine = get_node("FiniteStateMachine")
var mov_direction = Vector2.ZERO
@onready var animated_sprite = get_node("AnimatedSprite2D")
func _physics_process(delta):
	move()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
func move():
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * acceleration
	move_and_slide()

func take_damage(damage, dir, force):
	if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
		set_hp(hp-damage)
		if hp >0:
			state_machine.set_state(state_machine.states.hurt)
			velocity += dir*force
		else:
			state_machine.set_state(state_machine.states.dead)
			velocity += dir * force *2

func set_hp(new_hp):
	hp = new_hp
	if name == "Player":
		SavedData.hp = new_hp
	emit_signal("hp_changed", new_hp)
		
	
