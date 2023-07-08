extends StaticBody2D

@onready var animation_player = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")
func open():
	animation_player.play("open")

func _ready():
	sprite.rotation -= self.rotation
	animation_player.play("close")
