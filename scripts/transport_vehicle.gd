class_name TransportVehicle
extends Spatial

signal user_control_toggled

export var vehicle_id: String
export var user_controlled: bool = false setget set_user_controlled


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


func set_user_controlled(value: bool):
	user_controlled = value
	emit_signal("user_control_toggled", value)
