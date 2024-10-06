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
	
# Getters
func get_id() -> int:
	return self.id

func get_year() -> int:
	return self.year

func get_dept() -> String:
	return self.dept

func get_mood() -> float:
	return self.mood

func get_lvl() -> float:
	return self.lvl

# Setters
func set_year(new_year: int) -> void:
	self.year = new_year
	
func set_mood(coeff: float) -> void:
	self.mood *= coeff

func set_lvl(coeff: float) -> void:
	self.lvl *= coeff
