# Study.gd
# Gère la masse estudiantine.
class_name Study
extends RefCounted

const students_base_nb: Array = [88, 125, 30, 96, 112] # chiffres réels de 2024, tirés de ParcourSup, par département
const fluct = 0.1 # fluctiation, pour la 1ère année
const exam_base_result = 0.8 # On estime qu'à l'examen, on est sur de récupérer 80% de ses points de niveau courants (+ la chance)


# Inscrit tous les étudiants d'une année donnée	(1, 2 ou 3).
# À noter que cette fonction n'est utilisée qu'au début du jeu et calcule le nombre des 2e et des 3e année comme un pourcentage,
# sans traiter leur niveau comme ce sera fait au cours du jeu.
# retourne le nb d'étudiant inscrits
static func populate_promo(dept : int, year : int) -> int:
	var coeff = 0.0
	var code = Utils.dept_index_to_string(dept)
	var build = Building.get_building(code) 
	var coeff_exam = build.get_exam_entry() # l'exam d'entrée influ sur le nombre de recru
	match year:
		1:
			coeff = randf_range(1-fluct, 1+fluct) # 1ère année : juste la fluctuation à appliquer
		2:
			var coeff_1 = randf_range(1-fluct, 1+fluct) # 2e année : fluctuation et pourcentage entre 45% et 75%
			coeff = randf_range(0.45*coeff_1, 0.75*coeff_1)
		3:
			var coeff_1 = randf_range(1-fluct, 1+fluct) # 3e année : fluctuation et pourcentage entre 75% et 100%
			# On triche un peu, comme si la 3e année dépendait de la 2e année actuelle, et non pas précédente
			var coeff_2 = randf_range(0.45*coeff_1, 0.75*coeff_1)
			coeff = randf_range(0.75*coeff_2, 1.0*coeff_2)
		_:
			return 0
	
	var nb_students = ceil(students_base_nb[dept-1] * coeff* (1-coeff_exam))
	for i in range(0, nb_students):
		Student.add_student(code, year)
	return nb_students


# Inscrit tous les étudiants (ceux qui viennent du bac, mais aussi ceux, moins nombreux, qui sont passés en 2e et en 3e année)
static func populate() -> void:
	for i in range(1,6): # le département
		for j in range(1,4): # l'année
			populate_promo(i, j)


# Inscrit tous les étudiants de première année (ceux qui viennent du bac)
# Renvoie un rapport par notif
static func populate_new_year(scenario : Scenario) -> void:
	var sum = 0
	var n
	var message_2 = ""
	var message = "Les première année sont arrivée ! \n
	Ils sont au nombre de "
	
	for i in range(1,6): # le département
			n = populate_promo(i, 1)
			sum += n
			message_2 += "- %s étudiants dans le département %s.\n" % [n,Utils.dept_index_to_string(i)]
	
	# Initialiser le level et le mood des nouveaux étudiant
	var id = Student.get_all_ids()
	scenario.adjust_student_level(id)
	scenario.adjust_student_satisfaction(id)
	
	message += str(sum) + "\n" + message_2
	await BulleGestion.send_notif("Début d'année " + str(GlobalData._year), message, 0)


# Simule les examens basé uniquement sur la chance (certains scénarios peuvent appliquer des coefficients supplémentaires)
static func evaluate() -> void:
	var luck = randf_range(0.0, (1-exam_base_result)) # la chance peut soit se détourner de l'élève, soit lui permettre d'obtenir jusqu'à 20% (ici) de plus
	var exam: float = randf_range(exam_base_result, exam_base_result + luck)
	var id = Student.get_all_ids()
	for student in id:
		Student.set_level(student, exam)




# Calcule le passage à l'année suivante d'un batiment en utilisant le coeff de difficulté des exams finaux
# Renvoie la [nb_total, nb réussite, nb de redoublement, nb diplomés]
static func pass_dept_exam(dept : String) -> Array:
	var build = Building.get_building(dept)
	var coeff_exam = build.get_exam_end()
	var id = Student.get_dept_ids(dept)
	
	var count = id.size() # nb d'étudiant évaluer
	var graduate = 0 # nb de diplomés
	var repeater = 0 # nb redoublant
	var success = 0 # nb d'année réussit
	
	for student in id:
		var level = Student.get_level(student)
		var year = Student.get_year(student)
		if level>coeff_exam and year<3: # passage en année suivante qui dépend de la difficulté de l'exam final
			Student.set_year(student, Student.get_year(student)+1)
			success += 1
		elif level> coeff_exam and year>=3:
			#Obtention du diplome
			graduate += 1
			success += 1
			Student.rm_student_by_id(student)
			pass 
		elif level> coeff_exam*0.7: # si l'étudiant a 70% du niveau requis il peut redoubler
			repeater += 1 # Ne rien faire, l'étudiant redouble simplement sont année
		else: #exclusion si pas le niveau
			Student.rm_student_by_id(student)

	return [count, success, repeater, graduate]
	

# Simule un passage à l'année suivante, en promouvant ceux qui restent et en excluant ceux qui n'ont pas le niveau et/ou l'envie
# Renvoie un rapport des examens par notification
static func pass_next_year() -> void:
	#evaluate() 
	# Calcule le passage à l'année suivante des étudiants de chaque batiment
	var obj = "Examen de fin d'année"
	var msg = ""
	var global_result = [0,0,0,0]
	var result = [0,0,0,0]
	
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		result = pass_dept_exam(code)
		global_result[0] += result[0]
		global_result[1] += result[1]
		global_result[2] += result[2]
		global_result[3] += result[3]
		msg += "\nDans le département %s sur %s étudiants :\n" % [code, result[0]]
		msg += "%s année réussie, %s diplomés, " % [result[1],result[3]]
		msg += "%s redoublants et %s exclusions\n" % [result[2], result[0]-result[1]-result[2]]
	
	
	var msg2 = "C'est la fin d'année. Les étudiants ont passée leur examens.\n"
	msg2 += "\nAu sein de l'IUT, sur %s étudiants :\n" % [global_result[0]]
	msg2 += "   %s ont réussi leur année, dont %s ont eu leur diplome.\n" % [global_result[1],global_result[3]]
	msg2 += "   %s ont redoublé et %s ont été exclus.\n" % [global_result[2], global_result[0]-global_result[1]-global_result[2]]
	msg = msg2 + msg
	BulleGestion.send_notif(obj,msg,0)


# Ajuster le niveau etudiant d'un departement selon le nb de profs et leur mood
static func teacher_adjust_level(day: int) -> void:
	const coeff = 1
	var ratioStudentTeacher = 0
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		# s'il n'y a pas de prof on prend une valeur arbitraire
		if Teacher.compute_nb_per_dept(code) <= 0:
			ratioStudentTeacher = Student.compute_nb_per_dept(code)*3
		else:
			ratioStudentTeacher = Student.compute_nb_per_dept(code)/Teacher.compute_nb_per_dept(code)
		# Formule de l'ajustement selon le ratio prof-etudiant et le mood des profs
		var value : float = ((Teacher.avg_mood_per_dept(code)-0.5)+((1/ratioStudentTeacher)-0.1)*5)/360 
		if value > 0:
			print(Utils.dept_index_to_string(i))
			print(value)
			Study.boost_level_student(code, value * day)
		else:
			print(Utils.dept_index_to_string(i))
			print(value)
			Study.drop_level_student(code, -value * day)


# Ajuster le mood etudiant selon si les portes des salles sont ouverte ou fermez
static func door_adjust_mood(day : int) -> void:
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		var build = Building.get_building(code)
		var value = 0.05/360
		
		if build.isDoorLocked():
			Study.boost_level_student(code, value * day)
		else:
			Study.drop_level_student(code, value * day)




# Ajustement des stats des étudiants 

static func drop_mood_student(dept : String, value : float) -> void:
	value = max(0, value)
	var id = Student.get_dept_ids(dept)
	for i in id:
		Student.set_mood(i, Student.get_mood(i) - Utils.randfloat_in_range(value * 0.65 / GlobalData.adjust_satisfaction(), value * 1.35 / GlobalData.adjust_satisfaction()))

static func boost_mood_student(dept : String, value : float) -> void:
	value = max(0, value)
	var id = Student.get_dept_ids(dept)
	for i in id:
		Student.set_mood(i, Student.get_mood(i) + Utils.randfloat_in_range(value * 0.65 * GlobalData.adjust_satisfaction(), value * 1.35 * GlobalData.adjust_satisfaction()))


static func drop_level_student(dept : String, value : float) -> void:
	value = value#max(0, value)
	var id = Student.get_dept_ids(dept)
	for i in id:
		value = Utils.randfloat_in_range(value * 0.65 / GlobalData.adjust_level(), value * 1.35 / GlobalData.adjust_level())
		Student.set_level(i, Student.get_level(i) - value)


static func boost_level_student(dept : String, value : float) -> void:
	value = max(0, value)
	var id = Student.get_dept_ids(dept)
	for i in id:
		Student.set_level(i, Student.get_level(i) + Utils.randfloat_in_range(value * 0.65 * GlobalData.adjust_level(), value * 1.35 * GlobalData.adjust_level()))

static func student_resign() -> void:
	Student.rm_student_by_mood(0.2)
