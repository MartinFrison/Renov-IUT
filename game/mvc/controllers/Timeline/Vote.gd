# Vote.gd
class_name Vote
extends Object


# Méthode pour déterminer si l'élection est gagnée
static func election_gagnee() -> bool:
	var student_popularity = popularity_among_students()
	var teacher_popularity = popularity_among_teachers()
	#election gagner si voix > 50%
	return (student_popularity + teacher_popularity) >= nb_voix_total()/2





#Voix total qu'il est possible de récolter par catégorie
static func nb_voix_teacher_per_dept(dept: String) -> int:
	return 20 #valeur provisoire à modifier 

static func nb_voix_student_per_dept(dept: String) -> int:
	return 10 #valeur provisoire à modifier 

static func nb_voix_per_dept(dept: String) -> int:
	var n 	= 0
	for c in Building._codeList:
		n += nb_voix_teacher_per_dept(c)
		n += nb_voix_student_per_dept(c)
	return n

static func nb_voix_teacher() -> int:
	var n 	= 0
	for c in Building._codeList:
		n += nb_voix_teacher_per_dept(c)
	return n

static func nb_voix_student() -> int:
	var n 	= 0
	for c in Building._codeList:
		n += nb_voix_student_per_dept(c)
	return n

static func nb_voix_total() -> int:
	return nb_voix_student() + nb_voix_teacher()





#Voix total effectivement gagner par catégorie
# Méthode pour obtenir le taux de popularité général (étudiants + enseignants)
static func popularity_rate() -> float:
	var student_popularity = popularity_among_students()
	var teacher_popularity = popularity_among_teachers()
	
	# Calcul du taux de popularité général, en prenant une moyenne pondérée (par exemple, 70 % étudiants et 30 % enseignants)
	return (0.7 * student_popularity) + (0.3 * teacher_popularity)

# Popularité parmi les étudiants
static func popularity_among_students() -> int:
	return 0

# Popularité parmi les enseignants
static func popularity_among_teachers() -> int:
	return 0

# Popularité parmi un département spécifique (étudiants + enseignants)
static func popularity_per_dept(dept: String) -> int:
	var student = popularity_among_students_per_dept(dept)
	var teacher = popularity_among_teachers_per_dept(dept)
	return student + teacher



# Popularité parmi les enseignants d'un département spécifique
static func popularity_among_teachers_per_dept(dept: String) -> int:
	#vote des professeurs dans un batiment
	return 0.0

# Popularité parmi les étudiants d'un département spécifique
static func popularity_among_students_per_dept(dept: String) -> int:
	#vote des etudiants dans un batiment
	return 0.0
