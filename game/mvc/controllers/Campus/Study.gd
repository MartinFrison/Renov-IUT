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
	# l'examen d'entrée influe sur le nombre de recru en première année uniquement.
	# Un autre facteur qui module ce nombre est l'attractivité de l'établissement.
	# (On considère que pour les A2 et A3 à l'initialisation les examens avait pour difficulté 0 par défaut)
	var coeff_exam = build.get_exam_entry() 
	match year:
		1:
			coeff = randf_range(1-fluct, 1+fluct) # 1ère année : juste la fluctuation à appliquer
		2:
			var coeff_1 = randf_range(1-fluct, 1+fluct) # 2e année : fluctuation et pourcentage entre 45% et 75%
			coeff = randf_range(0.45*coeff_1, 0.75*coeff_1)
			coeff_exam = 0
		3:
			var coeff_1 = randf_range(1-fluct, 1+fluct) # 3e année : fluctuation et pourcentage entre 75% et 100%
			# On triche un peu, comme si la 3e année dépendait de la 2e année actuelle, et non pas précédente
			var coeff_2 = randf_range(0.45*coeff_1, 0.75*coeff_1)
			coeff = randf_range(0.75*coeff_2, 1.0*coeff_2)
			coeff_exam = 0
		_:
			return 0
	
	# Calcule du nombre d'étudiant dans la promo tenant compte de la séléctivité des examens d'entrée
	# Au maximum le nb de recrus peut être divisé par 2, il ne peut pas être augmenter car les examens d'entrée 
	# sont par défaut au plus facile
	var nb_students = ceil(students_base_nb[dept-1] * coeff* (1-coeff_exam))
	
	# Le nombre de nouveaux inscrits dépend aussi de l'attractivité
	var k = 0.25
	var attr = GlobalData.get_attractivity()
	if attr > 0.5:
		nb_students = nb_students * (1 + k * attr) # augmente le nombre d'étudiants en 1ère année
	else:
		nb_students = nb_students * (1 - k * attr) # baisse le nombre d'étudiants en 1ère année
	
	if nb_students > 600:
		nb_students = 599
		
	# On rajoute tout les étudiant de la promo
	for i in range(0, nb_students):
		# On ajoute un étudiant et lui donne une satisfaction aléatoire selon la difficulté du jeu
		var id = Student.add_student(code, year)
		var mood = Utils.randfloat_in_range(GlobalData.adjust_satisfaction()*0.45,GlobalData.adjust_satisfaction()*0.8)
		Student.set_mood(id,mood)
		# On initialise le level selon la séléctivité des exams d'entrée et la difficulté du jeu 
		var level =  Utils.randfloat_in_range(GlobalData.adjust_level()*0.2,GlobalData.adjust_level()*0.9)
		# Recupere une partie des point manquant à l'élève pour arriver à 20/20 en fonction des examens d'entrées
		level += (1-level) * coeff_exam * GlobalData.adjust_level()
		Student.set_level(id,level)
		# valeur entre -0.4 et 0.4 qui depend du coeff des examens
		var base_level = (coeff_exam*0.4 + Utils.randfloat_in_square_range(0,0.6))-0.4
		Student.set_base_level(id, base_level)
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
	var message = "Les première année sont arrivés ! \n
	Ils sont au nombre de "
	
	for i in range(1,6): # le département
			n = populate_promo(i, 1)
			sum += n
			message_2 += "- %s étudiants dans le département %s.\n" % [n,Utils.dept_index_to_string(i)]
	

	message += str(sum) + "\n" + message_2
	await BulleGestion.send_notif("Début d'année " + str(GlobalData._year), message, 0)

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
			Student.add_graduate() # On l'ajoute au nombre total de diplomé
			if level> 0.8:
				# Si le niveau d'un etudiant est supérieur à 0.8 il peut 
				# rejoindre une école d'ingénieur
				Student.add_engineering()
		elif level> coeff_exam*0.7: # si l'étudiant a 70% du niveau requis il peut redoubler
			repeater += 1 # Ne rien faire, l'étudiant redouble simplement sont année
		else: #exclusion si pas le niveau
			Student.rm_student_by_id(student)

	return [count, success, repeater, graduate]


# Simule un passage à l'année suivante, en promouvant ceux qui restent et en excluant ceux qui n'ont pas le niveau et/ou l'envie
# Renvoie un rapport des examens par notification
static func pass_next_year() -> void:
	# Calcule le passage à l'année suivante des étudiants de chaque batiment
	var obj = "Examens de fin d'année"
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
		msg += "\nDans le département %s sur %s étudiants : " % [code, result[0]]
		msg += "%s année réussie, %s diplômés, " % [result[1],result[3]]
		msg += "%s redoublants et %s exclusions.\n" % [result[2], result[0]-result[1]-result[2]]
	
	
	var msg2 = "C'est la fin d'année. Les étudiants ont passé leur examens.\n"
	msg2 += "\nAu sein de l'IUT, sur %s étudiants :\n" % [global_result[0]]
	msg2 += "%s ont réussi leur année, dont %s ont eu leur diplôme ; " % [global_result[1],global_result[3]]
	msg2 += " %s ont redoublé et %s ont été exclus.\n" % [global_result[2], global_result[0]-global_result[1]-global_result[2]]
	msg = msg2 + msg
	BulleGestion.send_notif(obj,msg,0)


# Ajuster le niveau etudiant d'un departement selon le nb de profs et leur mood
# On calcule une valeur qui correspond au niveau vers lequel devrait tendre le niveau
# des étudiant si le contexte actuelle (nb de prof et satisfaction des prof)
# s'éternisait dans le temps
static func teacher_adjust_level() -> void:
	# Si on est pas en été
	if GlobalData.get_season()!=1: 
		const coeff = 1
		var value
		for i in range(1,6):
			var code = Utils.dept_index_to_string(i)
			var mood_teacher = Teacher.avg_mood_per_dept(code)
			var nb_teacher = Teacher.compute_nb_per_dept(code)
			var nb_student = Student.compute_nb_per_dept(code)
			var ratio = nb_teacher / nb_student
			
			# s'il n'y a pas de prof le niveau tend vers 0
			if nb_teacher <= 0:
				value = 0
			else:
				# le ratio nb_prof/nb_etudiant nécéssaire pour avoir une valeur élevé dépend aussi de la difficulté
				# On utilise une fonction sigmoide pour calculer une valeur a partir du ratio
				# valeur de la sigmoide: x=0 -> 0, x=0.2 -> 0.42, x=0.4 -> 0.85, x=1 -> 0.98
				var ratioValue = ratio*GlobalData.adjust_level()
				ratioValue *=2 # reduit simplement par 2 le nombre de prof nécéssaire à niveau egale
				var k = 10
				var x0 = 0.2
				ratioValue = 1 / (1 + exp(-k * (ratioValue - x0))) - (1 / (1 + exp(k * x0)))
				ratioValue /= 0.89
				# La valeur vers laquel tend le niveau etudiant dépend à 30% de la satisfaction 
				# enseigante et à 70% du ratio nb_prof/nb_etudiant
				value = mood_teacher * 0.3 + clamp(ratioValue, 0,1) * 0.7
			
			# On fait tendre le niveau étudiant vers la valeur définie
			Study.level_fluctuation(code, value, 0.3)


# Ajuster le mood etudiant selon si les portes des salles sont ouverte ou fermez
static func door_adjust_mood() -> void:
	# Si on est pas en été
	if GlobalData.get_season()!=1: 
		for i in range(1,6):
			var code = Utils.dept_index_to_string(i)
			var build = Building.get_building(code)
			
			# la difficulté ajuste les coefficients de maniere plus ou moins avantageuse
			if build.isDoorLocked():
				# si la porte est bloquer, les étudiants ne sont pas content
				# leur satisfaction tends vers 0
				Study.mood_fluctuation(code, 0, 0.08 / GlobalData.adjust_satisfaction())
			else:
				# sinon il sont content et leur satisfaction tend vers 1
				Study.mood_fluctuation(code, 1, 0.06 * GlobalData.adjust_satisfaction())




# Fluctuation de la satisfaction des étudiants 
# Fait tendre la satisfaction de chaque etudiant d'un batiment vers une certaine
# valeur comprise entre 0 et 1 avec un certain coeff compris entre 0 et 1
# Par exemple si on prend la valeur 0.7 et le coeff 0.5
# pour un etudiant dont la satisfaction est 0.5 la nouvelle valeur sera 0.6
# pour un etudiant dont la satisfaction est 0.9 la nouvelle valeur sera 0.8
static func mood_fluctuation(dept : String, value : float, coeff : float) -> void:
	value = clamp(value,0,1)

	var id = Student.get_dept_ids(dept)
	for i in id:
		# On rajoute un peu d'aléa
		var random = Utils.randfloat_in_range(0.8,1.2)
		var final_value = value
		if random > 1:
			final_value += (1-value) * (random-1)
		else:
			final_value *= random
		
		# On applique la valeur avec son coefficient
		var new_mood = Student.get_mood(i) * (1-coeff) + value * coeff
		Student.set_mood(i, new_mood)


# Fluctuation du niveau scolaire des étudiants 
# Fait tendre le niveau de chaque etudiant d'un batiment vers une certaine
# valeur comprise entre 0 et 1 avec un certain coeff compris entre 0 et 1
# Cette valeur est prise en entrée par la fonction mais est ajusté pour chaque étudiant
# en fonction de sa valeur base_level qui permet de garder des valeur plus hétérogène
# Par exemple si on prend la valeur 0.7 et le coeff 0.5
# pour un etudiant dont la niveau est 0.5 la nouvelle valeur sera 0.6
# pour un etudiant dont la niveau est 0.9 la nouvelle valeur sera 0.8
static func level_fluctuation(dept : String, value : float, coeff : float) -> void:
	value = clamp(value,0,1)
	var id = Student.get_dept_ids(dept)
	for i in id:
		# On redéfini la valeur ver laquel doit tendre le niveau de chaque etudiant
		# selon son niveau de base
		var final_value = value
		var base_level = Student.get_base_level(i)
		# si le niveau de base est negatif on soustrait un pourcentage de la valeur correspondant
		if base_level<0:
			final_value += value * base_level
		else:
			# si il est positif on ajoute à la valeur un pourcentage de ce qui 
			# lui manque pour atteindre 1
			# par exemple: si la valeur est 0.7 et que le niveau de base est 0.5
			# comme il manque 0.3 à la valeur 0.7 pour atteindre 1, on ajoute 0.3 * 0.5 soit 0.15
			final_value += (1-value) * base_level
		
		# On applique la valeur calculé précédement avec son coefficient
		var new_level = Student.get_level(i) * (1-coeff) + final_value * coeff
		Student.set_level(i, new_level)




static func student_resign() -> void:
	Student.rm_student_by_mood(0.2)








#
#static func drop_mood_student(dept : String, value : float) -> void:
	#value = max(0, value)
	#var id = Student.get_dept_ids(dept)
	#for i in id:
		#var mood = Student.get_mood(i) - Utils.randfloat_in_range(value * 0.65 / GlobalData.adjust_satisfaction(), value * 1.35 / GlobalData.adjust_satisfaction())
		#Student.set_mood(i, mood)
#
#static func boost_mood_student(dept : String, value : float) -> void:
	#value = max(0, value)
	#var id = Student.get_dept_ids(dept)
	#for i in id:
		#var mood = Student.get_mood(i) + Utils.randfloat_in_range(value * 0.65 * GlobalData.adjust_satisfaction(), value * 1.35 * GlobalData.adjust_satisfaction())
		#Student.set_mood(i, mood)
#
#
#static func drop_level_student(dept : String, value : float) -> void:
	#value = max(0, value)
	#var id = Student.get_dept_ids(dept)
	#for i in id:
		#var level = Student.get_level(i) - Utils.randfloat_in_range(value * 0.65 / GlobalData.adjust_level(), value * 1.35 / GlobalData.adjust_level())
		#Student.set_level(i, level)
#
#
#static func boost_level_student(dept : String, value : float) -> void:
	#value = max(0, value)
	#var id = Student.get_dept_ids(dept)
	#for i in id:
		#var level = Student.get_level(i) + Utils.randfloat_in_range(value * 0.65 * GlobalData.adjust_level(), value * 1.35 * GlobalData.adjust_level())
		#Student.set_level(i, level)
