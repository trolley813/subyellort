class_name Trolleybus
extends VehicleBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var steer_angle

enum ControllerPosition { 
	BRAKE_5, BRAKE_4, BRAKE_3, BRAKE_2, BRAKE_1, NEUTRAL,
	MANEUVER, RUNNING_1, RUNNING_2, RUNNING_3, RUNNING_4
}

enum ReverserPosition { BACKWARD, NEUTRAL, FORWARD }


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var steer_val = 0.0
	var throttle_val = 0.0
	var brake_val = 0.0
	if Input.is_action_pressed("vehicle_throttle"):
		throttle_val = 1.0
	if Input.is_action_pressed("vehicle_brake"):
		brake_val = 1.0
	if Input.is_action_pressed("vehicle_steer_left"):
		steer_val = 1.0
	elif Input.is_action_pressed("vehicle_steer_right"):
		steer_val = -1.0
	engine_force = 5000 * throttle_val
	steer_angle = steer_val * 45.0
	steering = deg2rad(steer_angle)
