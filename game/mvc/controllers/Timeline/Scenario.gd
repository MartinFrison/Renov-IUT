# Scenario.gd
class_name Scenario
extends Node

var _name : String


func init() -> void:
	push_error("init() doit être implémentée.")


# Obtenir le nom du scénario actuel
func get_scenario() -> String:
	return _name



# Retourne la description du scénario
static func get_description() -> String:
	push_error("get_description() doit être implémentée.")
	return ""

# Appelle les messages sur l'explication du scénario et de ces objectifs en début de jeu
func game_start():
	push_error("game_start() doit être implémentée.")

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

# Renvoie au joueur selon le scénario un rapport sur sa gestion de l'IUT
# avec ce qui lui à permis ou non de complèter sont objectifs et les concéquences
# que ses décisions ont pu avoir
func player_report() -> String:
	push_error("player_report() doit être implémentée.")
	return ""



# Renvoie un string contenant le résultat des effets indésirables du mandat
# On consulte les stats de fin de partie pour savoir lesquelles sont décevantes
func side_effect() -> String:
	var side_effect = ""
	
	# L'état des bâtiments
	var state = 0
	# On calcule leur état moyen
	for i in range(1, 6):
		state += Building.get_building(Utils.dept_index_to_string(i)).get_inventory()
	state /= 5
	# On regarde s'ils sont mauvais
	if state < 25:
		side_effect += " L'état des bâtiments est devenu déplorable. "
	elif state < 50:
		side_effect += " L'état des bâtiments s'est dégradé. "
	
	# La satisfaction des étudiants / des profs
	var stud_mood = Student.avg_mood()
	var teach_mood = Teacher.avg_mood()
	if stud_mood < 0.25:
		side_effect += "Les étudiants sont furieux. "
	elif stud_mood < 0.50:
		side_effect += "Les étudiants sont mécontents. "
	if teach_mood < 0.25:
		side_effect += "Les enseignants sont furieux. "
	elif teach_mood < 0.50:
		side_effect += "Les enseignants sont mécontents. "
	
	# La chute du nombre de diplômés (seulement si le jeu dure plus d'un an)
	var year = GlobalData._year - 2026
	if GlobalData.get_season() >= 1:
		year += 1
	if year >= 1:
		# Ratio de diplômés par année écoulée
		var grad = Student.get_graduate()
		var ratio = grad / year
		
		if grad < 100:
			side_effect += "Le nombre de diplômes distribués s'est effondré : "
			side_effect += "seulement %s en %s ans. " % [grad, year]
		elif grad < 200:
			side_effect += "Le nombre de diplômes distribués a baissé : "
			side_effect += "seulement %s en %s ans. " % [grad, year]
	
	# Des caisses proches de la faillite
	var budget_init = GlobalData.adjust_budget_initial()
	var total = GlobalData.getTotalBudget()
	if total < budget_init * 0.5:
		side_effect += "Les caisses sont proches de la faillite. "
	elif total < budget_init:
		side_effect += "L'argent disponible dans les caisses a diminué. "

	return side_effect
