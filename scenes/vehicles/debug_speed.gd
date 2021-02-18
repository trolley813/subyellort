extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var last_pos: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var trolleybus: Trolleybus = get_parent()
	var curr_pos = trolleybus.translation
	var height = trolleybus.to_global(curr_pos).y
	var velocity = (curr_pos - last_pos) / delta
	var azimuth = fposmod(-trolleybus.rotation_degrees.y + 180.0, 360.0)
	text = "Speed: %6.2f km/h\nAzimuth: %5.1f° (%s)\nHeight: %3.1f m\n Steer angle: %4.1d" % \
		[velocity.length() * 3.6, azimuth, cardinal_direction(azimuth), height, trolleybus.steer_angle]
	last_pos = curr_pos

# Get cardinal direction by azimuth in degrees
func cardinal_direction(degrees: float) -> float:
	var DIRECTIONS = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
	var index = int(fposmod(degrees + 22.5, 360.0) / 45.0)
	return DIRECTIONS[index]
