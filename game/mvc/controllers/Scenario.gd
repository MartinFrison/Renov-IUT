# Scenario.gd
class_name Scenario
extends Node

# Attributs
var scenario_value: int = 0  # Valeur du scénario (entre 0 et 2)


# Obtenir le scénario actuel
func get_scenario() -> int:
	return scenario_value

# Définir un nouveau scénario (entre 0 et 2)
func set_scenario(n: int) -> void:
	if n >= 0 and n <= 2:
		scenario_value = n
	else:
		print("Erreur: le scénario doit être entre 0 et 2.")

# Ajuster le budget en appliquant un coefficient
func adjust_budget(coeff: float) -> void:
	print("Nouveau budget:")

# Ajuster la satisfaction des étudiants en appliquant un coefficient
func adjust_student_satisfaction(coeff: float) -> void:
	print("Nouvelle satisfaction des étudiants:")

# Ajuster la satisfaction des enseignants en appliquant un coefficient
func adjust_teacher_satisfaction(coeff: float) -> void:
	print("Nouvelle satisfaction des enseignants:")

# Ajuster la probabilité d'appel pour un identifiant donné
func adjust_call_probability(call: int, coeff: float) -> void:
	print("Probabilité d'appel")

# Ajuster l'état d'un département en appliquant un coefficient
func adjust_dept_state(dept: String, coeff: float) -> void:
	print("État du département")
