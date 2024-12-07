class_name Bonhomme
extends Node3D

@export var distance: float = 300

@onready var animation_player = $AnimationPlayer

var visible_summer : bool

func _ready() -> void:
	
	var x = Utils.randint_in_range(0,distance*0.7)
	translate(Vector3(0, 0, 0.1*x))
	
	visible_summer = (Utils.randint_in_range(0,100)<20)
	
	await get_tree().create_timer(Utils.randfloat_in_range(0.1,0.3)).timeout
	
	while true:
		translate(Vector3(0, 0, 0.1))
		await get_tree().create_timer(0.02).timeout
		x += 1
		if x>distance:
			x = 0
			rotate_object_local(Vector3(0, 1, 0), deg_to_rad(180))


func content():
	animation_player.play("Armature|marche_content")
	animation_player.get_animation("Armature|marche_content").loop = true
	setVisible()
	
func facher():
	animation_player.play("Armature|marche_facher")
	animation_player.get_animation("Armature|marche_facher").loop = true
	setVisible()


func setVisible():
	visible = visible_summer or GlobalData._month<6 or GlobalData._month>8
