class_name Planet extends Node2D

@onready var spaceship: Spaceship = get_node("../Spaceship")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var diff := position - spaceship.position
	if diff.length() < 150.0:
		var gravityRotation := -2.0 if spaceship.position.y > position.y else 2.0
		spaceship.applyGravity(diff.normalized(), gravityRotation)

	pass
