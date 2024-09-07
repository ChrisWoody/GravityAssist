class_name PathPlotter extends Line2D

var playing := false

const SPAWN_TIMEOUT := 0.1
var spawnElapsed := 0.0

var spaceshipToFollow: Spaceship

func launch(spaceship: Spaceship) -> void:
	spaceshipToFollow = spaceship

func _process(delta: float) -> void:
	if playing:
		spawnElapsed += delta
		if spawnElapsed >= SPAWN_TIMEOUT:
			spawnElapsed = 0.0
			add_point(spaceshipToFollow.global_position)