extends Node2D

@onready var ui = get_node("UI")
func _init():
	randomize()

func charge_battery():
	ui.charging = true

func uncharge_battery():
	ui.charging = false
