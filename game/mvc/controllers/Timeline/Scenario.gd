# Scenario.gd
class_name Scenario
extends RefCounted

var _name : String

func _init() -> void:
	init_data()
	init_building()

static func get_description() -> String:
	push_error("get_description() doit être implémentée.")
	return ""

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
	# satisfaction etudiante par batiment
	# satisfaction prof par batiment
	# reussite par batiment
	# budget de base


func init_building() -> void:
	for i in 5:
		var age = Utils.randint_in_range(5,50)
		# l'isolation et l'état est aléatoire et dépend de la difficulté
		var isolation = int(Utils.randint_in_range(20,80) * GlobalData.adjust_dept_state())
		var inventory = int(Utils.randint_in_range(20,100) * GlobalData.adjust_dept_state())
		
		var code = Utils.dept_index_to_string(i)
		var b = Building.new(age,isolation,1000, false, 2, code, inventory)
		
		# Definition d'un budget aléatoire qui dépend de la difficulté
		b.add_budget(GlobalData.adjust_budget_initial()*0.2 * Utils.randfloat_in_square_range(0.5, 1.5))


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
