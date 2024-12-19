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


func init_attractivity() -> void:
	GlobalData.set_attractivity()
