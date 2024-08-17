class_name Spaceship extends Node2D

const ROTATE_TIMEOUT = 0.05
var rotateElapsed := 0.0

var playing := false

var gravity := Vector2.ZERO

func _process(delta: float) -> void:

	if Input.is_action_just_pressed("launch"):
		playing = true

	if playing:
		position += (Vector2.from_angle(deg_to_rad(rotation_degrees - 90.0)) * delta * 60.0) + (gravity * delta * 20.0) # not the best way but fine for now
	else:
		var angleDir := 0.0
		if Input.is_action_pressed("angle_up"):
			angleDir = -0.5
		elif Input.is_action_pressed("angle_down"):
			angleDir = 0.5

		if angleDir != 0.0:
			rotateElapsed += delta
			if rotateElapsed >= ROTATE_TIMEOUT:
				rotateElapsed = 0
				rotation_degrees += angleDir
		else:
			rotateElapsed = 0.0

func applyGravity(dir: Vector2) -> void:
	gravity = dir