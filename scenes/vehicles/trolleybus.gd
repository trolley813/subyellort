class_name Trolleybus
extends VehicleBody

enum ControllerPosition { 
	BRAKE_5, BRAKE_4, BRAKE_3, BRAKE_2, BRAKE_1, NEUTRAL,
	MANEUVER, RUNNING_1, RUNNING_2, RUNNING_3, RUNNING_4
}

enum ReverserPosition { BACKWARD, NEUTRAL, FORWARD }

export var max_steer_angle = 45.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var steer_angle = 0.0

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
	throttle_val = Input.get_action_strength("vehicle_throttle")
	brake_val = Input.get_action_strength("vehicle_brake")
	steer_val = Input.get_action_strength("vehicle_steer_left") - Input.get_action_strength("vehicle_steer_right") 
	engine_force = 5000 * throttle_val + 2000
	steer_angle = max_steer_angle * steer_val
	steering = deg2rad(steer_angle)
