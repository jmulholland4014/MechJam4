extends Node

var num_floor: int = 0

var hp: int = 4
var battery_charge = 100
var difficulty_multiplier = 1

func reset_data() -> void:
	num_floor = 0
	
	hp = 4
