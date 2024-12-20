class_name TimeManagement
extends Node

var _tuto : Tutorial
var _scenario: Scenario
var _budget : Budget



# Le jeu commence le 1 septembre 2025
func _init(scenario: Scenario, tuto : Tutorial) -> void:
	print("Initialisation du jeu")
	
	_budget = Budget.new() # Instancier la classe pour gérer les factures
	GlobalData.setDate(1,9,2025) # date de départ
	_scenario = scenario  # Initialiser le scénario
	_tuto = tuto # Initialiser le tuto
	
	# Initialisation des valeurs par défaut du jeu et des base de données
	BuildingManagement.init_building()
	Study.populate()
	Teaching.populate()
	Budget.init_budget()
	_scenario.init()
	BuildingManagement.compute_attractivity()
	
	# Notifier la vue pour afficher les données
	ObserverPopulation.notifySatisfactionChanged()
	ObserverPopulation.notifyLevelChanged()
	ObserverBuilding.notifyStateChanged()
	




# S'execute au commencement du jeu
func start():
	# Lance le tuto et le scénario
	await _tuto.tuto_next()
	await _scenario.game_start()


# Execute toutes les actions d'un trimestre
func next_Trimestre():
	# Si on est en attente de la fin du jeu
	# il est impossible de passer au trimestre suivant
	if _scenario.test_end_game_condition():
		return
	
	GlobalData.incrementTrimestre()
	# moduler l'attractivité à la fin de l'année
	if GlobalData.isEndofYear():
		BuildingManagement.compute_attractivity()
		BuildingManagement.adjust_attractivity()
	
	# Appelle des évenements
	Event()
	
	#Avancement des travaux sur les batiments
	for i in 5:
		var c = Utils.dept_index_to_string(i+1)
		var build = Building.get_building(Utils.dept_index_to_string(i+1))
		BuildingManagement.advance_work(build)
	#Détérioration trimestriels des batiments
	BuildingManagement.wear()
	ObserverBuilding.notifyStateChanged()
	
	#Traitement de la satisfaction et du niveau
	mood_and_level_update()

	ObserverPopulation.notifyLevelChanged()
	ObserverPopulation.notifySatisfactionChanged()
	
	# Appelle de la suite du tutoriel si besoin
	await _tuto.tuto_next()
	
	#Test des étapes intermediare du scenario
	_scenario.mid_game()

	# Reglement des factures trimestrielle
	_budget.add_daily_expense()
	_budget.pay_bill()
	# On prévient le joueur s'il risque la faillite
	if _budget.get_previous_bill() >= GlobalData.getBudget():
		BulleGestion.send_notif("Risque de faillite", "Attention : les caisses sont presque vides, vous risquez la faillite !", 0)
	
	# Les professeurs et étudiant insatisfait démissionnent
	Teaching.teacher_resign()
	Study.student_resign()
	

	# Appeler les actions de fin d'année
	if GlobalData.isEndofYear():
		print("C'est la fin de l'année. ", GlobalData._year)
		Study.pass_next_year()
		
	# Appeler les actions de début d'année
	if GlobalData.isStartofYear():
		print("C'est la rentrée. ", GlobalData._year)
		# Arriver des premières années
		Study.populate_new_year(_scenario)
		# Une fois que l'iut est repeuplé on envoie des financement au joueur
		_budget.send_fund()
	
	
	# A la fin du trimestre on test si le jeu se finit
	if _scenario.test_end_game_condition():
		_scenario.end_game()






# Lance les events du trimestre
func Event() -> bool:
	if GlobalData._year <= 2026:
		pass
	elif GlobalData._year <= 2028:
		pass
	else:
		pass
	
	return false



# Ajuste la satisfaction et le niveau selon divers critères
func mood_and_level_update() -> void:
	# selon le chauffage en hivert
	heat_adjust_mood()
	# si les portes sont bloqué
	Study.door_adjust_mood()
	# Selon l'état des batiments
	inventory_adjust_mood()
	#Selon le salaire des profs
	Teaching.pay_adjust_mood()
	# Si les batiments sont en travaux
	renovation_adjust_mood()
	# Satisfaction etudiante selon celle des profs
	Study.teacher_adjust_mood()
	
	# Le niveau selon le nombre de prof et leur moods
	Study.teacher_adjust_level()



# Ajuster le mood selon si les etudiants ont trop froid
static func heat_adjust_mood() -> void:
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		var build = Building.get_building(code)
	
		# si trop froid
		if !build.is_heating() and (GlobalData._month >= 1 or GlobalData._month<=4):
			# s'il fait trop froid la satisfaction tend vers 0 et la difficulté empire le coeff
			Study.mood_fluctuation(code, 0, 0.08 / GlobalData.adjust_satisfaction())	
			Teaching.mood_fluctuation(code, 0, 0.03)
		# sinon on ne fait rien



# Ajuster le mood selon l'état des lieux des batiments
# Fait converger la satisfaction vers une valeur qui dépend de l'état des lieux (en dehors de l'été)
static func inventory_adjust_mood() -> void:
	# Si on était pas en été
	if GlobalData.get_season()!=2:
		for i in range(1,6):
			var code = Utils.dept_index_to_string(i)
			var build = Building.get_building(code)
			
			# Formule qui dépend de l'état des lieux et la difficulté
			var value = build.get_inventory() * GlobalData.adjust_satisfaction() / 100
			
			# On applique les fluctuations pour les profs et les étudiant (surtout les étudiants)
			Study.mood_fluctuation(code, value, 0.35)
			Teaching.mood_fluctuation(code, value, 0.2)


# Ajuster le mood si des travaux on lieu dans le batiment
# Fait converger la satisfaction vers 0 si les travaux on lieu (en dehors de l'été)
static func renovation_adjust_mood() -> void:
	# Si on était pas en été
	if GlobalData.get_season()!=2:
		for i in range(1,6):
			var code = Utils.dept_index_to_string(i)
			var build = Building.get_building(code)
			
			# Si des travaux sont en cours dans le batiment
			if build.is_renovation_underway():
				# Les étudiant et professeurs sont mécontent (surtout les élèves)
				Study.mood_fluctuation(code, 0, 0.18)
				Teaching.mood_fluctuation(code, 0, 0.12)
