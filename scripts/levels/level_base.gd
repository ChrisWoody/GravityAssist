class_name LevelBase extends Node2D

@onready var launchPlanet: MeshInstance2D = $LaunchPlanet

func getLaunchPosition() -> Vector2:
	return launchPlanet.global_position