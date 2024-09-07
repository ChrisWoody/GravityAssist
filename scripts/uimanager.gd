extends CanvasGroup

@onready var label: Label = $Label

func _on_game_manager_spaceship_launch_state(speed:float, rotation:float) -> void:
	label.text = "Speed: " + str(speed) + "\r\n" + "Rotation: " + str(rotation)
