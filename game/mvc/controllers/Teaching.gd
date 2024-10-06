class_name Teaching
extends Node

# Enregistreur
# Ajoute un enseignant au tableau.
func add_teacher(department: String) -> void:
	assert(department in Global.dept_list, "Unknown department: {}".format(department))
	var new_teacher: Teacher = Teacher.new(department)
	Global.teacher_list.append(new_teacher)

# Destructeur 1
# Supprime un enseigant du tableau par ID.
func rm_teacher_by_id(i: int) -> void:
	if i < Global.student_list.size() and i > 0:
		Global.student_list.remove_at(i)
		
# Destructeur 2
# Supprime un enseignant du tableau par département, en nombre spécifié.
func rm_teacher_by_dept(dept: String, nb: int) -> void:
	# Compter les enseignants du département concerné
	var count: int = 0
	for teacher in Global.teacher_list:
		if teacher.get_dept() == dept:
			count += 1
	
	# Vérifier le nombre d'enseignants à faire partir
	assert(nb <= count, "Tentative de suppression de {} enseignants sur {}.".format(str(nb), str(count)))
	
	# Supprimer nb enseignants du département concerné
	var rm_count: int = 0
	for i in range(Global.teacher_list.size() - 1, -1, -1):
		var teacher: Teacher = Global.teacher_list[i]
		# Vérifiez si l'enseignant appartient au département spécifié
		if teacher.get_dept() == dept:
			while rm_count >= count:
				Global.teacher_list.remove_at(i)
				rm_count += 1
	
# À implémenter ici : 
# func populate() -> void
# func compute_nb(dept: String) -> void:
# func avg_mood(dept: String) -> float:


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
