extends CanvasLayer

const MIN_HEALTH = 23
var max_hp = 4
@onready var player = get_parent().get_node("Player")
@onready var health_bar = get_node("HealthBar")
@onready var battery = $BatteryImage/battery
var charging = false
var charge
var battery_decharge_rate = .5 * SavedData.difficulty_multiplier
var dead_battery_dmg = .125 * SavedData.difficulty_multiplier
var battery_recharge_rate = 3.5 / SavedData.difficulty_multiplier
# Called when the node enters the scene tree for the first time.
func _ready():
	max_hp = player.hp
	_update_bar(health_bar, 100)
	charge = battery.value
	restore_previous_state()

func restore_previous_state():
	charge = SavedData.battery_charge

func _update_bar(bar, new_value):
	var tween: Tween = create_tween()
	tween.tween_property(bar, "value", new_value, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_hp_changed(new_hp):
	var new_health: int = int((100 - MIN_HEALTH) * float(new_hp) / max_hp) + MIN_HEALTH
	_update_bar(health_bar, new_health)


func _on_battery_timer_timeout():
	if not charging:
		charge -= battery_decharge_rate
		if charge <=0:
			player.take_damage(dead_battery_dmg, Vector2(0,0), 0)
	else:
		charge += battery_recharge_rate
	_update_bar(battery, charge)
	pass # Replace with function body.
