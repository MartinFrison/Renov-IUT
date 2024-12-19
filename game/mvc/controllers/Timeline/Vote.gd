# Vote.gd
class_name Vote
extends Object


# Méthode pour déterminer si l'élection est gagnée
static func election_gagnee() -> bool:
	#election gagner si voix > 50%
	return popularity_total() >= nb_voix_total()/2






#Voix totales qu'il est possible de récolter par catégorie

# Calcule le nombre d'enseignant pouvant voter dans un département
# Un peu plus de 1 prof sur 2.8 peut voter
static func nb_voix_teacher_per_dept(dept: String) -> int:
	return int(Teacher.compute_nb_per_dept(dept) / 2.8 + 1)

# Calcule le nombre d'étudiant pouvant voter dans un département
# Un peu plus de 1 etudiant sur 200 peut voter
static func nb_voix_student_per_dept(dept: String) -> int:
	return int(Student.compute_nb_per_dept(dept) / 200 + 1)

# Nombre de votant dans un batiment lors de l'éléction (étudiant et élève)
static func nb_voix_per_dept(dept: String) -> int:
	var n = nb_voix_teacher_per_dept(dept) + nb_voix_student_per_dept(dept)
	return n

# Nombre d'enseignant votant lors de l'éléction
# Correspond à la somme des représentant enseignant par département
static func nb_voix_teacher() -> int:
	var n 	= 0
	for i in 5:
		var c = Utils.dept_index_to_string(i+1)
		n += nb_voix_teacher_per_dept(c)
	return n

# Nombre d'étudiant votant lors de l'éléction
# Correspond à la somme des représentant étudiant par département
static func nb_voix_student() -> int:
	var n 	= 0
	for i in 5:
		var c = Utils.dept_index_to_string(i+1)
		n += nb_voix_student_per_dept(c)
	return n

# Nombre de votant lors de l'éléction
static func nb_voix_total() -> int:
	return nb_voix_student() + nb_voix_teacher()






# Voix gagnée effectivement gagner par catégorie
# Ces voix ce calcule en pourcentage du nombre de voix récupérable qui est lui même 
# calculer ci dessus


# Voix gagnée Total
static func popularity_total() -> float:
	var student_popularity = popularity_among_students()
	var teacher_popularity = popularity_among_teachers()
	return student_popularity + teacher_popularity

# Voix gagnée parmi les étudiants
static func popularity_among_students() -> int:
	var n 	= 0
	for i in 5:
		var c = Utils.dept_index_to_string(i+1)
		n += popularity_among_students_per_dept(c)
	return n

# Voix gagnée  parmi les enseignants
static func popularity_among_teachers() -> int:
	var n 	= 0
	for i in 5:
		var c = Utils.dept_index_to_string(1)
		n += popularity_among_teachers_per_dept(c)
	return n

# Voix gagnée  parmi un département spécifique (étudiants + enseignants)
static func popularity_per_dept(dept: String) -> int:
	var student = popularity_among_students_per_dept(dept)
	var teacher = popularity_among_teachers_per_dept(dept)
	return student + teacher



# C'est ici que les voix se calcule réellement
# Les fonction ci dessus ne font que des sommes de voix précompté dans ces fonction:

# Voix gagnée parmi les enseignants d'un département spécifique
static func popularity_among_teachers_per_dept(dept: String) -> int:
	# l'opinion d'un prof dépend principalement de sa satisfaction, 
	# un peu de celle des étudiants et de leur réussite ainsi que du budget restant
	var coeff = Teacher.avg_mood_per_dept(dept)*0.6
	coeff += Student.avg_mood_per_dept(dept)*0.1
	# Le nombre de diplomé a un impact de 20% sur le vote et on en attend 1500 au total
	coeff += min(1,(Student.get_graduate()/1500)) * 0.2
	# Calcule de l'impact du budget restant sur la base du budget initial avec un coeff de 10%
	coeff += 0.1 * (min(1,GlobalData.getTotalBudget() / (GlobalData.adjust_budget_initial()*3)))
	#calcule du taux de voix avec une fonction logistique
	coeff = logistic_function(coeff)
	#calcule du nombre de voix recu selon le coeff et le nb de votant
	var n = int((nb_voix_teacher_per_dept(dept) * coeff)+0.49)
	return n


# Voix gagnée  parmi les étudiants d'un département spécifique
static func popularity_among_students_per_dept(dept: String) -> int:
	#l'opinion des etudiants dépend de leurs satisfactions et de leur réussite
	var coeff = Student.avg_mood_per_dept(dept)*0.65
	coeff += Student.avg_level_per_dept(dept)*0.35
	#calcule du taux de voix avec une fonction logistique
	coeff = logistic_function(coeff)
	#calcule du nombre de voix recu selon le coeff et le nb de votant
	var n = int((nb_voix_student_per_dept(dept) * coeff)+0.49)
	return n


#Fonction logistique pour calculer le nombre de voie
static func logistic_function(x: float, k: float = 5.0) -> float:
	return exp(k * (x - 0.5)) / (1 + exp(k * (x - 0.5)))
