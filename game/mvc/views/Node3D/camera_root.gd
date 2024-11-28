extends Node3D

var _default_scale
var _scale_coeff = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_default_scale = scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_object_local(Vector3(0, 1, 0), deg_to_rad(0.1))
	scale = _default_scale * _scale_coeff
	_scale_coeff += 0.0001
