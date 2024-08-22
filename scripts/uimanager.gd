extends CanvasGroup

@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spaceship_something_changed(speed:float, rotation:float, gravityApplied:bool) -> void:
	label.text = "Speed: " + str(speed) + "\r\n" + "Rotation: " + str(rotation) + "\r\n" + "Gravity: " + str(gravityApplied)