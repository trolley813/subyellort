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
	var velocity = (trolleybus.translation - last_pos) / delta
	text = "V: %s" % (velocity.length() * 3.6) # in KPH
	last_pos = trolleybus.translation
