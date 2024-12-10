# Scenario.gd
class_name Scenario
extends Node

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

# Les actions du scénario qui ont lieu au cour de la partie
func mid_game() -> void:
	push_error("mid_game() doit être implémentée.")

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
	
	print("set mood & level")
	var students = Student.get_all_ids()
	var teachers = Teacher.get_all_ids()
	
	init_student_satisfaction(students)
	init_student_level(students)
	init_teacher_satisfaction(teachers)
	adjust_budget()
	



func init_building() -> void:
	for i in 5:
		var age = Utils.randint_in_range(5,50)
		# l'isolation et l'état est aléatoire et dépend de la difficulté
		var isolation = int(Utils.randint_in_range(20,80) * GlobalData.adjust_dept_state())
		var inventory = int(Utils.randint_in_range(20,100) * GlobalData.adjust_dept_state())
		
		var code = Utils.dept_index_to_string(i+1)
		var b = Building.new(age,1000, false, code, inventory)	
		adjust_budget_building(b)
		b.set_pay_teacher(2800)





# Ajuster le budget des batiment en appliquant un coefficient
func adjust_budget_building(build : Building) -> void:
	print("adjust_budget_building() doit être implémentée.")


# Ajuster le budget en appliquant un coefficient
func adjust_budget() -> void:
	print("adjust_budget() doit être implémentée.")

# Ajuster le level des étudiants en appliquant un coefficient
# Celui ci dépend également du coeff de l'examen d'entrée
func init_student_level(liste) -> void:
	var coeff_exam = []
	for i in range(1,6):
		coeff_exam.append(Building.get_building(Utils.dept_index_to_string(i)).get_exam_entry())
	for i in liste:
		var dept = Student.get_dept(i)
		var level =  Utils.randfloat_in_square_range(GlobalData.adjust_level()*0.4,GlobalData.adjust_level()*1)
		# Ajuste le level selon la difficulté des exams d'entrée de son département
		# Recupere une partie des point manquant à l'élève pour arriver à 20/20
		level += (1-level) * ((1-coeff_exam[Utils.dept_string_to_index(dept)-1])*0.4)
		Student.set_level(i,level)


# Ajuster la satisfaction des étudiants en appliquant un coefficient
func init_student_satisfaction(liste) -> void:
	for i in liste:
		var mood = Utils.randfloat_in_square_range(GlobalData.adjust_satisfaction()*0.4,GlobalData.adjust_satisfaction()*1)
		Student.set_mood(i,mood)

# Ajuster la satisfaction des enseignants en appliquant un coefficient
func init_teacher_satisfaction(liste) -> void:
	for i in liste:
		var mood =  Utils.randfloat_in_square_range(GlobalData.adjust_satisfaction()*0.4, GlobalData.adjust_satisfaction()*1)
		Teacher.set_mood(i,mood)



# Ajuster l'état d'un département en appliquant un coefficient
func adjust_dept_state() -> void:
	print("adjust_dept_state() doit être implémentée.")
