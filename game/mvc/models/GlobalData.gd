class_name GlobalData
extends Node

# Attributs
static var _year: int
static var _month: int
static var _day: int
static var _budget: int
static var _difficulty: int = 1 # Ajuste la difficulté si c'est le mode tutoriel
static var _attractivity: float # Attractivité de l'établissement, en pourcentage
static var _pay_worker: int = 3500 # Salaire 3500 € pour le personelles


# Fonction pour définir le budget
static func setBudget(montant : int) -> void:
	_budget = montant
	ObserverGlobalData.notifyBudgetChanged()

# Fonction pour ajouter au budget
static func addBudget(montant : int) -> void:
	_budget += montant
	ObserverGlobalData.notifyBudgetChanged()


# Fonction pour obtenir le budget
static func getBudget() -> int:
	return _budget

static func getTotalBudget() -> int:
	var result = getBudget()
	var builds = Building._buildingsDictionary
	for b in builds:
		result += builds[b].get_budget()
	return result;

static func get_pay_worker() -> int:
	return _pay_worker

#definir la date
static func setDate(day : int, month : int, year : int) -> void:
	_day = day
	_month = month
	_year = year
	ObserverGlobalData.notifyDateChanged()
	
static func get_attractivity() -> float:
	return _attractivity

static func set_attractivity(value : float):
	_attractivity = value
	ObserverGlobalData.notifyAttractivityChanged()



#Passe au jour suivant
static func incrementDay() -> void:
	_day += 1
	if _day > 30:  # Mois de 30 jours par exemple
		_day = 1
		_month += 1
	if _month > 12:
		_month = 1
		_year += 1
	ObserverGlobalData.notifyDateChanged()

#Avance de un trimestre
static func incrementTrimestre() -> void:
	_month += 3
	if _month > 12:
		_month = _month-12
		_year += 1
	ObserverGlobalData.notifyDateChanged()

#Renvoie vrai si c'est le premier du mois
static func isNewMonth() -> bool:
	return _day==1

#Renvoie vrai si c'est la fin d'année
static func isEndofYear() -> bool:
	return _month==6

#Renvoie vrai si c'est la fin d'année
static func isStartofYear() -> bool:
	return _month==9	


# Récupère l'id de la saison actuelle en fonction du mois
static func get_season() -> int:
	match _month:
		1, 2, 12:
			return 3
		3, 4, 5:
			return 0
		6, 7, 8:
			return 1
		9, 10, 11:
			return 2
	return -1
	
# Récupère l'année
static func get_year_to_str() -> String:
	return str(_year)

# Affich la saison en toute lettres
static func get_season_text() -> String:
	match _month:
		1, 2, 12:
			return "en hiver"
		3, 4, 5:
			return "au printemps"
		6, 7, 8:
			return "en été"
		9, 10, 11:
			return "en automne"
	return ""

# Fonction pour obtenir la date formatée (DD/MM/YYYY)
static func get_date() -> String:
	var day_str = "0" + str(_day) if _day < 10 else str(_day)
	var month_str = "0" + str(_month) if _month < 10 else str(_month)
	return "%s/%s/%d" % [day_str, month_str, _year]

static func get_difficulty() -> int:
	return _difficulty
	
static func set_difficulty(value : int) -> void:
	if value<=3 and value>=1:
		_difficulty = value


# Ajuste le budget initial en fonction de la difficulté
static func adjust_budget_initial() -> int:
	match get_difficulty():
		1:
			return 7000000
			#return 0
		2:
			return 4400000
			#return 0
		3:
			return 2000000
			#return 0
	return -1


# Ajuste les fonds en fonction de la difficulté
static func adjust_fund() -> float:
	match get_difficulty():
		1:
			return 1
		2:
			return 0.95
		3:
			return 0.9
	return -1

# Ajuste la satisfaction en fonction de la difficulté
static func adjust_satisfaction() -> float:
	match get_difficulty():
		1:
			return 1
		2:
			return 0.9
		3:
			return 0.8
	return -1

# Ajuste le niveau en fonction de la difficulté
static func adjust_level() -> float:
	match get_difficulty():
		1:
			return 1
		2:
			return 0.9
		3:
			return 0.8
	return -1

# Ajuste l'état du département en fonction d'un coefficient et de la difficulté
static func adjust_dept_state() -> float:
	match get_difficulty():
		1:
			return 1.3
		2:
			return 1 
		3:
			return 1
	return -1

# Ajuste la frequence d'evenement
static func adjust_event_proba() -> float:
	match get_difficulty():
		1:
			return 0.6
		2:
			return 0.8
		3:
			return 1
	return -1



# Permet d'afficher le budget dans un joli format
static func formatBudget(number: int) -> String:
	var number_str = str(number)
	var formatted_number = ""
	var length = number_str.length()
	for i in range(length):
		formatted_number += number_str[length - 1 - i]
		if (i + 1) % 3 == 0 and i + 1 != length:
			formatted_number += " "
	return formatted_number.reverse()
