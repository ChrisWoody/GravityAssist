class_name GameManager extends Node

signal resetGame
signal launch


var playing := false
var preparing := true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		resetGame.emit()

func launched() -> void:
	preparing = false
	playing = true
	launch.emit()