extends CanvasGroup

@onready var playAgain: Button = $PlayAgainButton
@onready var levelPicker: Button = $LevelPickerButton
@onready var level01: Button = $Level01Button
@onready var level02: Button = $Level02Button
@onready var level03: Button = $Level03Button
@onready var level04: Button = $Level04Button
@onready var level05: Button = $Level05Button
@onready var gameTitleLabel: Label = $GameTitleLabel

func _ready():
	playAgain.visible = false
	levelPicker.visible = false

func _on_game_manager_spaceship_launch_state(speed:float, rotation:float) -> void:
	pass

func _on_game_manager_level_complete() -> void:
	playAgain.visible = true
	levelPicker.visible = true

func _on_game_manager_reset_game() -> void:
	playAgain.visible = false
	levelPicker.visible = false

func _on_level_01_button_pressed() -> void:
	setLevelButtonsVisibility(false)

func _on_level_02_button_pressed() -> void:
	setLevelButtonsVisibility(false)

func _on_level_03_button_pressed() -> void:
	setLevelButtonsVisibility(false)

func _on_level_04_button_pressed() -> void:
	setLevelButtonsVisibility(false)

func _on_level_05_button_pressed() -> void:
	setLevelButtonsVisibility(false)

func setLevelButtonsVisibility(val: bool) -> void:
	level01.visible = val
	level02.visible = val
	level03.visible = val
	level04.visible = val
	level05.visible = val
	gameTitleLabel.visible = val

func _on_game_manager_go_to_level_picker() -> void:
	playAgain.visible = false
	levelPicker.visible = false
	setLevelButtonsVisibility(true)
