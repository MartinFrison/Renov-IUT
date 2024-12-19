class_name ScenarioElection
extends Scenario

var _progression : int

func init() -> void:
	_progression = 0
	_name = "Élection"
	super.init()



# Appelle les messages sur l'explication du scénario et de ces objectifs en début de jeu
func game_start():
	var msg = "Votre objectif est d'être réélu(e) dans 5 ans !"
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
	await BulleGestion.send_message("Les représentants du Conseil vont voter pour - ou contre vous !", false)
	
	# On afficher le panel de fin de jeu
	var scene = load("res://mvc/views/Node2D/FinJeu/PanelFinElection.tscn")
	var end = scene.instantiate()
	RenovIUTApp.app.add_child(end)
	if end.has_method("init"):
		end.init(self)
	await end.tree_exited


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
	# Est-ce qu'il a privilégié les profs ou les étudiants ?
	# On calcule le taux de voix reçues pour les profs et pour les étudiants
	var rateTeacher : float = float(Vote.popularity_among_teachers()) / Vote.nb_voix_teacher()
	var rateStudent : float = float(Vote.popularity_among_students()) / Vote.nb_voix_student()

	# On regarde lesquels ont été les plus favorisés
	var teacher_favoritisme : float = rateTeacher / rateStudent
	if teacher_favoritisme > 1.5:
		report += "Vous avez largement favorisé les enseignants avec votre gestion "
	elif teacher_favoritisme > 1:
		report += "Vous avez légèrement favorisé les enseignants avec votre gestion "
	elif teacher_favoritisme > 0.67:
		report += "Vous avez légèrement favorisé les étudiants avec votre gestion "
	else:
		report += "Vous avez largement favorisé les étudiants avec votre gestion "

	# Comment les a-t-il privilégiés ?
	if teacher_favoritisme > 1:
		report += "en augmentant leurs salaires et en veillant à ce qu'ils soient satisfaits. "
		report += "Votre gestion raisonnable du budget et votre capacité à accompagner de nombreux étudiants vers l'obtention de leur diplôme ont également aidé à les convaincre. "
		# Était-ce judicieux ?
		report += "Ce choix était pertinent étant donné la forte proportion d'enseignants au Conseil."
	else:
		report += "en veillant à leur réussite, mais surtout à leur satisfaction générale. "
		# Était-ce judicieux ?
		report += "Mais ce choix n'était peut-être pas le plus judicieux étant donné le faible nombre de représentants étudiants."

	# Quelles ont été les conséquences sur l'IUT ?
	var side_effect = side_effect()
	if Vote.election_gagnee() and side_effect!="":
		report += "\nBien que vous ayez remporté ces élections, votre politique a eu des effets indésirables."
		report += side_effect

	return report
