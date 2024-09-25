extends CanvasGroup

@onready var label: Label = $Label
@onready var playAgain: Button = $Button

func _ready():
	playAgain.visible = false

func _on_game_manager_spaceship_launch_state(speed:float, rotation:float) -> void:
	label.text = "Speed: " + str(speed) + "\r\n" + "Rotation: " + str(rotation)

func _on_game_manager_level_complete() -> void:
	playAgain.visible = true

func _on_game_manager_reset_game() -> void:
	playAgain.visible = false
