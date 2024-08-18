class_name Spaceship extends Node2D

signal somethingChanged(speed: float, rotation: float, gravityApplied: bool)

const ROTATE_TIMEOUT = 0.05
var rotateElapsed := 0.0

var playing := false
var speed := 60.0

const gravityTimeout = 0.1
var gravityAppliedElapsed := 0.0
var applyGravityNext := false
var gravity := Vector2.ZERO
var gravityRotation := 0.0

var originalPosition := Vector2.ZERO

func _ready() -> void:
	originalPosition = global_position

func _process(delta: float) -> void:
	if playing:
		if applyGravityNext:
			gravityAppliedElapsed += delta
			if gravityAppliedElapsed >= gravityTimeout:
				gravityAppliedElapsed = 0.0
				applyGravityNext = false
				speed += 2
				rotation_degrees += gravityRotation

		position += (Vector2.from_angle(deg_to_rad(rotation_degrees - 90.0)) * delta * speed)
		somethingChanged.emit(speed, rotation_degrees, applyGravityNext)
		#position += (Vector2.from_angle(deg_to_rad(rotation_degrees - 90.0)) * delta * 60.0) + (gravity * delta * 20.0) # not the best way but fine for now
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
				somethingChanged.emit(speed, rotation_degrees, applyGravityNext)
		else:
			rotateElapsed = 0.0

func applyGravity(dir: Vector2, gravityRotationToApply: float) -> void:
	#gravity = dir
	applyGravityNext = true
	gravityRotation = gravityRotationToApply


func _on_game_manager_launch() -> void:
	playing = true

func _on_game_manager_reset_game() -> void:
	playing = false
	applyGravityNext = false
	gravityRotation = 0.0
	rotateElapsed = 0.0
	speed = 60.0
	rotation_degrees = 90.0
	global_position = originalPosition
	somethingChanged.emit(speed, rotation_degrees, applyGravityNext)