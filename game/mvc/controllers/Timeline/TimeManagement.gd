class_name TimeManagement
extends Node

var _tuto : Tutorial
var _scenario: Scenario
var _bill : Bill



# Le jeu commence le 1 septembre 2025
func _init(scenario: Scenario, tuto : Tutorial) -> void:
	_bill = Bill.new()
	GlobalData.setDate(1,9,2025) # date de départ
	_scenario = scenario  # Initialiser le scénario
	_tuto = tuto # Initialiser le tuto
	ObserverPopulation.notifySatisfactionChanged()
	ObserverPopulation.notifyLevelChanged()
	ObserverBuilding.notifyStateChanged()


func start():
	print("aa")
	await _tuto.tuto_start()
	print("bb")


# Execute toutes les actions d'un trimestre
func next_Trimestre():
	GlobalData.incrementTrimestre()

	# Appelle des évenements
	Event()
	
	#Avancement des travaux sur les batiments
	for i in 5:
		var c = Utils.dept_index_to_string(i+1)
		var build = Building.get_building(Utils.dept_index_to_string(i+1))
		BuildingManagement.advance_work(build, 90)
	#Détérioration trimestriels des batiments
	BuildingManagement.wear(90)
	ObserverBuilding.notifyStateChanged()
	
	#Traitement de la satisfaction
	mood_update(90)
	#Traitement du niveau etudiant
	level_update(90)
	ObserverPopulation.notifyLevelChanged()
	ObserverPopulation.notifySatisfactionChanged()
	
	#Test des étapes intermediare du scenario
	_scenario.mid_game()

	# Reglement des factures trimestrielle
	_bill.add_daily_expense(90)
	_bill.pay_bill()
	# On prévient le joueur s'il risque la faillite
	if _bill.get_previous_bill() >= GlobalData.getBudget():
		BulleGestion.send_notif("Risque de faillite.", "Attention : les caisses sont presque vides, vous risquez la faillite !", 0)
	
	# Les professeurs et étudiant insatisfait démissionnent
	Teaching.teacher_resign()
	Study.student_resign()
	

	# Appeler les actions de début et fin d'année
	if GlobalData.isEndofYear():
		end_of_year()
	if GlobalData.isStartofYear():
		year_begin()
	
	# A la fin du trimestre on test si le jeu se finit
	if _scenario.test_end_game_condition():
		_scenario.end_game()







# Fin de l'année
func end_of_year() -> void:
	print("Fin de l'année. ", GlobalData._year)
	Study.pass_next_year()


#rentrée qui signe le début de la nouvelle année
func year_begin() -> void:
	print("C'est la rentrée. ", GlobalData._year)
	# Arriver des premières années
	Study.populate_new_year(_scenario)



# Lance les events du trimestre
func Event() -> bool:
	if GlobalData._year <= 2026:
		pass
	elif GlobalData._year <= 2028:
		pass
	else:
		pass
	
	return false


# Ajuste la satisfaction selon divers critères
func mood_update(day : int) -> void:
	# chauffage
	heat_adjust_mood()
	inventory_adjust_mood()
	# porte bloquer
	Study.door_adjust_mood()
	#Selon le salaire des profs
	Teaching.pay_adjust_mood()

# Ajuste le niveau etudiant selon divers critères
func level_update(day) -> void:
	# Ajustement selon le nombre de prof et leur moods
	Study.teacher_adjust_level()
	pass
	



# Ajuster le mood selon si les etudiants on trop chaud ou trop froid
static func heat_adjust_mood() -> void:
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		var build = Building.get_building(code)

		#trop chaud
		if build.is_heating() and GlobalData._month >= 7 and GlobalData._month<=9:
			# s'il fait trop chaud la satisfaction tend vers 0 et la difficulté empire le coeff
			Study.mood_fluctuation(code, 0, 0.05 / GlobalData.adjust_satisfaction())	
		#trop froid
		elif !build.is_heating() and (GlobalData._month >= 1 or GlobalData._month<=4):
			# s'il fait trop froid la satisfaction tend vers 0 et la difficulté empire le coeff
			Study.mood_fluctuation(code, 0, 0.08 / GlobalData.adjust_satisfaction())
		
		# s'il ne fait ni trop chaud ni trop froid on ne fait rien



# Ajuster le mood selon l'état des lieux des batiments
# Fait converger la satisfaction vers une valeur qui dépend de l'état des lieux
static func inventory_adjust_mood() -> void:
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		var build = Building.get_building(code)
		
		# Formule qui dépend de l'état des lieux et la difficulté
		var value = build.get_inventory() * GlobalData.adjust_satisfaction()
		
		# On applique les fluctuations pour les profs et les étudiant
		Study.mood_fluctuation(code, value, 0.1)
		Teaching.mood_fluctuation(code, value, 0.1)
