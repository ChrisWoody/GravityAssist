class_name LaunchParameters

var angle := 0.0
var speed := 0.0

static func LaunchParameters(newAngle: float, newSpeed: float) -> LaunchParameters:
	var launchParameters: LaunchParameters = new()
	launchParameters.angle = newAngle
	launchParameters.speed = newSpeed
	return launchParameters