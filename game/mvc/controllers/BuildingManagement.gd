# BuildingManagement.gd
class_name BuildingManagement
extends RefCounted


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
		building.setDoorLocked(true)
		print("Porte verrouillée pour le département", dept)
	else:
		print("Aucun bâtiment trouvé pour le département", dept)

# Déverrouiller la porte du bâtiment pour le département donné
static func unlockDoor(dept: String) -> void:
	if Building.get_building(dept) != null:
		var building = Building.get_building(dept)
		building.setDoorLocked(false)
		print("Porte déverrouillée pour le département", dept)
	else:
		print("Aucun bâtiment trouvé pour le département", dept)
