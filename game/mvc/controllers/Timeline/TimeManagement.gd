class_name TimeManagement
extends Node

var _scenario: Scenario
var _pause : bool


# Le jeu commence le 1 septembre 2025
func _init(scenario: Scenario) -> void:
	GlobalData.setDate(1,9,2025) # date de départ
	self._scenario = scenario  # Initialiser le scénario
	year_begin()



func _ready() -> void:
	tick()


#Traitement du jeu jour par jour
func tick():
	while true:
		await wait(1)
		if _pause:
			break
		
		GlobalData.incrementDay()
		if GlobalData.isNewMonth():
			end_of_month()
		
		#possibilité d'évenement chaque jours
		DailyEvent()
		#traitement quotidient de la satisfaction
		#traitement quotidient du niveau etudiant
		
		# A la fin de la journée on test si le jeu se finit
		if _scenario.test_end_game_condition():
			_scenario.end_game()
			pause(true)



func wait(seconds : float) -> void:
	await get_tree().create_timer(seconds).timeout




#chaque fin de mois déclenche des actions comme les cout à rêgler
func end_of_month() -> void:
	print("Fin du mois")
	#facture chauffage 
	#salaire des profs
	#salaire des agents d'entretien
	
	if GlobalData.isEndofYear():
		end_of_year()
	if GlobalData.isStartofYear():
		year_begin()



# Fin de l'année
func end_of_year() -> void:
	print("Fin de l'année ", GlobalData._year)



#rentrée qui signe le début de la nouvelle année
func year_begin() -> void:
	print("C'est la rentrée ", GlobalData._year)



# Pause ou reprise de la gestion du temps
func pause(p: bool) -> void:
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
	
	var proba = GlobalData.adjust_event_proba() * coeff_proba
	
	if Utils.randfloat_in_range(0,1) > proba:
		_scenario.random_event()
		return true
	return false
