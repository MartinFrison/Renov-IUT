class_name Bonhomme
extends Node3D

@export var distance: float = 300

@onready var animation_player = $AnimationPlayer

var visible_summer : bool # Définie si le bonhome doit rester visible en été


func _ready() -> void:
	# Définie la position de départ du bonhomme aléatoirement
	# pour les désyncroniser
	var x = Utils.randint_in_range(0,distance*0.7)
	translate(Vector3(0, 0, 0.1*x))
	rotate_object_local(Vector3(0, 1, 0), deg_to_rad(180))
	# Définie aléatoirement si le bonhome doit rester visible en été
	# la proba est de 30%
	visible_summer = (Utils.randint_in_range(0,100)<30)
	
	await get_tree().create_timer(Utils.randfloat_in_range(0.1,0.3)).timeout
	# Fait faire des aller - retour sans fin au bonhomme
	while true:
		translate(Vector3(0, 0, -0.1))
		await get_tree().create_timer(0.02).timeout
		x += 1
		if x>distance:
			x = 0
			rotate_object_local(Vector3(0, 1, 0), deg_to_rad(180))


# Lance l'animation de marche contente du bonhomme
func content():
	animation_player.play("Armature|marche_content")
	animation_player.get_animation("Armature|marche_content").loop = true
	setVisible()

# Lance l'animation de marche facher du bonhomme
func facher():
	animation_player.play("Armature|marche_facher")
	animation_player.get_animation("Armature|marche_facher").loop = true
	setVisible()

# Définie la visibilité du bonhomme
func setVisible():
	visible = visible_summer or GlobalData.get_season()!=1
