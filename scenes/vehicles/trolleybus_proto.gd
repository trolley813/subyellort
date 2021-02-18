extends Trolleybus


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
    pass


func _physics_process(delta: float):
    ._physics_process(delta)
    $wheel_fl.rotation.y = steer_angle
    $wheel_fr.rotation.y = steer_angle
