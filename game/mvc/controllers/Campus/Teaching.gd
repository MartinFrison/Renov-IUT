class_name Teaching
extends RefCounted

const teachers_base_nb: Array = [21, 24, 18, 27, 18] # chiffres réels tirés du site officiel de l'IUT Robert Schuman


# Fonction pour embaucher un professeur dans un département spécifique
static func hire_teachers(dept: String):
	#vérifie si il y a moins de 30 profs dans le batiment
	if Teacher.compute_nb_per_dept(dept) >= 30:
		await BulleGestion.send_message("Deja maximum d'enseignants dans ce bâtiment.",false)
		return

	#vérifie si un prof est prêt à être recruté
	if Teacher.avg_mood_per_dept(dept) < 0.6 and Teacher.compute_nb_per_dept(dept)!=0:
		await BulleGestion.send_message("Aucun professeur n'est volontaire pour enseigner 
		dans ce bâtiment.",false)
	else:
		Teacher.add_teacher(dept,true)
		print("Embauche d'un enseignant pour le département %s." % dept)



# Fonction pour licencier un professeur dans un département spécifique
static func fire_teachers(dept: String):
	#vérifie si il y a moins de 20 profs dans le batiments
	if Teacher.compute_nb_per_dept(dept) <= 0:
		await BulleGestion.send_message("Il n'y a déja plus aucun enseignant dans le batiment, catastrophe !",false)
		return
	
	Teacher.rm_teachers_by_dept(dept,1)
	print("Licenciement d'un enseignant pour le département %s." % dept)



# Fonction pour embaucher des enseignants au départ
static func populate():
	var nb_teachers = 0
	for i in range(1,6): # par département
		nb_teachers = teachers_base_nb[i-1]
		print(i)
		print(Teacher.compute_nb())
		for j in range (0, nb_teachers):
			Teacher.add_teacher(Utils.dept_index_to_string(i), true) # Au départ, on n'embauchera que des profs titulaires
		print(Teacher.compute_nb())

static func drop_mood_teacher(dept : String, value : float) -> void:
	value = max(0, value)
	var id = Teacher.get_dept_ids(dept)
	for i in id:
		Teacher.set_mood(i, Teacher.get_mood(i) - Utils.randfloat_in_range(value * 0.65 / GlobalData.adjust_satisfaction(), value * 1.35 / GlobalData.adjust_satisfaction()))

static func boost_mood_teacher(dept : String, value : float) -> void:
	value = max(0, value)
	var id = Teacher.get_dept_ids(dept)
	for i in id:
		Teacher.set_mood(i, Teacher.get_mood(i) + Utils.randfloat_in_range(value * 0.65 * GlobalData.adjust_satisfaction(), value * 1.35 * GlobalData.adjust_satisfaction()))

static func increase_salary(dept : String) -> void:
	var b = Building.get_building(dept)
	if b.get_pay_teacher() >= 4400:
		await BulleGestion.send_message("Le salaire des enseigants ne peut pas dépasser 4400 €", false)
	else:
		b.add_pay_teacher(800)


static func decrease_salary(dept : String) -> void:
	var b = Building.get_building(dept)
	if b.get_pay_teacher() <=2800:
		await BulleGestion.send_message("Le salaire des enseigants ne peut pas être inférieur à 2800 €", false)
	else:
		b.add_pay_teacher(-800)

static func teacher_resign() -> void:
	Teacher.rm_teacher_by_mood(0.2);





# Ajuster la satisfaction selon le salaire
static func pay_adjust_mood(day: int) -> void:
	for i in range(1,6):
		var value = 0
		var code = Utils.dept_index_to_string(i)
		if Building.get_building(code).get_pay_teacher() >= 4400:
			value = 0.2
		elif Building.get_building(code).get_pay_teacher() >= 3600:
			value = 0.1
		
		value = value /360 
		if value > 0:
			Study.boost_level_student(code, value * day)
		else:
			Study.drop_level_student(code, value * day)
