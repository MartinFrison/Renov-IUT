# BuildingManagement.gd
class_name BuildingManagement
extends RefCounted



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



# Avance les travaux d'un bâtiment donné pour un nb de jours donnée
static func advance_work(building: Building, day : int) -> void:
	var workers = building.get_ouvriers()
	if workers <= 0:
		return  # Pas d'ouvriers, pas d'avancement possible
	
	# Calcul de l'avancement par type de travaux
	var progress_per_worker = workers
	var renovation_increment = 0
	
	if building._is_renovation_underway:
		renovation_increment = progress_per_worker
	
	# Mise à jour de l'inventaire
	if building._is_renovation_underway:
		building.addInventory(renovation_increment* Building.coeffTempsRenovation* day)
		if building.get_inventory() >= 100:
			building.set_renovation_underway(false)
			RenovIUTApp.app.building_work(Utils.dept_string_to_index(building.get_code()), false)



# Lancer des travaux de rénovation
static func start_renovation(building: Building) -> bool:
	if building.get_ouvriers() <= 0:
		print("Impossible de commencer les travaux : pas d'ouvriers disponibles.")
		return false  # Pas d'ouvriers, pas de travaux
	
	if building._is_renovation_underway:
		print("Travaux de rénovation déjà en cours pour le bâtiment", building.get_code())
		return false  # Travaux déjà en cours
	
	# Vérification des bâtiments libres
	var free_buildings = Building._buildingsDictionary.size() - Building._total_buildings_under_renovation
	if free_buildings * 450 < Student.compute_nb():
		print("Pas assez de bâtiments libres pour commencer les travaux.")
		return false
	
	# Démarrer les travaux de rénovation
	building.set_renovation_underway(true)
	RenovIUTApp.app.building_work(Utils.dept_string_to_index(building.get_code()), true)
	print("Travaux de rénovation lancés pour le bâtiment", building.get_code())
	return true


# Renvoyer un ouvrier pour le département donné
static func fireWorker(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		if building.get_ouvriers() > 0:
			building.remove_ouvrier()
			print("Ouvrier renvoyé pour le département", dept, ". Nombre d'ouvriers restants :", building.get_ouvriers())
		else:
			print("Aucun ouvrier disponible à renvoyer pour le département", dept)
	else:
		print("Aucun bâtiment trouvé pour le département", dept)



# Embaucher un ouvrier pour le département donné
static func hireWorker(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		building.add_ouvrier()
		print("Nouvel ouvrier embauché pour le département", dept, ". Nombre total d'ouvriers :", building.get_ouvriers())
	else:
		print("Aucun bâtiment trouvé pour le département", dept)






# Activer ou désactiver le chauffage pour le département donné
static func switchHeat(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		building.setHeat(!building.is_heating())  # Inverse l'état de chauffage
		print("Chauffage du département", dept, ":", building.is_heating())
	else:
		print("Aucun bâtiment trouvé pour le département", dept)


# Renvoyer un agent de maintenance pour le département donné
static func fireAgent(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		building.rm_agent()
		print("Agent de maintenance renvoyé pour le département", dept, ". Nombre d'agents restants :", building.get_agents_nb())
	else:
		print("Aucun bâtiment trouvé pour le département", dept)


# Embaucher un agent de maintenance pour le département donné
static func hireAgent(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		building.add_agent()
		print("Nouvel agent de maintenance embauché pour le département", dept, ". Nombre total d'agents :", building.get_agents_nb())
	else:
		print("Aucun bâtiment trouvé pour le département", dept)


# Verrouiller la porte du bâtiment pour le département donné
static func lockDoor(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		building.setDoorLocked(!building.isDoorLocked())
		print("Porte verrouillée pour le département", dept)
	else:
		print("Aucun bâtiment trouvé pour le département", dept)

# Détérioration trimestriel des batiments
static func wear() -> void:
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		var b = Building.get_building(code)
		b.addInventory(-0.02 * 90) #soit environs 15 ans pour une détérioration total  
