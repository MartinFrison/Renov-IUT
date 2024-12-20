extends Node2D

# Appelée lorsque le nœud entre dans la scène pour la première fois.
func _ready() -> void:
	# Enregistre ce nœud en tant qu'observateur des données globales et de la population.
	ObserverGlobalData.addObserver(self)
	ObserverPopulation.addObserver(self)
	
	# Initialise les éléments de l'interface utilisateur avec les valeurs actuelles.
	notifyBudgetChanged()
	notifyDateChanged()
	
	# Met à jour en continu certains éléments de l'interface toutes les secondes.
	while true:
		notifyLevelChanged()
		notifySatisfactionChanged()
		await get_tree().create_timer(1).timeout

# Met à jour les étiquettes d'affichage du budget dans l'interface.
func notifyBudgetChanged() -> void:
	# Met à jour la valeur du budget actuel.
	var label = get_node("budget")
	label.text = GlobalData.formatBudget(GlobalData.getBudget()) + " €"
	
	# Met à jour la valeur du budget total accumulé.
	label = get_node("budget/budget_total")
	label.text = "(total : " + GlobalData.formatBudget(GlobalData.getTotalBudget()) + " €)"

# Met à jour l'affichage du niveau moyen des étudiants dans l'interface.
func notifyLevelChanged() -> void: 
	var label = get_node("level")
	label.text = str(Student.avg_level()*20) + "/20"  # Convertit le niveau sur une échelle de 20.

# Met à jour l'affichage du pourcentage d'attractivité dans l'interface.
func notifyAttractivityChanged() -> void:
	var label = get_node("attractivity")
	label.text = str(GlobalData.get_attractivity() * 100) + " %"  # Convertit le ratio d'attractivité en pourcentage.

# Met à jour l'affichage de la satisfaction pour les étudiants et les enseignants dans l'interface.
func notifySatisfactionChanged() -> void:
	# Met à jour la satisfaction moyenne des étudiants.
	var label = get_node("mood_stud")
	label.text = str(Student.avg_mood()*100) + " %"  # Convertit le ratio de satisfaction en pourcentage.
	
	# Met à jour la satisfaction moyenne des enseignants.
	label = get_node("mood_teach")
	label.text = str(Teacher.avg_mood()*100) + " %"  # Convertit le ratio de satisfaction en pourcentage.

# Met à jour l'affichage de la date dans l'interface.
func notifyDateChanged() -> void: 
	var label = get_node("date")
	label.text = GlobalData.get_season_text() + " " + GlobalData.get_year_to_str()  # Combine le texte de la saison et de l'année.
