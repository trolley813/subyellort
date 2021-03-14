extends SpawnerManager

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1121, 1139) + range(1220, 1255) + range(1303, 1326):
		available_vehicles[str(i)] = preload("res://scenes/vehicles/trolleybus_proto.tscn")
	for i in range(2115, 2141) + range(2217, 2243):
		available_vehicles[str(i)] = preload("res://scenes/vehicles/trolleybus_proto.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
