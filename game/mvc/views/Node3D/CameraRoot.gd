class_name CameraRoot
extends Node3D

var _default_scale
var _rot_Y = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialise la rotation de la camera
	_default_scale = scale
	rotate_root(0)


# Convertit les degrée en radiant
func curve_scale(degrees : float) -> float:
	var radians = deg_to_rad(degrees)  # Convertit en radians
	var result = sin(radians)  # Calcule le sinus
	return abs(result)

# Permet de faire tourner la camera dans un sens ou dans l'autre
func rotate_root(coeff : float):
	rotate_object_local(Vector3(0, 1, 0), deg_to_rad(coeff))
	_rot_Y += coeff
	if _rot_Y >= 360:
		_rot_Y -= 360
	if _rot_Y < 0:
		_rot_Y += 360
	scale = 0.9 * _default_scale * (1 + (curve_scale(_rot_Y)/1.7))

# Recois les entrez clavier tels que les fleches
func _input(event: InputEvent) -> void:
	# Si les fleche droite ou gauche sont presser on fait tourner la camera
	if event is InputEventKey and event.pressed:
		event = event as InputEventKey
		if event.keycode == KEY_RIGHT:
			rotate_root(1.5)
		elif event.keycode == KEY_LEFT:
			rotate_root(-1.5)

# Effectue une rotation lente a 360° pour le tutoriel
func rotate_tutorial(time : float):
	var delay = time/180
	for i in 180:
		rotate_root(2)
		await get_tree().create_timer(delay).timeout
