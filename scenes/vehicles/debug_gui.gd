extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _update_counter = 0.0

const REVERSER_POS_STRINGS = {
	Trolleybus.ReverserPosition.BACKWARD: "R",
	Trolleybus.ReverserPosition.NEUTRAL: "0",
	Trolleybus.ReverserPosition.FORWARD: "F",
}

const CONTROLLER_POS_STRINGS = {
	Trolleybus.ControllerPosition.BRAKE_5: "B5",
	Trolleybus.ControllerPosition.BRAKE_4: "B4",
	Trolleybus.ControllerPosition.BRAKE_3: "B3",
	Trolleybus.ControllerPosition.BRAKE_2: "B2",
	Trolleybus.ControllerPosition.BRAKE_1: "B1",
	Trolleybus.ControllerPosition.NEUTRAL: "0",
	Trolleybus.ControllerPosition.MANEUVER: "M",
	Trolleybus.ControllerPosition.RUNNING_1: "R1",
	Trolleybus.ControllerPosition.RUNNING_2: "R2",
	Trolleybus.ControllerPosition.RUNNING_3: "R3",
	Trolleybus.ControllerPosition.RUNNING_4: "R4",
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_counter += delta
	if _update_counter <= 0.1:
		return
	_update_counter = 0
	var trolleybus: Trolleybus = get_parent()
	var height = trolleybus.to_global(trolleybus.translation).y
	var azimuth = fposmod(-trolleybus.rotation_degrees.y + 180.0, 360.0)
	var rev_pos = trolleybus.reverser_pos
	$info/coord_label.text = (
		"Azimuth: %5.1f° (%s)\nHeight: %3.1f m"
		% [azimuth, cardinal_direction(azimuth), height]
	)
	$info/speed_label.text = (
		"Speed: %5.1f km/h\nRPM: %4.0f"
		% [trolleybus.speed * 3.6, trolleybus.engine_rpm]
	)
	$info/electro_label.text = (
		"Reverser: %s\nController: %s\nGRC: %2d"
		% [
			REVERSER_POS_STRINGS[trolleybus.reverser_pos],
			CONTROLLER_POS_STRINGS[trolleybus.controller_pos],
			trolleybus.grc_pos
		]
	)
	$info/values_label.text = (
		"Current: %3.0f A\nEMF: %3.0f V\nTorque: %5.0f N m"
		% [trolleybus.arm_current, trolleybus.emf, trolleybus.driving_force]
	)


# Get cardinal direction by azimuth in degrees
func cardinal_direction(degrees: float) -> float:
	var DIRECTIONS = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
	var index = int(fposmod(degrees + 22.5, 360.0) / 45.0)
	return DIRECTIONS[index]


func value_to_key(dict: Dictionary, value):
	var entry = dict.values().find(value)
	return dict.keys()[entry]
