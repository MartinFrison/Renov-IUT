class_name ScenarioRenovation
extends Scenario

# Liste des building à rénover
var old_builds : Array[Building] = []

var _progression : Array[bool]

func init() -> void:
	for i in 8:
		_progression.append(false)
	_name = "Rénovation"
	super.init()
	

# Appelle les messages sur l'explication du scénario et de ces objectifs en début de jeu
func game_start():
	building_to_renov_wear()
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

	# On afficher le panel de fin de jeu
	var scene = load("res://mvc/views/Node2D/FinJeu/PanelFinRenovation.tscn")
	var end = scene.instantiate()
	RenovIUTApp.app.add_child(end)
	if end.has_method("init"):
		end.init(self)
	await end.tree_exited



# Les actions du scénario qui ont lieu au cour de la partie
func mid_game() -> void:
	var b = false
	var msg
	for i in old_builds.size():
		if old_builds[i].get_inventory() >= 100:
			if !_progression[3+i*4]:
				_progression[3+i*4] = true
				msg = "La rénovation du bâtiment %s est terminée, bien joué." % [old_builds[i].get_code()]
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



# Définie un état mauvais pour les batiments à rénover
func building_to_renov_wear() -> void:
	# On choisis le/les batiments à rénover
	var build1 = Utils.randint_in_range(1,5)
	old_builds.append(Building.get_building(Utils.dept_index_to_string(build1)))
	# Si la difficulté n'est pas en facile on rénove 2 batiment
	if GlobalData.get_difficulty() >= 2:
		var build2 = Utils.randint_in_range(1,5)
		if build2 == build1:
			build2 += 1	
			if build2 >= 6:
				build2 = 1
		old_builds.append(Building.get_building(Utils.dept_index_to_string(build2)))
	
	# Dans ce scenario, en plus de l'initialisation classique
	# on redefini les variable des batiments à renover
	for b in old_builds:
		# on reset les valeur
		b.addInventory(-100)
		# l'isolation et l'état est aléatoire et dépend de la difficulté
		var inventory = int(Utils.randint_in_range(5,30) * GlobalData.adjust_dept_state())
		b.addInventory(inventory)



# Renvoie au joueur un rapport sur sa gestion de l'IUT
# avec temps qu'il lui a fallu pour finir les rénovations et les conséquences
# de celle ci
func player_report() -> String:
	var report = ""

	# Durée de la rénovation
	var years = (GlobalData._year-2025)
	var months = GlobalData._month
	if years == 0 and months >= 9:        # on est toujours en 2025, après septembre
		report += "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris %s mois." % [months - 8]  # compte les mois après septembre
	elif years == 1 and months == 0:       # en septembre 2026
		report += "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris une année."
	elif years == 1:                        # Pour l'année 2026
		report += "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris %s mois." % [months + 3]  # Ajustement pour les mois restants de 2026
	elif months == 0:                       # Cas particulier pour septembre d'une année suivante
		report += "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris %s années." % years
	else:                                   # Cas général pour plusieurs années et mois
		report += "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris %s années et %s mois." % [years, months+3]

	# Quelles ont été les conséquences sur l'IUT ?
	var side_effect = side_effect()
	if side_effect != "":
		report += "\nCependant, votre gestion des travaux à eu des concéquences:\n"
		report += side_effect

	return report
