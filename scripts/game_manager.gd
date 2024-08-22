class_name GameManager extends Node

signal resetGame
signal launch


var playing := false
var preparing := true

func _process(_delta: float) -> void:
	pass

func launched() -> void:
	preparing = false
	playing = true
	launch.emit()