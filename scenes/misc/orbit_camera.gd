# Based on https://github.com/Tobalation/Godot-orbit-camera (MIT License)

class_name OrbitCamera
extends Spatial

# Control variables
export var max_pitch: float = 45
export var min_pitch: float = -45
export var max_zoom: float = 20
export var min_zoom: float = 4
export var zoom_step: float = 2
export var zoom_y_step: float = 0.15
export var vertical_sensitivity: float = 0.002
export var horizontal_sensitivity: float = 0.002
export var cam_y_offset: float = 4.0
export var cam_lerp_speed: float = 16.0
export (NodePath) var target

# Private variables
var _cam_target: Spatial = null
var _cam: ClippedCamera
var _cur_zoom: float = 0.0


func _ready() -> void:
	# Setup node references
	_cam_target = get_node(target)
	_cam = $camera

	# Setup camera position in rig
	_cam.translate(Vector3(0, cam_y_offset, max_zoom))
	_cur_zoom = max_zoom


func _input(event) -> void:
	if event is InputEventMouseMotion:
		# Rotate the rig around the target
		rotate_y(-event.relative.x * horizontal_sensitivity)
		rotation.x = clamp(
			rotation.x - event.relative.y * vertical_sensitivity,
			deg2rad(min_pitch),
			deg2rad(max_pitch)
		)
		orthonormalize()

	if event is InputEventMouseButton:
		# Change zoom level on mouse wheel rotation
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP and _cur_zoom > min_zoom:
				_cur_zoom -= zoom_step
				cam_y_offset -= zoom_y_step
			if event.button_index == BUTTON_WHEEL_DOWN and _cur_zoom < max_zoom:
				_cur_zoom += zoom_step
				cam_y_offset += zoom_y_step


func _process(delta) -> void:
	# zoom the camera accordingly
	_cam.set_translation(
		_cam.translation.linear_interpolate(
			Vector3(0, cam_y_offset, _cur_zoom), delta * cam_lerp_speed
		)
	)
	# set the position of the rig to follow the target
	set_translation(_cam_target.global_transform.origin)


func set_target(new_target: Spatial):
	_cam_target = new_target
