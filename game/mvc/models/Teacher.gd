class_name Teacher
extends RefCounted

# Attributs
var id: int
var dept: String # le département où travaille la personne
var mood: float # taux de satisfaction, entre 0 et 1

# Constructeur
# On présume que les enseignants de l'IUT Robert Schuman sont tous très motivés 
# au moment d'intégrer l'établissement.
func _init(department: String):
	self.id = Global.teacher_list.size()  # Le premier numéro disponible est la taille actuelle du tableau
	self.dept = department
	self.mood = randf_range(0.85, 1.0)
	
# Getters
func get_id() -> int:
	return self.id

func get_dept() -> String:
	return self.dept

func get_mood() -> float:
	return self.mood

# Setters
func set_mood(coeff: float) -> void:
	self.mood *= coeff
