extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	open()
	pass # Replace with function body.

func close():
	$Sprite2D.visible = true
	$CollisionShape2D.disabled = false

func open():
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
