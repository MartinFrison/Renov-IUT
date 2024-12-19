class_name ScenarioElection
extends Scenario

var _progression : int

func init() -> void:
	_progression = 0
	_name = "Élection"
	super.init()



# Appelle les messages sur l'explication du scénario et de ces objectifs en début de jeu
func game_start():
	var msg = "Votre objectif est d'être réélu dans 5 ans !"
	await BulleGestion.send_message(msg, true)


static func get_description() -> String:
	return "Votre objectif est d'être réélu(e) au terme d'un mandat de 5 ans."


# Test si le jeu est fini
# Dans ce scénario il finit simplement au bout de 5 ans
func test_end_game_condition() -> bool:
	return (GlobalData._year == 2030 and GlobalData._month == 6 and  GlobalData._day == 1)


# Déclencher la fin du jeu
func end_game() -> void:
	print("fin du jeu")
	await BulleGestion.send_message("C'est la fin de votre mandat !", false)
	await BulleGestion.send_message("Les représentants du conseil vont voter pour - ou contre vous !", false)
	
	var scene = load("res://mvc/views/Node2D/FinJeu/PanelFinElection.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	await bulle.tree_exited


# Les actions du scénario qui ont lieu au cour de la partie
func mid_game() -> void:
	if _progression < 2:
		var year = 2028 if _progression == 0 else 2029
		if (GlobalData._year == year and GlobalData._month == 6 and  GlobalData._day == 1):
			var msg = "Il vous reste %s du mandat à servir, les sondages vous donnent actuellement " % ["deux années" if _progression == 0 else "une année"]
			var sondage_etu = int(Vote.popularity_among_students()*100/Vote.nb_voix_student())
			var sondage_prof = int(Vote.popularity_among_teachers()*100/Vote.nb_voix_teacher())
			msg = "%s%s%% dans les intentions de vote des étudiants et %s%% de celles des enseignants." % [msg, sondage_etu, sondage_prof]
			await BulleGestion.send_message(msg, true)
			_progression +=1


# Renvoie au joueur un rapport sur sa gestion de l'IUT
# avec ce qui lui à permis ou non d'être réélu et les concéquences
# que ses décisions ont pu avoir
func player_report() -> String:
	var report = ""
	# Est ce qu'il à privilégier les profs ou les étudiant ?
	
	
	# Comment les à t'il privilégier
	
	
	# Etait ce judicieux ?
	
	
	# Quelle ont été les concéquences sur l'iut
	
	return report
