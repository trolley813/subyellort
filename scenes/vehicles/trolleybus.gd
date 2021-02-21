class_name Trolleybus
extends RigidBody


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

export (Array, NodePath) var steer_wheels
export (Array, NodePath) var traction_wheels

export var max_steer_angle = 45.0
var wheel_radius = 0.5
var wheel_rpm = 0.0
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
var driving_force: float
var brake_force: float


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
	speed = transform.basis.xform_inv(linear_velocity).z
	engine_rpm = wheel_rpm * engine_info.gear_ratio
	var flux = 0.04  #0.02 * (atan(0.01 * arm_current) + 0.5 * PI)
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
		driving_force = 0
		brake_force = 1000
		for w in traction_wheels + steer_wheels:
			var wheel: RigidBody = get_node(w)
			var torque = wheel.transform.basis.x * -brake_force
			wheel.add_torque(torque)
	else:
		driving_force = 0.9 * c_n * arm_current * reverser_pos
		brake_force = 0
	for w in traction_wheels:
		var wheel: RigidBody = get_node(w)
		var torque = transform.basis.x * driving_force
		wheel.add_torque(torque)
	steer_angle = move_toward(steer_angle, max_steer_angle * steer_val, delta * 20.0)
	for w in steer_wheels:
		var wheel: RigidBody = get_node(w)
		wheel.rotation_degrees.y = steer_angle


func _get_controller_pos(throttle_input: float, brake_input: float):
	push_error("get_ctrl_pos must be defined in child class")
