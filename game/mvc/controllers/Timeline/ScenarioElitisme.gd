class_name ScenarioElitisme
extends Scenario

# Liste des building à rénover
var old_builds : Array[Building] = []

var _progression : int

func _init() -> void:
	_progression = 0
	_name = "Elitiste"
	super._init()
	
	var msg = "Votre objectif est de formé l'élite de ce
	 pays en permettant à un maximum d'étudiants de rentrer en école d'ingénieur après leur BUT"
	await BulleGestion.send_message(msg, true)
	


static func get_description() -> String:
	return "Votre objectif est de préparer autant d'étudiants que possible à devenir ingénieur"


# Test si le jeu est fini
# Ce scenario finit si les batiments à rénover sont terminer
func test_end_game_condition() -> bool:
	# On demande au moins un taux de 95% pour l'état des lieu et l'isolation de chaque batiment
	for b in old_builds:
		if b.get_inventory() < 95:
			return false
	return true


# Déclencher la fin du jeu
func end_game() -> void:
	print("fin du jeu")
	if old_builds.size()>1:
		await BulleGestion.send_message("Vous avez fini de rénover les bâtiments qui étaient en mauvais état.", false)
	else:
		await BulleGestion.send_message("Vous avez fini de rénover le bâtiment en mauvais état.", false)


	var scene = load("res://mvc/views/Node2D/FinJeu/PanelFinRenovation.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	await bulle.tree_exited


# Les actions du scénario qui ont lieu au cour de la partie
func mid_game() -> void:
	var b = false
	var msg


# Génère un événement aléatoire avec des probabilités dépendant du scénario et d'autre condition
func random_event() -> void:
	var events_proba = []
	events_proba.append(1)  # Proba de 1 pour l'event 0
	events_proba.append(1)  # Proba de 1 pour l'event 1
	super.random_event_call(events_proba) # appeler l'event dans la class parente


# Initialise le modèle en fonction du scénario et de la difficulté
func init_data() -> void:
	super.init_data()
	# On choisis le/les batiments à rénover
	var build1 = Utils.randint_in_range(1,5)
	old_builds.append(Building.get_building(Utils.dept_index_to_string(build1)))
	# Si la difficulté est élevé on rénove 2 batiment
	if GlobalData.get_difficulty() == 3:
		var build2 = Utils.randint_in_range(1,5)
		if build2 == build1:
			build2 += 1	
			if build2 >= 6:
				build2 = 1
		old_builds.append(Building.get_building(Utils.dept_index_to_string(build1)))
	
	# Dans ce scenario, en plus de l'initialisation classique
	# on redefini les variable des batiments à renover
	for b in old_builds:
		# on reset les valeur
		b.addInventory(-100)
		# l'isolation et l'état est aléatoire et dépend de la difficulté
		var inventory = int(Utils.randint_in_range(5,30) * GlobalData.adjust_dept_state())
		b.addInventory(inventory)



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
