class_name Teaching
extends Node

# Enregistreur
# Ajoute un enseignant au tableau.
func add_teacher(department: String) -> void:
	assert(department in Global.dept_list, "Unknown department: {}".format(department))
	var new_teacher: Teacher = Teacher.new(department)
	Global.teacher_list.append(new_teacher)

# Destructeur 1
# Supprime un enseignant du tableau par ID.
func rm_teacher_by_id(i: int) -> void:
	if i < Global.teacher_list.size() and i >= 0:
		Global.teacher_list.remove_at(i)
		
# Destructeur 2
# Supprime un enseignant du tableau par département, en nombre spécifié.
func rm_teacher_by_dept(dept: String, nb: int) -> void:
	# Compter les enseignants du département concerné
	var count: int = compute_nb(dept)
	
	# Vérifier le nombre d'enseignants à faire partir
	assert(nb <= count, "Tentative de suppression de {} enseignants sur {}.".format(str(nb), str(count)))
	
	# Supprimer nb enseignants du département concerné
	var rm_count: int = 0
	for i in range(Global.teacher_list.size() - 1, -1, -1):
		var teacher: Teacher = Global.teacher_list[i]
		# Vérifiez si l'enseignant appartient au département spécifié
		if teacher.get_dept() == dept:
			Global.teacher_list.remove_at(i)
			rm_count += 1
			if rm_count >= nb:
				break;

# Embauche tous les enseignants, par département (données empruntées sur Ernest)
func populate() -> void:
	# 21 enseignants en Chimie
	for pers in range (21):
		add_teacher("Chimie")
		
	# 24 enseignants en Génie civil
	for pers in range (24):
		add_teacher("Génie civil")
		
	# 18 enseignants en Info-Comm
	for pers in range (18):
		add_teacher("Information-communication")
		
	# 27 enseignants en Informatique
	for pers in range (27):
		add_teacher("Informatique")
		
	# 18 enseignants en Techniques de commercialisation
	for pers in range (18):
		add_teacher("Techniques de commercialisation")
	
# Renvoie le nombre d'enseignants pour tel département (passé en paramètre) 
func compute_nb(dept: String) -> int:
	var count: int = 0
	for teacher in Global.teacher_list:
		if teacher.dept == dept:
			count += 1
	return count

# Calcule et renvoie la moyenne de la satisfaction des enseignants, par département
func avg_mood(dept: String) -> float:
	var sum: float = 0.0
	for teacher in Global.teacher_list:
		if teacher.dept == dept:
			sum += teacher.mood
	var nb: int = compute_nb(dept)
	if nb == 0:
		return 0.0
	return sum / nb

# Lors du premier appel
func _ready() -> void:
	populate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# ajouter la gestion des profs
	pass
