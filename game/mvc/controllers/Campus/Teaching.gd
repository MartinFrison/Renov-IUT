class_name Teaching
extends RefCounted

const teachers_base_nb: Array = [21, 24, 18, 27, 18] # chiffres réels tirés du site officiel de l'IUT Robert Schuman
const minimum_wage : int = 4000
const maximum_wage : int = 7000

# Fonction pour embaucher un professeur dans un département spécifique
# Si force est vrai le prof est embaucher sans conditions
static func hire_teachers(dept: String, force : bool):
	var nb_teacher = Teacher.compute_nb_per_dept(dept)
	# vérifie le nombre d'enseignants
	# celui-ci dépend de l'attractivité de l'établissement
	var limit = GlobalData.get_attractivity() * 50
	if !force and nb_teacher >= 50:
		await BulleGestion.send_message("Maximum d'enseignants atteint pour ce département, on n'embauche plus personne.",false)
		return

	#vérifie si un prof est prêt à être recruté
	if !force and (Teacher.avg_mood_per_dept(dept) < 0.3 and nb_teacher>=limit and nb_teacher!=0):
		await BulleGestion.send_message("Aucun professeur n'est volontaire pour enseigner 
		à ce département.",false)
	else:
		# Si oui on l'ajoute et définie aléatoirement sa satisfaction
		var id = Teacher.add_teacher(dept)
		var mood =  Utils.randfloat_in_range(GlobalData.adjust_satisfaction()*0.4, GlobalData.adjust_satisfaction()*0.65)
		Teacher.set_mood(id,mood)



# Fonction pour licencier un professeur dans un département spécifique
static func fire_teachers(dept: String):
	#vérifie si il y a moins de 20 profs dans le batiments
	if Teacher.compute_nb_per_dept(dept) <= 0:
		await BulleGestion.send_message("Plus aucun enseignant à ce département, catastrophe !",false)
		return
	
	# Le cout d'un licenciment est de 4 mois de salaire minimum
	var fire_cost = 4000 * 4
	if !await Expense.try_expense_dept(fire_cost, dept):
		return # Si on n'a pas d'argent pour payer le dédommagement on renvoie faux
	
	# Si le prof est bien renvoyer on le supprime de la base de donnée
	Teacher.rm_teachers_by_dept(dept,1)
	print("Licenciement d'un enseignant du département %s." % dept)



# Fonction pour embaucher des enseignants au départ
static func populate():
	print("Recrutement initial des enseignants...")
	var nb_teachers = 0
	var limit = (GlobalData.get_attractivity() / 2)
	var k = 0.25
	var attr = GlobalData.get_attractivity()
	 #print("attr = %s" % attr)
	
	for i in range(1,6): # par département, compte tenu de l'attractivité
		nb_teachers = teachers_base_nb[i-1]
	
		if attr > 0.5:
			nb_teachers = nb_teachers * (1 + k * attr) # augmente le nombre d'enseignants qui veulent travailler à l'IUT
		elif attr <= 0.5 :
			nb_teachers = nb_teachers * (1 - k * attr) # baisse le nombre d'enseignants qui sont partants
		
		for j in range (0, nb_teachers):
			# On l'embauche des prof est forcer au début du jeu
			hire_teachers(Utils.dept_index_to_string(i), true)




# Fluctuation de la satisfaction enseignante
# Fait tendre la satisfaction de chaque prof d'un batiment vers une certaine
# valeur comprise entre 0 et 1 avec un certain coeff compris entre 0 et 1
# Par exemple si on prend la valeur 0.7 et le coeff 0.5
# pour un prof dont la satisfaction est 0.5 la nouvelle valeur sera 0.6
# pour un prof dont la satisfaction est 0.9 la nouvelle valeur sera 0.8
static func mood_fluctuation(dept : String, value : float, coeff : float) -> void:
	value = clamp(value,0,1)
	var id = Teacher.get_dept_ids(dept)
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
		Teacher.set_mood(i, new_mood)


# Fonction pour augmenter le salaire des enseignants
# Encadrer par un salaire minimal et maximal
static func increase_salary(dept : String) -> void:
	var build = Building.get_building(dept)
	if build.get_pay_teacher() >= maximum_wage:
		await BulleGestion.send_message("Le salaire des enseigants ne peut pas dépasser 7000€.", false)
	else:
		build.add_pay_teacher(500)


# Fonction pour réduire le salaire des enseignants
# Encadrer par un salaire minimal et maximal
static func decrease_salary(dept : String) -> void:
	var build = Building.get_building(dept)
	if build.get_pay_teacher() <= minimum_wage:
		await BulleGestion.send_message("Les enseignants ne sont pas au SMIC, leur salaire ne peut pas être inférieur à 4000€.", false)
	else:
		build.add_pay_teacher(-(500))


# Les profs très mécontent quitte l'IUT
static func teacher_resign() -> void:
	Teacher.rm_teacher_by_mood(0.15);





# Ajuster la satisfaction selon le salaire
# la satisfaction de chaque profs tend vers une valeur qui dépend du salaire
static func pay_adjust_mood() -> void:
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		var build = Building.get_building(code)
		# Definition de la valeur avec un minimum de 0.4 pour le salaire minimal
		var value = 0.4
		value += float((build.get_pay_teacher()-minimum_wage)) / float((maximum_wage-minimum_wage)) * 0.6
		# Le coeff de base est 0.2, plus le salaire est élevé plus le coeff l'est aussi
		var coeff = 0.25
		coeff += float((build.get_pay_teacher()-minimum_wage)) / float((maximum_wage-minimum_wage)) * 0.2 # Le max est donc 0.45
		# On applique la valeur avec un coeff entre 25 et 45%%
		Teaching.mood_fluctuation(code, value, coeff)



#
#static func drop_mood_teacher(dept : String, value : float) -> void:
	#value = max(0, value)
	#var id = Teacher.get_dept_ids(dept)
	#for i in id:
		#var mood = Teacher.get_mood(i) - Utils.randfloat_in_range(value * 0.65 / GlobalData.adjust_satisfaction(), value * 1.35 / GlobalData.adjust_satisfaction())
		#Teacher.set_mood(i, mood)
#
#static func boost_mood_teacher(dept : String, value : float) -> void:
	#value = max(0, value)
	#var id = Teacher.get_dept_ids(dept)
	#for i in id:
		#var mood = Teacher.get_mood(i) + Utils.randfloat_in_range(value * 0.65 * GlobalData.adjust_satisfaction(), value * 1.35 * GlobalData.adjust_satisfaction())
		#Teacher.set_mood(i, mood)
