class_name SpawnerManager
extends Node

var available_vehicles = {}
var spawned_vehicles = {}
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func get_random_vehicle():
	var keys = available_vehicles.keys()
	var size = keys.size()
	assert(size != 0, "No vehicles to spawn")
	var key = keys[rng.randi_range(0, size - 1)]
	var vehicle = available_vehicles[key]
	available_vehicles.erase(key)
	spawned_vehicles[key] = vehicle
	return [key, vehicle]
