class_name Trolleybus
extends VehicleBody

class GRCPositionInfo:
    var position_num: int
    var armature_resistance: float
    var shunt_resistance: float
    var field_weakening: float

class ControllerPositionInfo:
    var ctrl_pos
    var max_grc_pos: int
    var min_current: float
    var is_pneumatic_brake: bool

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
var steer_angle = 0.0
var controller_pos = ControllerPosition.NEUTRAL
var reverser_pos = ReverserPosition.NEUTRAL
var engine_info = EngineInfo.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_just_pressed("vehicle_reverser_increase"):
        reverser_pos = clamp(reverser_pos + 1, ReverserPosition.BACKWARD, ReverserPosition.FORWARD)
    if Input.is_action_just_pressed("vehicle_reverser_decrease"):
        reverser_pos = clamp(reverser_pos - 1, ReverserPosition.BACKWARD, ReverserPosition.FORWARD)

func _physics_process(delta):
    var steer_val = 0.0
    var throttle_val = 0.0
    var brake_val = 0.0
    throttle_val = Input.get_action_strength("vehicle_throttle")
    brake_val = Input.get_action_strength("vehicle_brake")
    steer_val = Input.get_action_strength("vehicle_steer_left") - Input.get_action_strength("vehicle_steer_right")
    engine_force = 8000 * throttle_val * reverser_pos
    steer_angle = max_steer_angle * steer_val
    steering = deg2rad(steer_angle)
