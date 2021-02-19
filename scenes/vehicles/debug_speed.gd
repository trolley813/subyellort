extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _update_counter = 0.0


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
	var velocity = trolleybus.linear_velocity
	var azimuth = fposmod(-trolleybus.rotation_degrees.y + 180.0, 360.0)
	var rev_pos = trolleybus.reverser_pos
	var pos_text = (
		"Speed: %6.2f km/h Azimuth: %5.1f° (%s)Height: %3.1f m"
		% [velocity.length() * 3.6 * rev_pos, azimuth, cardinal_direction(azimuth), height]
	)
	var veh_text = (
		"Steer angle: %4.1f° Rev pos: %s Ctrl pos: %s GRC pos: %s\nCurrent: %4.1f A Driving force: %8.1f N EMF: %5.1f V RPM: %5.0f"
		% [
			trolleybus.steer_angle,
			value_to_key(Trolleybus.ReverserPosition, trolleybus.reverser_pos),
			value_to_key(Trolleybus.ControllerPosition, trolleybus.controller_pos),
			trolleybus.grc_pos,
			trolleybus.arm_current,
			trolleybus.engine_force,
			trolleybus.emf,
			trolleybus.engine_rpm
		]
	)
	text = "%s\n%s" % [pos_text, veh_text]


# Get cardinal direction by azimuth in degrees
func cardinal_direction(degrees: float) -> float:
	var DIRECTIONS = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
	var index = int(fposmod(degrees + 22.5, 360.0) / 45.0)
	return DIRECTIONS[index]


func value_to_key(dict: Dictionary, value):
	var entry = dict.values().find(value)
	return dict.keys()[entry]
