class_name Student
extends RefCounted # ne nécessite pas d'interaction avec le moteur de scène

var prev_id: int = -1 # dernier index de département utilisé ; initialisé à -1 (sans étudiants)

# Attributs
var id: int # dans une version ultérieure, on pourrait donner un nom à chaque étudiant
var year: int # année d'étude, i.e. 1, 2 ou 3
var dept: String # département
var mood: float # taux de satisfaction, entre 0 et 1
var lvl: float # niveau académique, entre 0 et 1

# Constructeur
# Un nouvel étudiant arrive toujours en première année d'un département spécifique.
# Il est plutot motivé, mais pas plus que cela (70% de satisfaction minimum).
# Son niveau est supérieur à 0,5 mais rien n'est garanti au-delà.
func _init(department : String):
	self.id = Global.student_list.size() # le premier numéro disponible correspond à la taille actuelle du tableau
	self.year = 1
	self.dept = department
	self.mood = randf_range(0.7, 1.0)
	self.lvl = randf_range(0.5, 1.0)
	
# Enregistreur
# Ajoute un étudiant au tableau.
# Les départements alternent, pour avoir un nombre équilibré d'étudiants à chaque département.
func add_student() -> void:
	# Consulter le tableau des départment pour récupérer le départment suivant
	# le dernier utilisé
	var next_id: int = (prev_id + 1) % Global.dept_list.size()
	var next_dept: String = Global.dept_list[next_id]
	# Ajouter un nouvel étudiant à la liste globale
	var new_student: Student = Student.new(next_dept)
	Global.student_list.append(new_student)

# Destructeur
# Supprime un étudiant du tableau (par ID, car les départs, que ce soit une exclusion ou une promotion, 
# sont par définition nominatifs).
func rm_student(i: int) -> void:
	if i < Global.student_list.size() and i > 0:
		Global.student_list.remove_at(i)
