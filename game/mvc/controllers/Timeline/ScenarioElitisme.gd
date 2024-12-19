class_name ScenarioElitisme
extends Scenario


var _progression : int


func init() -> void:
	_progression = 0
	_name = "Elitiste"
	super.init()



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

	# On affiche le panel de fin de jeu
	var scene = load("res://mvc/views/Node2D/FinJeu/PanelFinElitisme.tscn")
	var end = scene.instantiate()
	RenovIUTApp.app.add_child(end)
	if end.has_method("init"):
		end.init(self)
	await end.tree_exited


# Les actions du scénario qui ont lieu au cour de la partie
func mid_game() -> void:
	# A la fin de l'année on informe le joueur du succès cumulé de ses étudiants depuis son éléction
	if GlobalData.isEndofYear():
		var msg
		var nb_eng = Student.get_engineering()
		if nb_eng != 0:
			msg = "À l'heure qu'il est, le nombre d'étudiants ayant rejoint une école d'ingénieurs sous votre 
		mandat s'élève à %s." % [nb_eng]
		else:
			msg += "À l'heure qu'il est, aucun étudiant n'a rejoint une école d'ingénieurs. "
			msg += "Il paraît qu'ils n'en avaient pas le niveau..."
		await BulleGestion.send_message(msg, true)


# Renvoie au joueur un rapport sur sa gestion de l'IUT
# avec ce qui lui a permis ou non d'avoir une forte réussite ainsi que les conséquences
# que ses décisions ont pu avoir
func player_report() -> String:
	var report = ""
	var enginer = Student.get_engineering()
	var grade = Student.get_graduate()
	
	# Évaluation du bilan sur l'élitisme
	report += "Votre bilan en tant que directeur d'un établissement qui se veut élitiste est "
	var bilan
	if enginer > 100:
		bilan = "excellent"
	elif enginer > 80:
		bilan = "globalement très bon"
	elif enginer > 60:
		bilan = "globalement bon"
	elif enginer > 40:
		bilan = "correct"
	elif enginer > 20:
		bilan = "plutôt mauvais"
	else:
		bilan = "nul"
	report += bilan + ". "
	
	# Précisions sur le nombre d'intégrations en école d'ingénieur
	report += "Sous votre mandat, %s " % [enginer]
	if enginer <= 40:
		report += "seuls "
	report += "étudiants ont pu intégrer une école d'ingénieurs à l'issue de leur formation. "
	
	# Note sur la réussite générale (nombre de diplômés)
	report += "D'autre part, %s étudiants ont pu obtenir leur diplôme, soit %s par an. " % [grade, round(grade / 5)]
	
	# Quelles ont été les conséquences sur l'IUT ?
	var side_effect = side_effect()
	if enginer > 60 and side_effect != "":
		report += "\nCependant, bien que votre bilan concernant la réussite soit " + bilan + ", "
		report += "votre gestion a également eu des effets néfastes :\n"
		report += side_effect

	return report
