class_name GameManager extends Node2D

signal resetGame
signal launch(speed: float, rotation: float)
signal spaceshipLaunchState(speed: float, rotation: float)
signal levelComplete

@export var spaceship: PackedScene
@onready var launchLine: Line2D = get_node("../LaunchLine")
@onready var launchPlanet: MeshInstance2D = get_node("../LaunchPlanet")

var playing := false
var clicking := false

var currentSpaceship: Spaceship

var speed := 60.0
var angle := 90.0

var mouseClickStartPosition := Vector2.ZERO
var mouseClickEndPosition := Vector2.ZERO

var planets: Array[Planet]
var previousLaunches: Array[LaunchParameters]

func _ready() -> void:
	var planetsFound: Array[Node] = get_parent().find_children("Planet*")
	planets.assign(planetsFound)
	currentSpaceship = spawnSpaceship()
	mouseClickStartPosition = launchPlanet.global_position

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		resetGame.emit()

	if Input.is_action_just_pressed("spawn_previous_launches"):
		for previousLaunch in previousLaunches:
			var spaceshipInstance := spawnSpaceship()
			spaceshipInstance.replayLaunch(previousLaunch.speed, previousLaunch.angle, false)

	if clicking:
		mouseClickEndPosition = get_global_mouse_position()
		launchLine.set_point_position(1, launchLine.to_local(mouseClickEndPosition))
		speed = (mouseClickEndPosition - mouseClickStartPosition).length() / 3.0

		var angleToPoint := mouseClickStartPosition.angle_to_point(mouseClickEndPosition)
		var angleInDegress := rad_to_deg(angleToPoint) + 90.0
		angle = angleInDegress
		currentSpaceship.global_position = launchPlanet.global_position + (Vector2.from_angle(deg_to_rad(angle - 90.0)) * 30.0)

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
	var launchParameters := LaunchParameters.LaunchParameters(angle, speed)
	previousLaunches.append(launchParameters)
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
	resetGame.connect(spaceshipInstance.resetGame)
	spaceshipInstance.global_position = launchPlanet.global_position + (Vector2.from_angle(deg_to_rad(0)) * 30.0)
	spaceshipInstance.rotation_degrees = 90.0
	spaceshipInstance.setGravityObjects(planets)
	return spaceshipInstance

func spaceshipFinished() -> void:
	var index := 0
	for previousLaunch in previousLaunches:
		index += 1
		var spaceshipInstance := spawnSpaceship()
		# When replaying the spaceships end in a different spot than expected, what is causing it? The starting position?
		spaceshipInstance.global_position = launchPlanet.global_position + (Vector2.from_angle(deg_to_rad(previousLaunch.angle - 90.0)) * 30.0)
		spaceshipInstance.replayLaunch(previousLaunch.speed, previousLaunch.angle, true if index >= previousLaunches.size() else false)
	levelComplete.emit()

# play again
func _on_button_pressed() -> void:
	clicking = false
	playing = false
	resetGame.emit()
	previousLaunches.clear()
	currentSpaceship = spawnSpaceship()