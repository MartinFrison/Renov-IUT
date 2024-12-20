extends Node2D

# Fonction d'initialisation avec en parametre la référence au scénario qui était joué
func init(scenario : Scenario):
	show_result(scenario)

# Affiche le tableau de vote de l'éléction et un rapport au joueur sur sa prestation
func show_result(scenario : Scenario) -> void:
	var node
	var dept
	
	# Définition du message principale selon si on a gagner/perdu
	node = "Resultat"
	node = get_node(node)
	if Vote.election_gagnee():
		var audio_player = get_node("win")
		audio_player.play()
		node.text = "Vous avez remporté les éléctions ! Félicitations !"
	else:
		node.text = "Vous avez perdu les éléctions. Dommage.."
	

	# Définir le texte du rapport au joueur
	var rate : float = float(int(float(Vote.popularity_total()*1000) / Vote.nb_voix_total()))/10
	node = get_node("report")
	node.text = "Vous avez récolté %s%% des votes.\n" % [rate]
	node.text += scenario.player_report()	
	
	# Remplir la grille des résultats des votes:
	node = "Vote/GridVoix/total_teach"
	node = get_node(node)
	node.text = "%s / %s" % [Vote.popularity_among_teachers(), Vote.nb_voix_teacher()]
	
	node = "Vote/GridVoix/total_stud"
	node = get_node(node)
	node.text = "%s / %s" % [Vote.popularity_among_students(), Vote.nb_voix_student()]
	
	node = "Vote//GridVoix/total"
	node = get_node(node)
	node.text = "%s / %s" % [Vote.popularity_total(), Vote.nb_voix_total()]
	
	# Pour chaque département on remplis la ligne de vote correspondante
	for i in 5:
		dept = Utils.dept_index_to_string(i+1)
		node = "Vote/GridVoix/dept%s" % [i+1]
		node = get_node(node)
		node.text = "%s" % [dept]
		
		node = "Vote/GridVoix/teach_dept%s" % [i+1]
		node = get_node(node)
		node.text = "%s / %s" % [Vote.popularity_among_teachers_per_dept(dept), Vote.nb_voix_teacher_per_dept(dept)]
		
		node = "Vote/GridVoix/stud_dept%s" % [i+1]
		node = get_node(node)
		node.text = "%s / %s" % [Vote.popularity_among_students_per_dept(dept), Vote.nb_voix_student_per_dept(dept)]
		
		node = "Vote/GridVoix/total_dept%s" % [i+1]
		node = get_node(node)
		node.text = "%s / %s" % [Vote.popularity_per_dept(dept), Vote.nb_voix_per_dept(dept)]


# Le joueur peut cliquer sur un bouton pour quitter le jeu
func _on_quitter_pressed() -> void:
	get_tree().quit() 
