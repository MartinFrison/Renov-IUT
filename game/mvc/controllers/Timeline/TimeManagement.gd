class_name TimeManagement
extends Node

var _scenario: Scenario
var timer: Timer


# Le jeu commence le 1 septembre 2025
func _init(scenario: Scenario) -> void:
	Global_data.setDate(1,9,2025) # date de départ
	self._scenario = scenario  # Initialiser le scénario
	year_begin()



func _ready() -> void:
	tick()



func tick():
	while true:
		await wait(1)
		Global_data.incrementDay()
		print("day: %s/%s/%s" % [Global_data._year, Global_data._month, Global_data._day])
		if Global_data.isNewMonth():
			end_of_month()



func wait(seconds : float) -> void:
	await get_tree().create_timer(seconds).timeout




#chaque fin de mois déclenche des actions comme les cout à rêgler
func end_of_month() -> void:
	print("Fin du mois")
	#facture chauffage 
	#salaire des profs
	#salaire des agents d'entretien
	
	if Global_data.isEndofYear():
		end_of_year()
	if Global_data.isStartofYear():
		year_begin()



# Fin de l'année
func end_of_year() -> void:
	print("Fin de l'année ", Global_data._year)



#rentrée qui signe le début de la nouvelle année
func year_begin() -> void:
	print("C'est la rentrée ", Global_data._year)



# Pause ou reprise de la gestion du temps
func pause(p: bool) -> void:
	if p:
		print("Pause du timer")
	else:
		print("Reprise du timer")
