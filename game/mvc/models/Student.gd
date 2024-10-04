# Student.gd
extends RefCounted # ne nécessite pas d'interaction avec le moteur de scène

class_name Student

# Attributs
var id: int
var year: int # année d'étude, i.e. 1, 2 ou 3
var mood: float # taux de satisfaction, entre 0 et 1
var lvl: float # niveau académique, entre 0 et 1

# Constructeur
# Un nouvel étudiant arrive toujours en première année.
# Son état d'esprit, ainsi que son niveau sont supérieurs à 0,5 mais rien n'est garanti au-delà.
func _init():
	id = Global.student_list.size() # le premier numéro disponible correspond à la taille actuelle du tableau
	year = 1
	mood = randf_range(0.5, 1.0)
	lvl = randf_range(0.5, 1.0)
	
# Enregistreur
# Ajoute un étudiant au tableau.
func add_student() -> void:
	var new_student: Student = Student.new()
	Global.student_list.append(new_student)

# Destructeur
# Supprime un étudiant du tableau (par ID).
func rm_student(id: int) -> void:
	if id < Global.student_list.size() and id > 0:
		Global.student_list.remove_at(id)
