class_name GameManager extends Node2D

signal resetGame
signal launch(speed: float, rotation: float)
signal levelComplete
signal goToLevelPicker

@export var spaceship: PackedScene
@export var level01: PackedScene
@export var level02: PackedScene
@export var level03: PackedScene
@export var level04: PackedScene
@export var level05: PackedScene

@onready var launchLine: Line2D = get_node("../LaunchLine")

var currentLevel: LevelBase

var pickingLevel := true
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
	pass

func _process(_delta: float) -> void:
	if pickingLevel:
		return

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
		var angleInDegrees := rad_to_deg(angleToPoint) + 90.0
		angle = angleInDegrees
		currentSpaceship.global_position = currentLevel.getLaunchPosition() + (Vector2.from_angle(deg_to_rad(angle - 90.0)) * 30.0)

		launchLine.set_point_position(0, launchLine.to_local(currentSpaceship.global_position))
		currentSpaceship.rotation_degrees = angleInDegrees

func _input(event):
	if event.is_action_pressed("go_to_level_picker"):
		_on_level_picker_button_pressed()
		return

	if playing or pickingLevel:
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

func setupLevel(levelBase: PackedScene) -> void:
	planets.clear()
	previousLaunches.clear()

	currentLevel = levelBase.instantiate()
	add_sibling.call_deferred(currentLevel)
	var planetsFound: Array[Node] = currentLevel.find_children("Planet*")
	planets.assign(planetsFound)
	call_deferred("setupLevelDeferred")
	pickingLevel = false

func setupLevelDeferred() -> void:
	currentSpaceship = spawnSpaceship()
	mouseClickStartPosition = currentLevel.getLaunchPosition()

func launched() -> void:
	clicking = false
	playing = true
	var launchParameters := LaunchParameters.LaunchParameters(angle, speed)
	previousLaunches.append(launchParameters)
	print("Launch angle: " + str(angle) + ", speed: " + str(speed))
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
	spaceshipInstance.global_position = currentLevel.getLaunchPosition() + (Vector2.from_angle(deg_to_rad(0)) * 30.0)
	spaceshipInstance.rotation_degrees = 90.0
	spaceshipInstance.setGravityObjects(planets)
	return spaceshipInstance

func spaceshipFinished() -> void:
	var index := 0
	for previousLaunch in previousLaunches:
		index += 1
		var spaceshipInstance := spawnSpaceship()
		# When replaying the spaceships end in a different spot than expected, what is causing it? The starting position?
		spaceshipInstance.global_position = currentLevel.getLaunchPosition() + (Vector2.from_angle(deg_to_rad(previousLaunch.angle - 90.0)) * 30.0)
		spaceshipInstance.replayLaunch(previousLaunch.speed, previousLaunch.angle, true if index >= previousLaunches.size() else false)
	levelComplete.emit()

func _on_button_pressed() -> void:
	clicking = false
	playing = false
	resetGame.emit()
	previousLaunches.clear()
	currentSpaceship = spawnSpaceship()

func _on_level_01_button_pressed() -> void:
	setupLevel(level01)

func _on_level_02_button_pressed() -> void:
	setupLevel(level02)

func _on_level_03_button_pressed() -> void:
	setupLevel(level03)

func _on_level_04_button_pressed() -> void:
	setupLevel(level04)

func _on_level_05_button_pressed() -> void:
	setupLevel(level05)

func _on_level_picker_button_pressed() -> void:
	resetGame.emit()
	planets.clear()
	previousLaunches.clear()
	clicking = false
	playing = false
	pickingLevel = true
	if currentLevel:
		currentLevel.queue_free()
		currentLevel = null
	goToLevelPicker.emit()
