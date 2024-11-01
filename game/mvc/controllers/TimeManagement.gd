class_name TimeManagement
extends Node


# Attributs
var year: int
var month: int
var day: int
var scenario: Scenario
var timer: Timer



# Le jeu commence le 1 septembre 2025
func _init(scenario: Scenario) -> void:
	self.year = 2025  # Année initiale
	self.month = 9  # Mois initial
	self.day = 1  # Jour initial
	self.scenario = scenario  # Initialiser le scénario
	year_begin()



func _ready() -> void:
	tick()



func tick():
	while true:
		await wait(1)
		incrementDay()
		print("day: %s/%s/%s" % [year, month, day])



func wait(seconds : float) -> void:
	await get_tree().create_timer(seconds).timeout



func incrementDay() -> void:
	day += 1
	if day > 30:  # Mois de 30 jours par exemple
		day = 1
		month += 1
		end_of_month()
	if month > 12:
		month = 1
		year += 1


# Génère un événement aléatoire
func random_event() -> void:
	# Logique d'événement aléatoire
	var event_id = randi() % 10  # Exemple d'événement aléatoire
	print("Événement aléatoire généré avec ID :", event_id)
	scenario.trigger_event(event_id)  # Appel à une méthode d'événement dans `Scenario`



# Récupère l'id de la saison actuelle en fonction du mois
func get_season() -> int:
	match month:
		1, 2, 12:
			return 3
		3, 4, 5:
			return 0
		6, 7, 8:
			return 1
		9, 10, 11:
			return 2
	return -1



#chaque fin de mois déclenche des actions comme les cout à rêgler
func end_of_month() -> void:
	print("Fin du mois")
	#facture chauffage 
	#salaire des profs
	#salaire des agents d'entretien
	
	if month==7:
		end_of_year()
	if month==9:
		year_begin()



# Fin de l'année
func end_of_year() -> void:
	print("Fin de l'année ", year)
	
	if year==2030: # fin du mandat
		launch_vote()



#rentrée qui signe le début de la nouvelle année
func year_begin() -> void:
	print("C'est la rentrée ", year)
	



# Lancer un vote
func launch_vote() -> void:
	print("Vote lancé pour la fin du manda", year)



# Pause ou reprise de la gestion du temps
func pause(p: bool) -> void:
	if p:
		print("Pause du timer")
	else:
		print("Reprise du timer")
