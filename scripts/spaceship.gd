class_name Spaceship extends Node2D

@export var line2dScene: PackedScene
@export var line2dNormalGradient: Gradient
@export var line2dFinishedGradient: Gradient

@onready var gameManager: GameManager = get_node("../GameManager")
@onready var topLeftWall: Node2D = get_node("../TopLetWall")
@onready var bottomRightWall: Node2D = get_node("../BottomRightWall")

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
	if playing:
		lineElapsed += delta
		if lineElapsed >= LINE_TIMEOUT:
			lineElapsed = 0.0
			line2d.add_point(global_position)

		var applyGravity := false
		var gravityRotation := 0.0

		for planet in planets:
			var diff := planet.global_position - global_position
			if diff.length() < 150.0:
				gravityRotation = -2.0 if position.y > planet.position.y else 2.0
				applyGravity = true

		if applyGravity:
			gravityAppliedElapsed += delta
			if gravityAppliedElapsed >= gravityTimeout:
				gravityAppliedElapsed = 0.0
				playingSpeed += 2
				rotation_degrees += gravityRotation
		
		position += (Vector2.from_angle(deg_to_rad(rotation_degrees - 90.0)) * delta * playingSpeed)

		if position.y <= topLeftWall.position.y or position.y >= bottomRightWall.position.y or position.x <= topLeftWall.position.x or position.x >= bottomRightWall.position.x:
			crashed()

func setGravityObjects(objects: Array[Planet]) -> void:
	planets = objects

func crashed() ->  void:
	playing = false
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

func launch(speed: float, rotation: float) -> void:
	playing = true
	playingSpeed = speed
	rotation_degrees = rotation

func replayLaunch(speed: float, rotation: float, spaceshipFinished: bool) -> void:
	playing = true
	replaying = true
	playingSpeed = speed
	rotation_degrees = rotation
	finishingSpaceship = spaceshipFinished

func resetGame() -> void:
	line2d.queue_free()
	queue_free()