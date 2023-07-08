extends Node2D

const SPAWN_ROOMS = [preload("res://Rooms/spawn_room.tscn")]
const INTERMEDIATE_ROOMS = [preload("res://Rooms/room_0.tscn"), preload("res://Rooms/room_1.tscn")]
const END_ROOMS = [preload("res://Rooms/end_room.tscn")]

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 5
const RIGHT_WALL_TILE_INDEX: int = 2
const LEFT_WALL_TILE_INDEX: int = 2

@export var num_levels: int = 5

@onready var player: CharacterBody2D = get_parent().get_node("Player")


func _ready() -> void:
	_spawn_rooms()


func _spawn_rooms() -> void:
	var previous_room: Node2D
	var special_room_spawned: bool = false

	for i in num_levels:
		var room: Node2D

		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("PlayerSpawnPos").position
		else:
			if i == num_levels - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			else:
				room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()
			var previous_room_tilemap: TileMap = previous_room.get_node("NavigationRegion2D/TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2i = previous_room_tilemap.local_to_map(previous_room_door.position)

			var corridor_height: int = randi() % 5 + 2
			for y in corridor_height+2:
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-2, -y), FLOOR_TILE_INDEX, Vector2i.ZERO)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-1, -y), FLOOR_TILE_INDEX, Vector2i.ZERO)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(0, -y), FLOOR_TILE_INDEX, Vector2i.ZERO)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(1, -y), FLOOR_TILE_INDEX, Vector2i.ZERO)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-3, -y), LEFT_WALL_TILE_INDEX, Vector2i.ZERO)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(2, -y), RIGHT_WALL_TILE_INDEX, Vector2i.ZERO)
				

			var room_tilemap: TileMap = room.get_node("NavigationRegion2D/TileMap")
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Blockers/Blocker").position).x * TILE_SIZE

		add_child(room)
		previous_room = room
