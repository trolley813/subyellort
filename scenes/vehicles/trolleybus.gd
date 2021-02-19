class_name Trolleybus
extends VehicleBody


class GRCPositionInfo:
	var armature_resistance: float
	var shunt_resistance: float
	var field_weakening: float

	func _init(armature_resistance: float, shunt_resistance: float, field_weakening: float):
		self.armature_resistance = armature_resistance
		self.shunt_resistance = shunt_resistance
		self.field_weakening = field_weakening


class ControllerPositionInfo:
	var max_grc_pos: int
	var min_current: float
	var is_pneumatic_brake: bool

	func _init(max_grc_pos: int, min_current: float, is_pneumatic_brake: bool):
		self.max_grc_pos = max_grc_pos
		self.min_current = min_current
		self.is_pneumatic_brake = is_pneumatic_brake


class EngineInfo:
	var grc_positions
	var ctrl_positions
	var conductors_count: int = 420
	var pole_pairs_count: int = 1
	var branch_count: int = 1
	var engine_resistance: int = 1
	var gear_ratio: float = 11.4


enum ControllerPosition {
	BRAKE_5,
	BRAKE_4,
	BRAKE_3,
	BRAKE_2,
	BRAKE_1,
	NEUTRAL,
	MANEUVER,
	RUNNING_1,
	RUNNING_2,
	RUNNING_3,
	RUNNING_4,
}

enum ReverserPosition { BACKWARD = -1, NEUTRAL = 0, FORWARD = 1 }

export var max_steer_angle = 45.0
export var wheel_radius = 0.5
export var grc_switch_time = 0.2
var steer_angle = 0.0
var controller_pos = ControllerPosition.NEUTRAL
var reverser_pos = ReverserPosition.NEUTRAL
var grc_pos = 0
var speed = 0.0
var engine_rpm = 0.0
var arm_current = 0.0
var emf = 0
var engine_info: EngineInfo = EngineInfo.new()
var time_to_grc_switch = 0.0
var c_m: float
var c_n: float
var grc_is_switching: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("vehicle_reverser_increase"):
		reverser_pos = clamp(reverser_pos + 1, ReverserPosition.BACKWARD, ReverserPosition.FORWARD)
	if Input.is_action_just_pressed("vehicle_reverser_decrease"):
		reverser_pos = clamp(reverser_pos - 1, ReverserPosition.BACKWARD, ReverserPosition.FORWARD)


func _physics_process(delta):
	var steer_val = (
		Input.get_action_strength("vehicle_steer_left")
		- Input.get_action_strength("vehicle_steer_right")
	)
	var throttle_val = Input.get_action_strength("vehicle_throttle")
	var brake_val = Input.get_action_strength("vehicle_brake")
	controller_pos = _get_controller_pos(throttle_val, brake_val)
	var grc_pos_info: GRCPositionInfo = engine_info.grc_positions[grc_pos]
	var ctrl_pos_info: ControllerPositionInfo = engine_info.ctrl_positions[controller_pos]
	var voltage = 550 if grc_pos >= 0 else 0
	speed = linear_velocity.length()
	engine_rpm = speed * 30 / (PI * wheel_radius) * engine_info.gear_ratio
	var flux = 0.06 #0.5 * (atan(0.01 * arm_current) + 0.03 * PI)
	emf = voltage - c_n * abs(engine_rpm) * flux * grc_pos_info.field_weakening
	arm_current = clamp(
		emf / (engine_info.engine_resistance + grc_pos_info.armature_resistance), -500, 500
	)
	if reverser_pos == ReverserPosition.NEUTRAL:
		arm_current = 0
	if time_to_grc_switch > 0:
		time_to_grc_switch -= delta
	else:
		time_to_grc_switch = 0
		if grc_is_switching:
			grc_pos += 1
			grc_is_switching = false
	if arm_current < 250 and grc_pos < ctrl_pos_info.max_grc_pos and not grc_is_switching:
		time_to_grc_switch = grc_switch_time
		grc_is_switching = true
	if controller_pos == ControllerPosition.NEUTRAL:
		grc_pos = 0
		arm_current = 0
	if ctrl_pos_info.is_pneumatic_brake:
		arm_current = 0
	if ctrl_pos_info.max_grc_pos < 0:
		grc_pos = ctrl_pos_info.max_grc_pos
	if ctrl_pos_info.is_pneumatic_brake:
		engine_force = 0
		brake = 100
	else:
		engine_force = 0.09 * c_n * arm_current * flux * reverser_pos * engine_rpm
		brake = 0
	steer_angle = max_steer_angle * steer_val
	steering = move_toward(steering, deg2rad(steer_angle), delta)


func _get_controller_pos(throttle_input: float, brake_input: float):
	push_error("get_ctrl_pos must be defined in child class")
