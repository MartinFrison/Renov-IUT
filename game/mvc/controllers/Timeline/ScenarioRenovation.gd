class_name ScenarioRenovation
extends Scenario

# Liste des building à rénover
var old_builds : Array[Building] = []

var _progression : Array[bool]

func _init() -> void:
	for i in 8:
		_progression.append(false)
	_name = "Rénovation"
	super._init()
	
	var msg
	if old_builds.size() > 1:
		msg = "Votre objectif est de rénover les bâtiments %s et %s." % [old_builds[0].get_code(),old_builds[1].get_code()]
	else:
		msg = "Votre objectif est de rénover le bâtiment %s." % [old_builds[0].get_code()]
	await BulleGestion.send_message(msg, true)
	


static func get_description() -> String:
	return "Votre objectif est de rénover un ou plusieurs bâtiments."


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
	for i in old_builds.size():
		if old_builds[i].get_inventory() >= 100:
			if !_progression[3+i*4]:
				_progression[3+i*4] = true
				msg = "La rénovation du bâtiment %s est terminée !" % [old_builds[i].get_code()]
				b = true
				break
		if old_builds[i].get_inventory() >= 50:
			if !_progression[2+i*4]:
				_progression[2+i*4] = true
				msg = "La rénovation du bâtiment %s avance bien ! Continuez ainsi." % [old_builds[i].get_code()]
				b = true
				break
	if b:
		await BulleGestion.send_message(msg, true)

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



# Ajuster l'état d'un département en appliquant un coefficient
func adjust_dept_state() -> void:
	print("à compléter")
