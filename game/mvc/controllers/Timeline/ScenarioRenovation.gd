class_name ScenarioRenovation
extends Scenario


func _init() -> void:
	_name = "Renovation"
	super._init()


static func get_description() -> String:
	return "Un scenario dans lequel votre but est de renover un batiment"


# Test si le jeu est fini
# Dans ce scénario il finit simplement au bout de 5 ans
func test_end_game_condition() -> bool:
	return (GlobalData._year == 2030 and GlobalData._month == 9 and  GlobalData._day == 1)


# Déclencher la fin du jeu
func end_game() -> void:
	print("à compléter")



# Génère un événement aléatoire avec des probabilités dépendant du scénario et d'autre condition
func random_event() -> void:
	var events_proba = []
	events_proba.append(1)  # Proba de 1 pour l'event 0
	events_proba.append(1)  # Proba de 1 pour l'event 1
	super.random_event_call(events_proba) # appeler l'event dans la class parente


# Initialise le modèle en fonction du scénario et de la difficulté
func init_data() -> void:
	super.init_data()




# Ajuster le budget des batiment en appliquant un coefficient
func adjust_budget_building(build : Building) -> void:
		# Definition d'un budget aléatoire qui dépend de la difficulté
		build.add_budget(GlobalData.adjust_budget_initial()*0.2 * Utils.randfloat_in_square_range(0.5, 1.5))


# Ajuster le budget en appliquant un coefficient
func adjust_budget() -> void:
	var budget = GlobalData.adjust_budget_initial() * Utils.randfloat_in_square_range(0.8, 1.2)
	GlobalData.setBudget(budget)


# Ajuster la satisfaction des étudiants en appliquant un coefficient
func adjust_student_satisfaction(liste) -> void:
	for i in liste:
		var mood = Utils.randfloat_in_square_range(GlobalData.adjust_satisfaction()*0.4,GlobalData.adjust_satisfaction()*1)
		Student.set_mood(i,mood)
		var level =  Utils.randfloat_in_square_range(GlobalData.adjust_level()*0.4,GlobalData.adjust_level()*1)
		Student.set_level(i,level)


# Ajuster la satisfaction des enseignants en appliquant un coefficient
func adjust_teacher_satisfaction(liste) -> void:
	print("mood prof")
	for i in liste:
		var mood =  Utils.randfloat_in_square_range(GlobalData.adjust_satisfaction()*0.4, GlobalData.adjust_satisfaction()*1)
		Teacher.set_mood(i,mood)


# Ajuster l'état d'un département en appliquant un coefficient
func adjust_dept_state() -> void:
	print("à compléter")
