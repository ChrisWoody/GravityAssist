class_name PathPlotter extends Node

@onready var spaceship: Spaceship = get_node("../Spaceship")
@onready var line2d: Line2D = $Line2D

var playing := false

const SPAWN_TIMEOUT := 0.1
var spawnElapsed := 0.0

func _process(delta: float) -> void:
	if playing:
		spawnElapsed += delta
		if spawnElapsed >= SPAWN_TIMEOUT:
			spawnElapsed = 0.0
			line2d.add_point(spaceship.global_position)


func _on_game_manager_launch() -> void:
	playing = true


func _on_game_manager_reset_game() -> void:
	playing = false
	spawnElapsed = 0.0
	line2d.clear_points()