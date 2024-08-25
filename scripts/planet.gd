class_name Planet extends Node2D

@onready var spaceship: Spaceship = get_node("../Spaceship")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var diff := position - spaceship.position
	if diff.length() < 150.0:
		# OK gravity
		var gravityRotation := -2.0 if spaceship.position.y > position.y else 2.0
		spaceship.applyGravity(diff.normalized(), gravityRotation)

		# Intended to be better but needs a lot of work
		# var forward := Vector2.from_angle(deg_to_rad(spaceship.rotation_degrees - 90.0)).normalized()
		# var angleToPlanet := rad_to_deg(diff.angle_to(forward))
		# var angleToUse := -1.0 if angleToPlanet > 0.0 else 1.0
		# var scaleToUse := -(diff.length() / 150.0) + 1

		# spaceship.applyGravity(Vector2.ZERO, angleToUse * scaleToUse * scaleToUse)


func _on_area_2d_area_entered(area:Area2D) -> void:
	# assuming its the spaceship
	spaceship.crashedPlanet()
