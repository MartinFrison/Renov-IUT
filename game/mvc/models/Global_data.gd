class_name Global_data
extends Node

# Attributs
static var _year: int
static var _month: int
static var _day: int
static var _budget: int
static var _difficulty: int

# Fonction pour définir le budget
static func setBudget(montant : int) -> void:
	_budget = montant

# Fonction pour ajouter au budget
static func addBudget(montant : int) -> void:
	_budget += montant

# Fonction pour obtenir le budget
static func getBudget() -> int:
	return _budget




#definir la date
static func setDate(day : int, month : int, year : int) -> void:
	_day = day
	_month = month
	_year = year
	

#Passe au jour suivant
static func incrementDay() -> void:
	_day += 1
	if _day > 30:  # Mois de 30 jours par exemple
		_day = 1
		_month += 1
	if _month > 12:
		_month = 1
		_year += 1


#Renvoie vrai si c'est le premier du mois
static func isNewMonth() -> bool:
	return _day==1

#Renvoie vrai si c'est la fin d'année
static func isEndofYear() -> bool:
	return _month==7	

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

static func get_difficulty() -> int:
	return _difficulty
