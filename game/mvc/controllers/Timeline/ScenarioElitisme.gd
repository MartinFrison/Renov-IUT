class_name ScenarioElitisme
extends Scenario


var _progression : int


func _init() -> void:
	_progression = 0
	_name = "Elitiste"
	super._init()



# Appelle les messages sur l'explication du scénario et de ces objectifs en début de jeu
func game_start():
	var msg = "Votre objectif est de former l'élite de ce
	 pays en permettant à un maximum d'étudiants de rentrer en école d'ingénieur après leur BUT."
	await BulleGestion.send_message(msg, true)



static func get_description() -> String:
	return "Vous avez cinq ans pour préparer autant d'étudiants que possible à devenir ingénieurs."


# Test si le jeu est fini
# Dans ce scénario il finit simplement au bout de 5 ans
func test_end_game_condition() -> bool:
	return (GlobalData._year == 2030 and GlobalData._month == 6 and  GlobalData._day == 1)



# Déclencher la fin du jeu
func end_game() -> void:
	print("fin du jeu")
	await BulleGestion.send_message("Votre mandat de 5 ans est arrivé à son terme, 
	il est temps de faire le bilan.", false)

	var scene = load("res://mvc/views/Node2D/FinJeu/PanelFinElitisme.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	await bulle.tree_exited


# Les actions du scénario qui ont lieu au cour de la partie
func mid_game() -> void:
	# A la fin de l'année on informe le joueur du succès cumulé de ses étudiants depuis son éléction
	if GlobalData.isEndofYear():
		var msg
		msg = "À l'heure qu'il est, le nombre d'étudiants ayant rejoint une école d'ingénieurs sous votre 
		mandat s'élève à %s." % [Student.get_engineering()]
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


# Ajuster l'état d'un département en appliquant un coefficient
func adjust_dept_state() -> void:
	print("à compléter")
