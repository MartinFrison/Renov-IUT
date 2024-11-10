# Scenario.gd
class_name Scenario
extends RefCounted

var _name : String

func _init() -> void:
	pass
	

# Test si le jeu est fini
func test_end_game_condition() -> bool:
	push_error("test_end_game_condition() doit être implémentée.")
	return false

# Déclencher la fin du jeu
func end_game() -> void:
	push_error("end_game() doit être implémentée.")

# Génère un événement aléatoire avec des probabilités dépendant du scénario
func random_event() -> void:
	push_error("random_event() doit être implémentée.")

# Initialise le modèle en fonction du scénario
func init_data() -> void:
	push_error("random_event() doit être implémentée.")
	# Age et état des batiments
	# satisfaction etudiante par batiment
	# satisfaction prof par batiment
	# reussite par batiment
	# budget de base



# Obtenir le scénario actuel
func get_scenario() -> String:
	push_error("get_scenario() doit être implémentée.")
	return ""

# Ajuster le budget en appliquant un coefficient
func adjust_budget(coeff: float) -> void:
	push_error("adjust_budget() doit être implémentée.")

# Ajuster la satisfaction des étudiants en appliquant un coefficient
func adjust_student_satisfaction(coeff: float) -> void:
	push_error("adjust_student_satisfaction() doit être implémentée.")

# Ajuster la satisfaction des enseignants en appliquant un coefficient
func adjust_teacher_satisfaction(coeff: float) -> void:
	push_error("adjust_teacher_satisfaction() doit être implémentée.")

# Ajuster la probabilité d'appel pour un identifiant donné
func adjust_call_probability(call: int, coeff: float) -> void:
	push_error("adjust_call_probability() doit être implémentée.")

# Ajuster l'état d'un département en appliquant un coefficient
func adjust_dept_state(dept: String, coeff: float) -> void:
	push_error("adjust_dept_state() doit être implémentée.")
