class_name LevelBase extends Node2D

@onready var launchPlanth: MeshInstance2D = $LaunchPlanet

func getLaunchPosition() -> Vector2:
	return launchPlanth.global_position