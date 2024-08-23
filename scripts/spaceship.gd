class_name Spaceship extends Node2D

signal somethingChanged(speed: float, rotation: float, gravityApplied: bool)
@onready var gameManager: GameManager = get_node("../GameManager")
@onready var launchLine: Line2D = get_node("../LaunchLine")

@export var topLeftWall: Node2D
@export var bottomRightWall: Node2D

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

var clicking = false
var mouseClickStartPosition := Vector2.ZERO
var mouseClickEndPosition := Vector2.ZERO

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

		if position.y <= topLeftWall.position.y or position.y >= bottomRightWall.position.y or position.x <= topLeftWall.position.x or position.x >= bottomRightWall.position.x:
			gameManager.spaceshipCrashed()

	elif clicking:
		mouseClickEndPosition = get_global_mouse_position()		
		launchLine.set_point_position(1, launchLine.to_local(mouseClickEndPosition))
		speed = (mouseClickEndPosition - mouseClickStartPosition).length() / 3.0

		var angle := mouseClickStartPosition.angle_to_point(mouseClickEndPosition)
		var angleInDegress := rad_to_deg(angle) + 90.0
		rotation_degrees = angleInDegress
		
		somethingChanged.emit(speed, angleInDegress, applyGravityNext)

func crashedPlanet() -> void:
	gameManager.spaceshipCrashed()

func applyGravity(dir: Vector2, gravityRotationToApply: float) -> void:
	#gravity = dir
	applyGravityNext = true
	gravityRotation = gravityRotationToApply

func _input(event):
	if playing:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if clicking:
				clicking = false
				playing = true
				gameManager.launched()
				launchLine.set_point_position(0, Vector2.ZERO)
				launchLine.set_point_position(1, Vector2.ZERO)
			else:
				clicking = true
				mouseClickStartPosition = position
				launchLine.set_point_position(0, launchLine.to_local(mouseClickStartPosition))

func _on_game_manager_launch() -> void:
	playing = true

func _on_game_manager_reset_game() -> void:
	playing = false
	applyGravityNext = false
	gravityRotation = 0.0
	rotateElapsed = 0.0
	speed = 0.0
	rotation_degrees = 90.0
	global_position = originalPosition
	somethingChanged.emit(speed, rotation_degrees, applyGravityNext)
