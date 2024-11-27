class_name Spaceship extends Node2D

@export var line2dScene: PackedScene
@export var line2dNormalGradient: Gradient
@export var line2dFinishedGradient: Gradient
@export var spaceshipCrash: PackedScene

@onready var gameManager: GameManager = get_node("../GameManager")
@onready var topLeftWall: Node2D = get_node("../TopLetWall")
@onready var bottomRightWall: Node2D = get_node("../BottomRightWall")

@onready var leftPoint: Node2D = $LeftPoint
@onready var rightPoint: Node2D = $RightPoint

var line2d: Line2D

const ROTATE_TIMEOUT = 0.05
var rotateElapsed := 0.0

const LINE_TIMEOUT := 0.1
var lineElapsed := 0.0

var playing := false
var replaying := false
var playingSpeed := 60.0
var finishingSpaceship := false

const gravityTimeout = 0.1
var gravityAppliedElapsed := 0.0
var applyGravityNext := false
var gravity := Vector2.ZERO

var originalPosition := Vector2.ZERO

var clicking = false
var mouseClickStartPosition := Vector2.ZERO
var mouseClickEndPosition := Vector2.ZERO

var planets: Array[Planet]

func _ready() -> void:
	originalPosition = global_position
	line2d = line2dScene.instantiate()
	add_sibling.call_deferred(line2d)
	line2d.gradient = line2dFinishedGradient if finishingSpaceship else line2dNormalGradient

func _process(delta: float) -> void:
	if not playing:
		return

	lineElapsed += delta
	if lineElapsed >= LINE_TIMEOUT:
		lineElapsed = 0.0
		line2d.add_point(global_position)


func _physics_process(delta: float) -> void:
	if not playing:
		return

	var gravityRotation := 0.0

	for planet in planets:
		var diff := planet.global_position - global_position
		if diff.length() < planet.gravityDistance:
			var left = planet.global_position - leftPoint.global_position
			var right = planet.global_position - rightPoint.global_position
			var rotateTowardsPlanet = -100 if left.length() < right.length() else 100

			var distanceScale := (-diff.length() + planet.gravityDistance) / planet.gravityDistance
			rotateTowardsPlanet *= distanceScale
			gravityRotation += rotateTowardsPlanet

	rotation_degrees += gravityRotation * delta
	position += (Vector2.from_angle(deg_to_rad(rotation_degrees - 90.0)) * delta * playingSpeed)

	if position.y <= topLeftWall.position.y or position.y >= bottomRightWall.position.y or position.x <= topLeftWall.position.x or position.x >= bottomRightWall.position.x:
		crashed()

func setGravityObjects(objects: Array[Planet]) -> void:
	planets = objects

func crashed() ->  void:
	playing = false

	var spaceshipCrashInstance: SpaceshipCrash = spaceshipCrash.instantiate()
	add_sibling.call_deferred(spaceshipCrashInstance)
	spaceshipCrashInstance.global_position = global_position
	spaceshipCrashInstance.global_rotation_degrees = randf() * 360

	if not replaying:
		gameManager.spaceshipCrashed()
		line2d.queue_free()
		queue_free()

func arrivedFinishedArea() -> void:
	playing = false
	if not replaying:
		gameManager.spaceshipFinished()
		line2d.queue_free()
		queue_free()

func launch(speed: float, initialRotation: float) -> void:
	playing = true
	playingSpeed = speed
	rotation_degrees = initialRotation

func replayLaunch(speed: float, initialRotation: float, spaceshipFinished: bool) -> void:
	playing = true
	replaying = true
	playingSpeed = speed
	rotation_degrees = initialRotation
	finishingSpaceship = spaceshipFinished

func resetGame() -> void:
	if line2d:
		line2d.queue_free()
	queue_free()
