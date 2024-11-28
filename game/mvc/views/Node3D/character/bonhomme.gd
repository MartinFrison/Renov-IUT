class_name Bonhomme
extends Node3D

@onready var animation_player = $AnimationPlayer



func _ready() -> void:
	var x = Utils.randint_in_range(0,190)
	translate(Vector3(0, 0, 0.1*x))
	
	while true:
		translate(Vector3(0, 0, 0.1))
		await get_tree().create_timer(0.02).timeout
		x += 1
		if x>300:
			x = 0
			rotate_object_local(Vector3(0, 1, 0), deg_to_rad(180))


func content():
	animation_player.play("Armature|marche_content")
	animation_player.get_animation("Armature|marche_content").loop = true
	
	
func facher():
	animation_player.play("Armature|marche_facher")
	animation_player.get_animation("Armature|marche_facher").loop = true
	
