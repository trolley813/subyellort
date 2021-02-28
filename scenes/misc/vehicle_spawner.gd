class_name VehicleSpawner
extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export(NodePath) var spawner_manager_path
export(bool) var user_controllable
var spawned_instance: TransportVehicle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawner_manager: SpawnerManager = get_node(spawner_manager_path)
	yield(spawner_manager, "ready")
	var scene_node = get_tree().get_root().get_child(0)
	var id_and_vehicle = spawner_manager.get_random_vehicle()
	var id: String = id_and_vehicle[0]
	var vehicle: PackedScene = id_and_vehicle[1]
	print("Spawning vehicle %s No. %s..." % [vehicle, id])
	spawned_instance = vehicle.instance()
	spawned_instance.vehicle_id = id
	print(scene_node)
	scene_node.call_deferred("add_child", spawned_instance)
	spawned_instance.user_controlled = user_controllable
	spawned_instance.transform = self.transform
	self.visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
