# Teacher.gd
extends RefCounted

class_name Teacher

# Attributs
var id: int
var dept: String # le département où travaille la personne
var mood: float # taux de satisfaction, entre 0 et 1

# Constructeur
# On présume que les enseignants de l'IUT Robert Schuman sont tous très motivés 
# au moment d'intégrer l'établissement.
func _init(department: String):  # dept1 est requis, depts peut accepter plusieurs départements
	self.id = Global.teacher_list.size()  # Le premier numéro disponible correspond à la taille actuelle du tableau
	self.dept = department
	self.mood = randf_range(0.85, 1.0)
	
# Enregistreur
# Ajoute un enseignant au tableau.
func add_teacher(department) -> void:
	var new_teacher: Teacher = Teacher.new(department)
	Global.teacher_list.append(new_teacher)

# Destructeur
# Supprime un enseigant du tableau (par ID).
func rm_teacher(i: int) -> void:
	if i < Global.student_list.size() and i > 0:
		Global.student_list.remove_at(i)
