# BuildingManagement.gd
class_name BuildingManagement
extends RefCounted



# Avance les travaux d'un bâtiment donné
func advance_work(building: Building) -> void:
	var workers = building.get_ouvriers()
	if workers <= 0:
		return  # Pas d'ouvriers, pas d'avancement possible
	
	# Calcul de l'avancement par type de travaux
	var progress_per_worker = workers
	var insulation_increment = 0
	var renovation_increment = 0
	
	if building._is_insulation_underway and building._is_renovation_underway:
		# Les deux types de travaux sont en cours, progression divisée par 2
		insulation_increment = progress_per_worker / 2
		renovation_increment = progress_per_worker / 2
	elif building._is_insulation_underway:
		insulation_increment = progress_per_worker
	elif building._is_renovation_underway:
		renovation_increment = progress_per_worker
	
	# Mise à jour de l'isolation
	if building._is_insulation_underway:
		building.addIsolation(insulation_increment* Building.coeffTempsInsulation)
		if building.get_isolation() >= 100:
			building.set_insulation_underway(false)
	
	# Mise à jour de l'inventaire
	if building._is_renovation_underway:
		building.addInventory(renovation_increment* Building.coeffTempsRenovation)
		if building.get_inventory() >= 100:
			building.set_renovation_underway(false)



# Lancer des travaux d'isolation
static func start_insulation(building: Building) -> bool:
	if building.get_ouvriers() <= 0:
		print("Impossible de commencer les travaux : pas d'ouvriers disponibles.")
		return false  # Pas d'ouvriers, pas de travaux
	
	if building._is_insulation_underway:
		print("Travaux d'isolation déjà en cours pour le bâtiment", building.get_code())
		return false  # Travaux déjà en cours
	
	# Vérification des bâtiments libres
	var free_buildings = Building._buildingsDictionary.size() - Building._total_buildings_under_renovation
	if not building._is_renovation_underway and free_buildings * 450 < Student.compute_nb():
		print("Pas assez de bâtiments libres pour commencer les travaux.")
		return false
	
	# Démarrer les travaux d'isolation
	building.set_insulation_underway(true)
	
	print("Travaux d'isolation lancés pour le bâtiment", building.get_code())
	return true

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
	if not building._is_insulation_underway and free_buildings * 450 < Student.compute_nb():
		print("Pas assez de bâtiments libres pour commencer les travaux.")
		return false
	
	# Démarrer les travaux de rénovation
	building.set_renovation_underway(true)
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
