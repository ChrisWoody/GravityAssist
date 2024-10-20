extends CanvasGroup

@onready var label: Label = $Label
@onready var playAgain: Button = $Button
@onready var level01: Button = $Level01Button
@onready var level02: Button = $Level02Button

func _ready():
	playAgain.visible = false

func _on_game_manager_spaceship_launch_state(speed:float, rotation:float) -> void:
	pass

func _on_game_manager_level_complete() -> void:
	playAgain.visible = true

func _on_game_manager_reset_game() -> void:
	playAgain.visible = false

func _on_level_01_button_pressed() -> void:
	level01.visible = false
	level02.visible = false

func _on_level_02_button_pressed() -> void:
	level02.visible = false
	level01.visible = false
