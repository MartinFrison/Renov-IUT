class_name TimeManagement
extends Node

var _scenario: Scenario
static var _pause : bool
var _bill : Bill

# Le jeu commence le 1 septembre 2025
func _init(scenario: Scenario) -> void:
	_bill = Bill.new()
	GlobalData.setDate(1,9,2025) # date de départ
	self._scenario = scenario  # Initialiser le scénario



func _ready() -> void:
	tick()


#Traitement du jeu jour par jour
func tick():
	await wait(1)
	
	#Expense.expense_global(2500000)
	
	while true:
		await wait(0.6)
		# Si le jeu est en pause la boucle quotidienne n'est pas lu
		if !_pause:
			GlobalData.incrementDay()
			if GlobalData.isNewMonth():
				end_of_month()
			
			#Possibilité d'évenement chaque jours
			DailyEvent()
			
			#Mise à jour des facture quotidienne
			_bill.add_daily_expense()
			
			#Avancement des travaux sur les batiments
			for i in 5:
				var c = Utils.dept_index_to_string(i+1)
				var build = Building.get_building(Utils.dept_index_to_string(i+1))
				BuildingManagement.advance_work(build)
			#Détérioration quotidienne des batiments
			BuildingManagement.wear()
			
			# On calcule que tout les 5 jours pour optimiser
			if GlobalData._day % 5 == 0:
				#Traitement quotidient de la satisfaction
				daily_mood_update(5)
				#Traitement quotidient du niveau etudiant
				daily_level_update(5)
			
			#Test des étapes intermediare du scenario
			_scenario.mid_game()
			# A la fin de la journée on test si le jeu se finit
			if _scenario.test_end_game_condition():
				_scenario.end_game()
				pause(true)
				break



func wait(seconds : float) -> void:
	var timer = RenovIUTApp.app.get_tree().create_timer(seconds)
	await timer.timeout




#chaque fin de mois déclenche des actions comme les cout à rêgler
func end_of_month() -> void:
	# Reglement des factures trimestrielle
	if GlobalData._month%3==0:
		_bill.pay_bill()
	elif GlobalData._month%3==1:
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



# Fin de l'année
func end_of_year() -> void:
	print("Fin de l'année ", GlobalData._year)
	Study.pass_next_year()


#rentrée qui signe le début de la nouvelle année
func year_begin() -> void:
	print("C'est la rentrée ", GlobalData._year)
	# Arriver des premières années
	Study.populate_new_year(_scenario)


# Pause ou reprise de la gestion du temps
static func pause(p: bool) -> void:
	_pause = p

#calcule la proba quotidienne d'avoir un evenement et le lance si besoin
func DailyEvent() -> bool:
	var coeff_proba
	if GlobalData._year <= 2026:
		coeff_proba = 0.5
	elif GlobalData._year <= 2028:
		coeff_proba = 1
	else:
		coeff_proba = 0.7
	
	#La proba final est compris entre environ 0.5% et 1.5% selon la difficulté et le moment
	var proba = GlobalData.adjust_event_proba() * coeff_proba * 0.015
	
	if Utils.randfloat_in_range(0,1) < proba:
		_scenario.random_event()
		return true
	return false


func daily_mood_update(day : int) -> void:
	# chauffage
	heat_adjust_mood(day)
	# propreté (dépend des agents d'entretien si les portes sont bloqué)
	cleanliness_adjust_mood(day)
	inventory_adjust_mood(day)
	# porte bloquer
	Study.door_adjust_mood(day)

func daily_level_update(day) -> void:
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



# Ajuster le mood selon si les lieux sont propre ou non
# La propreté dépend du nombre d'agent d'entretien et des si les portes sont bloqué
static func cleanliness_adjust_mood(day : int) -> void:
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		var build = Building.get_building(code)
		#Formule 
			#On suppose qu'il faut deux fois moins d'agent d'entretient
			# si les portes des salles sont verrouiller car moins de salubrité
		var agent_effect = build.get_agents_nb()*2 if build.isDoorLocked() else build.get_agents_nb()
		var ratio = min((Student.compute_nb_per_dept(code) / agent_effect), Student.compute_nb_per_dept(code)*3)
		var value = (-(ratio-200)) / (200*5*360)
		
		if value > 0:
			Study.drop_mood_student(code, value*day)
			Teaching.boost_mood_teacher(code, value*day)
		else:
			Study.boost_mood_student(code, value*day)
			Teaching.boost_mood_teacher(code, value*day)

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
