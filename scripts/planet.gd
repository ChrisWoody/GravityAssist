class_name Planet extends Node2D

@export var sizeScale: Size
var gravityDistance: float

func _ready():
	match sizeScale:
		Size.Small:
			gravityDistance = 150.0
		Size.Medium:
			gravityDistance = 200.0
		Size.Large:
			gravityDistance = 250.0
		_:
			gravityDistance = 100.0

func _on_area_2d_area_entered(area: Area2D) -> void:
	var spaceship := area.get_parent() as Spaceship
	if spaceship:
		spaceship.crashed()

enum Size {Small, Medium, Large}