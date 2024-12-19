# Scenario.gd
class_name Scenario
extends Node

var _name : String


func init() -> void:
	init_attractivity()
	

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

# Renvoie un string contenant le résultat des effets indésirable du manda
# On consulte les stats de fin de partie pour savoir lesquelles sont décevantes
func side_effect() -> String:
	var side_effect = ""
	# L'état des batiments
	#for i in range(1,6):
		
	
	# La satisfaction des étudiants / des profs
	
	# La chute du nombre de diplomé 
	
	# Des caisses proche de la faillite

	return side_effect()




func init_attractivity() -> void:
	GlobalData.set_attractivity()
