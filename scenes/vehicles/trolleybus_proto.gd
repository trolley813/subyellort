extends Trolleybus

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var grc_positions = {
		-2: GRCPositionInfo.new(1.85, 48, 0),
		-1: GRCPositionInfo.new(1.85, 0, 0),
		0: GRCPositionInfo.new(1.85, 0, 0),
		1: GRCPositionInfo.new(4.308, 48, 1),
		2: GRCPositionInfo.new(3.308, 48, 1),
		3: GRCPositionInfo.new(2.988, 48, 1),
		4: GRCPositionInfo.new(1.848, 48, 1),
		5: GRCPositionInfo.new(1.54, 48, 1),
		6: GRCPositionInfo.new(1.232, 48, 1),
		7: GRCPositionInfo.new(0.924, 48, 1),
		8: GRCPositionInfo.new(0.71, 48, 1),
		9: GRCPositionInfo.new(0.532, 48, 1),
		10: GRCPositionInfo.new(0.37, 48, 1),
		11: GRCPositionInfo.new(0.231, 48, 1),
		12: GRCPositionInfo.new(0.136, 48, 1),
		13: GRCPositionInfo.new(0, 48, 1),
		14: GRCPositionInfo.new(0, 668, 1),
		15: GRCPositionInfo.new(0, 668, 0.72),
		16: GRCPositionInfo.new(0, 668, 0.53),
		17: GRCPositionInfo.new(0, 668, 0.4),
		18: GRCPositionInfo.new(0, 668, 0.31),
	}
	var ctrl_positions = {
		ControllerPosition.BRAKE_3: ControllerPositionInfo.new(-2, 150, true),
		ControllerPosition.BRAKE_2: ControllerPositionInfo.new(-2, 150, false),
		ControllerPosition.BRAKE_1: ControllerPositionInfo.new(-1, 150, false),
		ControllerPosition.NEUTRAL: ControllerPositionInfo.new(1, 0, false),
		ControllerPosition.MANEUVER: ControllerPositionInfo.new(1, 150, false),
		ControllerPosition.RUNNING_1: ControllerPositionInfo.new(15, 250, false),
		ControllerPosition.RUNNING_2: ControllerPositionInfo.new(17, 250, false),
		ControllerPosition.RUNNING_3: ControllerPositionInfo.new(18, 250, false),
	}
	engine_info.grc_positions = grc_positions
	engine_info.ctrl_positions = ctrl_positions
	c_m = (
		engine_info.pole_pairs_count
		* engine_info.conductors_count
		/ (TAU * engine_info.branch_count)
	)
	c_n = (
		engine_info.pole_pairs_count
		* engine_info.conductors_count
		/ (60.0 * engine_info.branch_count)
	)
	wheel_radius = $wheel_rr/collision.shape.radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass


func _physics_process(delta: float):
	wheel_rpm = $wheel_rr.angular_velocity.length() * 30 / PI
	._physics_process(delta)


func _get_controller_pos(throttle_input: float, brake_input: float):
	if brake_input > 0.75:
		return ControllerPosition.BRAKE_3
	elif brake_input > 0.5:
		return ControllerPosition.BRAKE_2
	elif brake_input > 0:
		return ControllerPosition.BRAKE_1
	elif throttle_input > 0.75:
		return ControllerPosition.RUNNING_3
	elif throttle_input > 0.5:
		return ControllerPosition.RUNNING_2
	elif throttle_input > 0.25:
		return ControllerPosition.RUNNING_1
	elif throttle_input > 0:
		return ControllerPosition.MANEUVER
	else:
		return ControllerPosition.NEUTRAL
