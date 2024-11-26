class_name TimeManagement
extends Node

var _scenario: Scenario
var _bill : Bill

# Le jeu commence le 1 septembre 2025
func _init(scenario: Scenario) -> void:
	_bill = Bill.new()
	GlobalData.setDate(1,9,2025) # date de départ
	self._scenario = scenario  # Initialiser le scénario



func _ready() -> void:
	await RenovIUTApp.app.get_tree().create_timer(2).timeout
	BulleGestion.send_notif("AAA","aaaaa",0)
	BulleGestion.send_notif("BBB","bbbbb",0)
	pass



# Execute toutes les actions d'un trimestre
func next_Trimestre():
	GlobalData.incrementTrimestre()

	# Appelle des évenements
	Event()
	
	#Avancement des travaux sur les batiments
	for i in 5:
		var c = Utils.dept_index_to_string(i+1)
		var build = Building.get_building(Utils.dept_index_to_string(i+1))
		BuildingManagement.advance_work(build)
	#Détérioration trimestriels des batiments
	BuildingManagement.wear()
	
	#Traitement de la satisfaction
	mood_update(90)
	#Traitement du niveau etudiant
	level_update(90)
	
	#Test des étapes intermediare du scenario
	_scenario.mid_game()

	# Reglement des factures trimestrielle
	_bill.add_daily_expense(90)
	_bill.pay_bill()
	# On prévient le joueur s'il risque la faillite
	if _bill.get_previous_bill() >= GlobalData.getBudget():
		BulleGestion.send_notif("Risque de faillite", "Attention les caisses sont presque vide, vous risquez la faillite !", 0)
	
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
	print("Fin de l'année ", GlobalData._year)
	Study.pass_next_year()


#rentrée qui signe le début de la nouvelle année
func year_begin() -> void:
	print("C'est la rentrée ", GlobalData._year)
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


func mood_update(day : int) -> void:
	# chauffage
	heat_adjust_mood(day)
	inventory_adjust_mood(day)
	# porte bloquer
	Study.door_adjust_mood(day)

func level_update(day) -> void:
	# Ajustement selon le nombre de prof et leur moods
	Study.teacher_adjust_level(day)




# Ajuster le mood selon si les etudiants on trop chaud ou trop froid
static func heat_adjust_mood(day : int) -> void:
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		var build = Building.get_building(code)
		var value = (0.08 / 360)
		#trop chaud
		if build.is_heating() and GlobalData._month >= 6 and GlobalData._month<=7:
			Study.drop_mood_student(code, value*day)
		#trop froid
		elif !build.is_heating() and (GlobalData._month >= 11 or GlobalData._month<=2):
			Study.drop_mood_student(code, value*day)
		else:
			value = (0.03 / 360)
			Study.boost_mood_student(code, value*day)



# Ajuster le mood selon l'état des lieux des batiments
static func inventory_adjust_mood(day : int) -> void:
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		var build = Building.get_building(code)
		# Formule
		var value = ((build.get_inventory()-50)/50)*0.08/360
		
		if value > 0:
			Study.drop_mood_student(code, value*day)
			Teaching.boost_mood_teacher(code, value*day)
		else:
			Study.boost_mood_student(code, value*day)
			Teaching.boost_mood_teacher(code, value*day)
