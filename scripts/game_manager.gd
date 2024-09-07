class_name GameManager extends Node2D

signal resetGame
signal launch(speed: float, rotation: float)
signal spaceshipLaunchState(speed: float, rotation: float)

@export var spaceship: PackedScene
@onready var launchLine: Line2D = get_node("../LaunchLine")

var playing := false
var clicking := false

var currentSpaceship: Spaceship

var speed := 60.0
var angle := 90.0

var mouseClickStartPosition := Vector2(-456, -10)
var mouseClickEndPosition := Vector2.ZERO

var planets: Array[Planet]

func _ready() -> void:
	var planetsFound: Array[Node] = get_parent().find_children("Planet*")
	planets.assign(planetsFound)
	print(str(planets.size()))
	currentSpaceship = spawnSpaceship()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		resetGame.emit()
	
	if clicking:
		mouseClickEndPosition = get_global_mouse_position()
		launchLine.set_point_position(1, launchLine.to_local(mouseClickEndPosition))
		speed = (mouseClickEndPosition - mouseClickStartPosition).length() / 3.0

		var angleToPoint := mouseClickStartPosition.angle_to_point(mouseClickEndPosition)
		var angleInDegress := rad_to_deg(angleToPoint) + 90.0
		angle = angleInDegress
		currentSpaceship.global_position = Vector2(-456, -10) + (Vector2.from_angle(deg_to_rad(angle - 90.0)) * 30.0)

		launchLine.set_point_position(0, launchLine.to_local(currentSpaceship.global_position))
		currentSpaceship.rotation_degrees = angleInDegress
		spaceshipLaunchState.emit(speed, angle)

func _input(event):
	if playing:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if clicking:
				clicking = false
				playing = true
				launched()
				launchLine.set_point_position(0, Vector2.ZERO)
				launchLine.set_point_position(1, Vector2.ZERO)
			else:
				clicking = true
				

func launched() -> void:
	clicking = false
	playing = true
	launch.emit(speed, angle)

func spaceshipCrashed() -> void:
	clicking = false
	playing = false
	resetGame.emit()
	currentSpaceship = spawnSpaceship()

func spawnSpaceship() -> Spaceship:
	var spaceshipInstance: Spaceship = spaceship.instantiate()
	add_sibling.call_deferred(spaceshipInstance)
	launch.connect(spaceshipInstance.launch)
	spaceshipInstance.global_position = Vector2(-456, -10)
	spaceshipInstance.rotation_degrees = 90.0
	spaceshipInstance.setGravityObjects(planets)
	return spaceshipInstance