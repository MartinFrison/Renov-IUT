class_name ScenarioElection
extends Scenario



# Test si le jeu est fini
func test_end_game_condition() -> bool:
	print("à compléter")
	return false

# Déclencher la fin du jeu
func end_game() -> void:
	print("à compléter")

# Génère un événement aléatoire avec des probabilités dépendant du scénario
func random_event() -> void:
	print("à compléter")

# Initialise le modèle en fonction du scénario et de la difficulté
func init_data() -> void:
	print("à compléter")
	# Age et état des batiments
	# satisfaction etudiante par batiment
	# satisfaction prof par batiment
	# reussite par batiment
	# budget de base




# Obtenir le scénario actuel
func get_scenario() -> String:
	return ""

# Ajuster le budget en appliquant un coefficient
func adjust_budget(coeff: float) -> void:
	print("à compléter")

# Ajuster la satisfaction des étudiants en appliquant un coefficient
func adjust_student_satisfaction(coeff: float) -> void:
	print("à compléter")

# Ajuster la satisfaction des enseignants en appliquant un coefficient
func adjust_teacher_satisfaction(coeff: float) -> void:
	print("à compléter")

# Ajuster la probabilité d'appel pour un identifiant donné
func adjust_call_probability(call: int, coeff: float) -> void:
	print("à compléter")

# Ajuster l'état d'un département en appliquant un coefficient
func adjust_dept_state(dept: String, coeff: float) -> void:
	print("à compléter")
