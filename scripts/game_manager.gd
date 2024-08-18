extends Node

signal resetGame
signal launch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var playing := false
var preparing := true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if preparing:
		if Input.is_action_just_pressed("launch"):
			preparing = false
			playing = true
			launch.emit()
	elif playing:
		if Input.is_action_just_pressed("launch"):
			preparing = true
			playing = false
			resetGame.emit()