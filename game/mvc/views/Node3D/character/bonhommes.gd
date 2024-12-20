extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ObserverPopulation.addObserver(self)
	


# Quand la satisfaction change, on reset la couleur des bonhomme selon la satisfaction
# de facon aléatoire
func notifySatisfactionChanged() -> void:
	var mood_global = Student.avg_mood() * 0.8 + Teacher.avg_mood() *0.2
	# Pour chaque bonhomme l'humeur est définie aléatoirement en prenant
	# en compte la satisfaction
	for child in get_children():
		if child is Node3D:
			if Utils.randfloat_in_range(0,1) <= mood_global:
				content(child)
			else:
				facher(child)



# Rend un bonhomme facher
func facher(bonhomme : Node3D) -> void:
	var red = load("res://mvc/views/Node3D/character/bonome_rouge.tres") as StandardMaterial3D
	bonhomme = bonhomme as Bonhomme
	bonhomme.facher()
	for arm in bonhomme.get_children():
		for skel in arm.get_children():
			for mesh in skel.get_children():
				if mesh is MeshInstance3D:
					mesh.material_override = red


# Rend un bonhomme content
func content(bonhomme : Node3D) -> void:
	var green = load("res://mvc/views/Node3D/character/bonome_vert.tres") as StandardMaterial3D
	bonhomme = bonhomme as Bonhomme
	bonhomme.content()
	for arm in bonhomme.get_children():
		for skel in arm.get_children():
			for mesh in skel.get_children():
				if mesh is MeshInstance3D:
					mesh.material_override = green
