class_name SpaceshipCrash extends Node2D

const LIFETIME := 0.1
var elapsed := 0.0

func _process(delta: float) -> void:
	elapsed += delta
	if elapsed >= LIFETIME:
		queue_free()