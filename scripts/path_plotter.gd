class_name PathPlotter extends Node

@export var pathPlot: PackedScene
@onready var spaceship: Spaceship = get_node("../Spaceship")

var playing := false

const SPAWN_TOTAL := 100
var spawnIndex := 0

const SPAWN_TIMEOUT := 0.3
var spawnElapsed := 0.0

var pathPlots: Array[MeshInstance2D]

func _ready() -> void:
	for n in SPAWN_TOTAL:
		var pathPlotInstance: MeshInstance2D = pathPlot.instantiate()
		add_child(pathPlotInstance)
		pathPlotInstance.visible = false
		pathPlots.push_back(pathPlotInstance)

func _process(delta: float) -> void:
	if playing:
		spawnElapsed += delta
		if spawnElapsed >= SPAWN_TIMEOUT:
			spawnElapsed = 0.0
			pathPlots[spawnIndex].global_position = spaceship.global_position
			pathPlots[spawnIndex].global_rotation = spaceship.global_rotation
			pathPlots[spawnIndex].visible = true
			spawnIndex = spawnIndex + 1
			if spawnIndex >= SPAWN_TOTAL:
				spawnIndex = SPAWN_TOTAL - 1



func _on_game_manager_launch() -> void:
	playing = true


func _on_game_manager_reset_game() -> void:
	playing = false
	spawnElapsed = 0.0
	spawnIndex = 0
	for n in SPAWN_TOTAL:
		pathPlots[n].visible = false