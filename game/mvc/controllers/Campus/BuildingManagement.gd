# BuildingManagement.gd
class_name BuildingManagement
extends RefCounted

# Instancis les batiments et leur valeur de départ
static func init_building() -> void:
	for i in range(1,6):
		var age = Utils.randint_in_range(5,50)
		# l'isolation et l'état est aléatoire et dépend de la difficulté
		var inventory = int(Utils.randfloat_in_square_range(30,100) * GlobalData.adjust_dept_state())
		
		# Surface des batiments:
		# chimie 5000m2, genie_civil 9000m2, info_com 2000m2
		# informatique 2500m2, technique_de_co 7000m2
		var surfaces = [5000,9000,2000,2500,7000]
		var surface = surfaces[i-1] # Selectionner la bonne surface
		
		
		
		# Instanciation du batiment
		var code = Utils.dept_index_to_string(i)
		var build = Building.new(age,surface, false, code, inventory)
		
		# Initialisation du salaire des profs et du budget
		Budget.init_budget_building(build)
		build.set_pay_teacher(4000)
		
		# On calcule le nombre de travailleur nécéssaire pour éviter la détérioration
		# Cela dépend de la surface et du type d'activité des batiments
		# chimie 7, genie_civil 9, info_com 2
		# informatique 2, technique_de_co 6
		var numbers = [7,9,2,2,6]
		var nb = numbers[i-1]
		for k in nb:
			build.add_ouvrier()





# Jongle entre les valeur 0.3, 0.4, 0.5, 0.6 et 0.7 pour la difficulté des exams
static func rise_end_exam_difficulty(dept : String) -> void:
	var build = Building.get_building(dept)
	var value = int(min(build.get_exam_end()+0.1, 0.7) *10 + 0.5)
	value = float(value)/10
	build.set_exam_end(value)

# Jongle entre les valeur 0.3, 0.4, 0.5, 0.6 et 0.7 pour la difficulté des exams
static func decrease_end_exam_difficulty(dept : String) -> void:
	var build = Building.get_building(dept)
	var value = int(max(build.get_exam_end()-0.1, 0.3) *10 + 0.5)
	value = float(value)/10
	build.set_exam_end(value)

# Jongle entre les valeur 0 0.25 et 0.5 pour la difficulté des exams
static func rise_entry_exam_difficulty(dept : String) -> void:
	var build = Building.get_building(dept)
	var value = int(min(build.get_exam_entry()+0.25, 0.5) *4 + 0.5)
	value = float(value)/4
	build.set_exam_entry(value)

# Jongle entre les valeur 0 0.25 et 0.5 pour la difficulté des exams
static func decrease_entry_exam_difficulty(dept : String) -> void:
	var build = Building.get_building(dept)
	var value = int(max(build.get_exam_entry()-0.25, 0) *4 + 0.5)
	value = float(value)/4
	build.set_exam_entry(value)



# Avance les travaux d'un bâtiment donné d'un trimestre
static func advance_work(building: Building) -> void:
	var workers = building.get_ouvriers()
	if workers <= 0:
		return  # Pas de personnel, pas d'avancement possible
	
	# Mise à jour de l'inventaire
	if building._is_renovation_underway:
		# Calcul de l'avancement des travaux
		var progress_per_worker = workers
		var renovation_increment = progress_per_worker * Building.coeffTempsRenovation
		building.addInventory(renovation_increment)
		# Si le batiment est rénover on signe la fin des travaux
		if building.get_inventory() >= 100:
			building.set_renovation_underway(false)
			RenovIUTApp.app.building_work(Utils.dept_string_to_index(building.get_code()), false)



# Demande à lancer des travaux de rénovation
# Retourne vrai si les travaux on bien été lancer
static func start_renovation(building: Building) -> bool:
	if building.get_ouvriers() <= 0:
		await BulleGestion.send_message("Impossible de commencer les travaux : pas 
		d'ouvriers disponibles.",false)
		return false  # Pas d'ouvriers, pas de travaux
	
	if building._is_renovation_underway:
		await BulleGestion.send_message("Travaux de rénovation déjà en cours 
		dans ce bâtiment.",false)
		return false  # Travaux déjà en cours

	
	# Vérification des bâtiments libres
	# Chaque batiment peut acueillir 300 étudiant, les batiments en travaux ne peuvent pas en accueillir
	# Il faut qu'il reste suffisament de place pour tout les étudiants de l'iut si on lance des travaux
	var free_buildings = Building._buildingsDictionary.size() - Building._total_buildings_under_renovation -1
	if free_buildings * 300 < Student.compute_nb():
		await BulleGestion.send_message("Pas assez de bâtiments libres pour 
		commencer les travaux.",false) 
		return false
	
	# On payent les cout fixe de la renovation et on anule les travaux si le budget est insuffisant
	var fixed_cost = Building.fixed_cost_renovation * (100-building.get_inventory()) / 100
	if !await Expense.try_expense_dept(fixed_cost, building.get_code()):
		return false
	
	# Démarrer les travaux de rénovation
	building.set_renovation_underway(true)
	RenovIUTApp.app.building_work(Utils.dept_string_to_index(building.get_code()), true)
	await BulleGestion.send_message("Travaux de rénovation lancés pour le 
	bâtiment " + building.get_code() + ".",false)
	return true


# Renvoyer un ouvrier pour le département donné
static func fireWorker(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		if building.get_ouvriers() > 0:
			building.remove_ouvrier()
			print("Personnel renvoyé pour le département ", dept, ". Nombre de personnels restants : ", building.get_ouvriers(), ".")
		else:
			print("Plus de personnels pour le département ", dept, ".")
	else:
		print("Aucun bâtiment trouvé pour le département ", dept, ".")



# Embaucher un administratif pour le département donné
static func hireWorker(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		if building.get_ouvriers()<10:
			building.add_ouvrier()
			print("Nouvel administratif embauché pour le département", dept, ". Nombre total d'administratifs :", building.get_ouvriers())
		else:
			await BulleGestion.send_message("Vous avez atteint la limite de personnels.",false)
	else:
		print("Aucun bâtiment trouvé pour le département ", dept, ".")






# Activer ou désactiver le chauffage pour le département donné
static func switchHeat(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		building.setHeat(!building.is_heating())  # Inverse l'état de chauffage
		print("Chauffage du département ", dept, " :", building.is_heating(), ".")
	else:
		print("Aucun bâtiment trouvé pour le département ", dept, ".")


# Renvoyer un agent de maintenance pour le département donné
static func fireAgent(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		building.rm_agent()
		print("Agent de maintenance renvoyé pour le département ", dept, ". Nombre d'agents restants : ", building.get_agents_nb(), ".")
	else:
		print("Aucun bâtiment trouvé pour le département ", dept, ".")


# Embaucher un agent de maintenance pour le département donné
static func hireAgent(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		building.add_agent()
		print("Nouvel agent de maintenance embauché pour le département ", dept, ". Nombre total d'agents :", building.get_agents_nb(), ".")
	else:
		print("Aucun bâtiment trouvé pour le département ", dept, ".")


# Verrouiller la porte du bâtiment pour le département donné
static func lockDoor(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		building.setDoorLocked(!building.isDoorLocked())
		print("Porte verrouillée pour le département ", dept, ".")
	else:
		print("Aucun bâtiment trouvé pour le département ", dept, ".")

# Détérioration trimestriel des batiments
static func wear() -> void:
	var wear : float
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		var build = Building.get_building(code)
		
		# On calcule le nombre de travailleur nécéssaire pour éviter la détérioration
		# Cela dépend de la surface et du type d'activité des batiments
		# chimie 7, genie_civil 9, info_com 2
		# informatique 2, technique_de_co 6
		var numbers = [7,9,2,2,6]
		var nb = numbers[i-1]
		
		# On définie la vitesse de détérioration selon le nombre de travailleur 
		# d'un batiment par rapport à celui attendu
		if build.get_ouvriers()==0: 
			# Cas spécial: s'il n'y a plus de travailleur, la dégradation est
			# catastrophique
			wear = 30
		else:
			wear = 10 * (max (1 - (build.get_ouvriers() / nb), 0))
			# Si les portes sont bloquée
			if build.isDoorLocked():
				# La vitesse de dégradation est divisé par 2
				wear /= 2
		
		#Appliquer la détérioration
		build.addInventory(-wear)













# Calcule l'attractivité à base des paramètres suivants :
# 	les résultats académiques
#   la satisfaction de tout le monde
#   le ratio enseignants/étudiants (pour mesurer l'attention accordée aux étudiants ; ici, 1:20 est considéré comme idéal)
#   l'état des infrastructures
static func compute_attractivity() -> void:
	var target = 1.0 / 20.0  # 1 professeur pour 20 étudiants
	var attention = Teacher.compute_nb() / Student.compute_nb()
	# transformer en pourcentage si le ratio initial n'est pas atteint, sinon 100% si les profs sont encore plus nombreux
	if attention <= target:
		attention = attention/target
	else:
		attention = 1.0
	
	#var success = Student.success_rate() #déjà un pourcentage
	var mood : float = (Teacher.avg_mood() + Student.avg_mood()) / 2
	var campus : float # pour obtenir la moyenne de l'état des bâtiments
	var sum : float = 0.0
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		sum += Building.get_building(code).get_inventory() / 100
	campus = sum / 5
	
	var new_value = round((mood + campus + attention) / 3 * 100) / 100  # Arrondir à 2 décimales
	GlobalData.set_attractivity(new_value)


static func adjust_attractivity() -> void:
	var new_value
	var fluctuation : float
	var performance : float = Student.avg_level() # on ajuste en fonction du niveau des étudiants
	# idéalement, il faudrait trouver une modélisation mathématique un minimum correcte ;
	# pour l'instant, cela ne fait que donner une priorité aléatoire à un critère.
	# Et que cela ne soit pas au pif.
	if performance >= 0.7: # i.e. 14/20 de moyenne globale
		fluctuation = Utils.randfloat_in_range(1.2, 1.4)
	elif performance >= 0.5: # i.e. 10/20 de moyenne globale
		fluctuation = Utils.randfloat_in_range(1.0, 1.2)
	else: # donner une chance, même
		fluctuation = Utils.randfloat_in_range(0.9, 1.1)
	new_value *= fluctuation
	if new_value > 1:
		new_value = .99
	
	new_value = round(new_value * 100) / 100
	GlobalData.set_attractivity(new_value)
