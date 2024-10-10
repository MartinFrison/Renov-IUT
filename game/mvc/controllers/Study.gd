class_name Study
extends Node

var prev_id: int = -1 # dernier index de département utilisé ; initialisé à -1 (sans étudiants)

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

# Destructeur 1
# Supprime un étudiant du tableau (par ID, car les départs, que ce soit une exclusion ou une promotion, 
# sont par définition nominatifs).
func rm_student_by_id(i: int) -> void:
	if i < Global.student_list.size() and i > 0:
		Global.student_list.remove_at(i)
		
# Destructeur 2
# Supprime un étudiant du tableau par département, en nombre spécifié.
func rm_student_by_dept(dept: String, nb: int) -> void:
	# Compter les enseignants du département concerné
	var count: int = 0
	for student in Global.student_list:
		if student.get_dept() == dept:
			count += 1
	
	# Vérifier le nombre d'enseignants à faire partir
	assert(nb <= count, "Tentative de suppression de {} étudiants sur {}.".format(str(nb), str(count)))
	
	# Supprimer nb enseignants du département concerné
	var rm_count: int = 0
	for i in range(Global.student_list.size() - 1, -1, -1):
		var student: Student = Global.student_list[i]
		# Vérifiez si l'enseignant appartient au département spécifié
		if student.get_dept() == dept:
			while rm_count >= count:
				Global.student_list.remove_at(i)
				rm_count += 1
				
# À implémenter ici : 
# func populate_year() -> void:
# func populate_promo() -> void:
# func evaluate() -> void:


# Renvoie le nombre d'étudiants pour tel département (passé en paramètre) 
func compute_nb(dept: String) -> int:
	var count: int = 0
	for student in Global.student_list:
		if student.dept == dept:
			count += 1
	return count

# Calcule et renvoie la moyenne de la satisfaction des étudiants, par département
func avg_mood(dept: String) -> float:
	var sum: float = 0.0
	for student in Global.student_list:
		if student.dept == dept:
			sum += student.mood
	var nb: int = compute_nb(dept)
	if nb == 0:
		return 0.0
	return sum / nb

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
