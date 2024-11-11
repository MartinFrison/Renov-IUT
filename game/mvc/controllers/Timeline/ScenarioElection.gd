class_name ScenarioElection
extends Scenario


func _init() -> void:
	_name = "Eléction"
	init_data()
	


# Test si le jeu est fini
func test_end_game_condition() -> bool:
	print("à compléter")
	return false

# Déclencher la fin du jeu
func end_game() -> void:
	print("à compléter")


# Génère un événement aléatoire avec des probabilités dépendant du scénario et d'autre condition
func random_event() -> void:
	var events_proba = []
	events_proba[0] = 1
	events_proba[1] = 1
	
	var sum_proba = 0
	for i in events_proba.size():
		sum_proba += events_proba[i]
	
	#Lance aléatoirement un event en respectant les proba de chaque event
	var rand = Utils.randfloat_in_range(0,sum_proba);
	var p = 0
	for i in events_proba.size():
		p += events_proba[i]
		if rand <= p:
			Event.create_event(i)
			return


# Initialise le modèle en fonction du scénario et de la difficulté
func init_data() -> void:
	var students = Student.get_all_ids()
	var teachers = Teacher.get_all_ids()
	# satisfaction etudiante
	for i in students:
		var mood = Utils.randfloat_in_square_range(GlobalData.adjust_satisfaction()*0.4,GlobalData.adjust_satisfaction()*1)
		Student.set_mood(i,mood)
	# satisfaction prof 
	for i in teachers:
		var mood =  Utils.randfloat_in_square_range(GlobalData.adjust_satisfaction()*0.4, GlobalData.adjust_satisfaction()*1)
		Teacher.set_mood(i,mood)
	# reussite 
	for i in students:
		var level =  Utils.randfloat_in_square_range(GlobalData.adjust_level()*0.4,GlobalData.adjust_level()*1)
		Student.set_level(i,level)
	# budget de base
	var budget = GlobalData.adjust_budget_initial()
	GlobalData.setBudget(budget)



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
