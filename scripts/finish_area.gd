class_name FinishArea extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	var spaceship := area.get_parent() as Spaceship
	if spaceship:
		spaceship.arrivedFinishedArea()