class_name ScenarioElitisme
extends Scenario


var _progression : int


func _init() -> void:
	_progression = 0
	_name = "Elitiste"
	super._init()
	
	var msg = "Votre objectif est de formé l'élite de ce
	 pays en permettant à un maximum d'étudiants de rentrer en école d'ingénieur après leur BUT"
	await BulleGestion.send_message(msg, true)
	


static func get_description() -> String:
	return "Vous avez 5 ans pour préparer autant d'étudiants que possible à devenir ingénieur"


# Test si le jeu est fini
# Dans ce scénario il finit simplement au bout de 5 ans
func test_end_game_condition() -> bool:
	return (GlobalData._year == 2030 and GlobalData._month == 9 and  GlobalData._day == 1)



# Déclencher la fin du jeu
func end_game() -> void:
	print("fin du jeu")
	await BulleGestion.send_message("Votre manda de 5 ans est arrivé à son therme, 
	il est temps de faire le bilan", false)

	var scene = load("res://mvc/views/Node2D/FinJeu/PanelFinElitisme.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	await bulle.tree_exited


# Les actions du scénario qui ont lieu au cour de la partie
func mid_game() -> void:
	# A la fin de l'année on informe le joueur du succès cumulé de ses étudiants depuis son éléction
	if GlobalData.isEndofYear():
		var msg
		msg = "Le nombre d'étudiant ayant rejoins une école d'ingénieur sous votre 
		manda s'élève jusqu'à présent à %s" % [Student.get_engineering()]
		await BulleGestion.send_message(msg, true)
	

# Génère un événement aléatoire avec des probabilités dépendant du scénario et d'autre condition
func random_event() -> void:
	var events_proba = []
	events_proba.append(1)  # Proba de 1 pour l'event 0
	events_proba.append(1)  # Proba de 1 pour l'event 1
	super.random_event_call(events_proba) # appeler l'event dans la class parente




# Ajuster le budget des batiment en appliquant un coefficient
func adjust_budget_building(build : Building) -> void:
		# Definition d'un budget aléatoire qui dépend de la difficulté
		build.add_budget(GlobalData.adjust_budget_initial()*0.2 * Utils.randfloat_in_square_range(0.5, 1.5))


# Ajuster le budget en appliquant un coefficient
func adjust_budget() -> void:
	var budget = GlobalData.adjust_budget_initial() * Utils.randfloat_in_square_range(0.8, 1.2)
	GlobalData.setBudget(budget)

# Ajuster le level des étudiants en appliquant un coefficient
# Celui ci dépend également du coeff de l'examen d'entrée
func adjust_student_level(liste) -> void:
	var coeff_exam = []
	for i in range(1,6):
		coeff_exam.append(Building.get_building(Utils.dept_index_to_string(i)).get_exam_entry())
	for i in liste:
		var dept = Student.get_dept(i)
		var level =  Utils.randfloat_in_square_range(GlobalData.adjust_level()*0.4,GlobalData.adjust_level()*1)
		# Ajuste le level selon la difficulté des exams d'entrée de son département
		level += (1-level) * ((1-coeff_exam[Utils.dept_string_to_index(dept)-1])*0.4)
		Student.set_level(i,level)


# Ajuster la satisfaction des étudiants en appliquant un coefficient
func adjust_student_satisfaction(liste) -> void:
	for i in liste:
		var mood = Utils.randfloat_in_square_range(GlobalData.adjust_satisfaction()*0.4,GlobalData.adjust_satisfaction()*1)
		Student.set_mood(i,mood)

# Ajuster la satisfaction des enseignants en appliquant un coefficient
func adjust_teacher_satisfaction(liste) -> void:
	print("mood prof")
	for i in liste:
		var mood =  Utils.randfloat_in_square_range(GlobalData.adjust_satisfaction()*0.4, GlobalData.adjust_satisfaction()*1)
		Teacher.set_mood(i,mood)


# Ajuster l'état d'un département en appliquant un coefficient
func adjust_dept_state() -> void:
	print("à compléter")
