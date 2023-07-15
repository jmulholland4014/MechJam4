extends CharacterBody2D
# Player and Orb nodes
@onready var player = get_parent()
@onready var orb = self
@onready var timer = get_node("Timer")
var bullet = preload("res://Effects/bullet.tscn")
var bullet_speed = 400
# Orb properties
var distance = 60  # Distance from the player
var rotationSpeed = 1.0  # Speed of rotation around the player
var can_fire = true
@onready var orb_animation_player = get_node("AnimationPlayer")
@onready var charge_particles = get_node("ChargeParticles")
var num_charged_bullets = 2
func fire(charged):
	for i in range(0,num_charged_bullets):
		if not charged and i >= 1:
			return
		var new_bullet = bullet.instantiate()
		new_bullet.position = global_position
		new_bullet.rotation_degrees = 0
		new_bullet.apply_impulse(Vector2(bullet_speed,0).rotated(rotation + (i*PI/(num_charged_bullets/2))), get_global_mouse_position())
		get_tree().get_root().call_deferred("add_child", new_bullet)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_attack") and can_fire and not orb_animation_player.is_playing():
		orb_animation_player.play("charged_attack")
	elif Input.is_action_just_released("ui_attack"):
		if orb_animation_player.is_playing() and orb_animation_player.current_animation == "charged_attack":
			fire(false)
		elif charge_particles.emitting:
			fire(true)
		can_fire = false
		timer.start()
		charge_particles.emitting = false
		orb_animation_player.stop()	
	
	# Calculate the position of the orb relative to the player
	var relativePosition = get_relative_position()

	# Calculate the desired position of the orb based on the mouse position
	var desiredPosition = player.global_position + get_mouse_direction().normalized() * distance

	# Interpolate the current position of the orb towards the desired position
	orb.global_position = orb.global_position.lerp(desiredPosition, delta * rotationSpeed)

	look_at(get_global_mouse_position())
	
func get_relative_position():
	# Calculate the position of the orb relative to the player
	return orb.global_position - player.global_position

func get_mouse_direction():
	# Calculate the direction from the player to the mouse position
	return get_global_mouse_position() - player.global_position
func _ready():
	charge_particles.emitting = false
func _on_timer_timeout():
	can_fire = true
	pass # Replace with function body.
