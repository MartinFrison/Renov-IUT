# Scenario.gd
class_name Scenario
extends RefCounted

var _name : String


func _init() -> void:
	init_building()
	init_data()

# Obtenir le scénario actuel
func get_scenario() -> String:
	return _name

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
func random_event_call(events_proba) -> void:		
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



# Initialise le modèle en fonction du scénario
	# satisfaction etudiante par batiment
	# satisfaction prof par batiment
	# reussite par batiment
	# budget de base
func init_data() -> void:
	print("populate")
	Study.populate()
	Teaching.populate()
	
	var students = Student.get_all_ids()
	var teachers = Teacher.get_all_ids()
	
	adjust_student_satisfaction(students)
	adjust_student_level(students)
	adjust_teacher_satisfaction(teachers)
	adjust_budget()
	



func init_building() -> void:
	for i in 5:
		var age = Utils.randint_in_range(5,50)
		# l'isolation et l'état est aléatoire et dépend de la difficulté
		var isolation = int(Utils.randint_in_range(20,80) * GlobalData.adjust_dept_state())
		var inventory = int(Utils.randint_in_range(20,100) * GlobalData.adjust_dept_state())
		
		var code = Utils.dept_index_to_string(i)
		var b = Building.new(age,isolation,1000, false, 2, code, inventory)	
		adjust_budget_building(b)





# Ajuster le budget des batiment en appliquant un coefficient
func adjust_budget_building(build : Building) -> void:
	push_error("adjust_budget_building() doit être implémentée.")


# Ajuster le budget en appliquant un coefficient
func adjust_budget() -> void:
	push_error("adjust_budget() doit être implémentée.")

# Ajuster la satisfaction des étudiants en appliquant un coefficient
func adjust_student_satisfaction(liste) -> void:
	push_error("adjust_student_satisfaction() doit être implémentée.")

# Ajuster la satisfaction des enseignants en appliquant un coefficient
func adjust_teacher_satisfaction(liste) -> void:
	push_error("adjust_teacher_satisfaction() doit être implémentée.")

# Ajuster la satisfaction des enseignants en appliquant un coefficient
func adjust_student_level(liste) -> void:
	push_error("adjust_student_level() doit être implémentée.")


# Ajuster l'état d'un département en appliquant un coefficient
func adjust_dept_state() -> void:
	push_error("adjust_dept_state() doit être implémentée.")
