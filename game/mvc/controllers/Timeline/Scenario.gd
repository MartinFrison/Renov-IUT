# Scenario.gd
class_name Scenario
extends Node

var _name : String


func _init() -> void:
	init_building()
	init_data()
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
	# budget de base
func init_data() -> void:
	print("populate")
	Teaching.populate()
	Study.populate()
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

func init_attractivity() -> void:
	GlobalData.set_attractivity()
	

# Ajuster le budget des batiment en appliquant un coefficient
func adjust_budget_building(build : Building) -> void:
	print("adjust_budget_building() doit être implémentée.")


# Ajuster le budget en appliquant un coefficient
func adjust_budget() -> void:
	print("adjust_budget() doit être implémentée.")



# Ajuster l'état d'un département en appliquant un coefficient
func adjust_dept_state() -> void:
	print("adjust_dept_state() doit être implémentée.")
