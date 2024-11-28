extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Node3D:
			content(child)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func facher(bonhomme : Node3D) -> void:
	var red = load("res://mvc/views/Node3D/character/bonome_rouge.tres") as StandardMaterial3D
	bonhomme = bonhomme as Bonhomme
	bonhomme.facher()
	for arm in bonhomme.get_children():
		for skel in arm.get_children():
			for mesh in skel.get_children():
				if mesh is MeshInstance3D:
					mesh.material_override = red


func content(bonhomme : Node3D) -> void:
	var green = load("res://mvc/views/Node3D/character/bonome_vert.tres") as StandardMaterial3D
	bonhomme = bonhomme as Bonhomme
	bonhomme.content()
	for arm in bonhomme.get_children():
		for skel in arm.get_children():
			for mesh in skel.get_children():
				if mesh is MeshInstance3D:
					mesh.material_override = green
