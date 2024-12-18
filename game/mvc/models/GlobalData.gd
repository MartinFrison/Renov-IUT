class_name GlobalData
extends Node

# Attributs
static var _year: int
static var _month: int
static var _day: int
static var _budget: int
static var _difficulty: int = 1 # Ajuste la difficulté si c'est le mode tutoriel
static var _attractivity: float # Attractivité de l'établissement, en pourcentage
static var _pay_agent: int = 1800
static var _pay_worker: int = 2300


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

static func get_pay_agent() -> int:
	return _pay_agent

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

# Calcule l'attractivité à base des paramètres suivants :
# 	les résultats académiques
#   la satisfaction de tout le monde
#   le ratio enseignants/étudiants (pour mesurer l'attention accordée aux étudiants ; ici, 1:20 est considéré comme idéal)
#   l'état des infrastructures
static func set_attractivity() -> void:
	var target = 1.0 / 20.0  # 1 professeur pour 20 étudiants
	var attention = Teacher.compute_nb() / Student.compute_nb()
	# transformer en pourcentage si le ratio initial n'est pas atteint, sinon 100% si les profs sont encore plus nombreux
	if attention <= target:
		attention = attention/target
	else:
		attention = 1.0
	
	#var success = Student.success_rate() #déjà un pourcentage
	var mood : float = (Teacher.avg_mood() + Student.avg_mood()) / 2
	var campus : float # pour obtenir la moyenne de l'état des bâtiments
	var sum : float = 0.0
	for i in range(1,6):
		var code = Utils.dept_index_to_string(i)
		sum += Building.get_building(code).get_inventory() / 100
	campus = sum / 5
	
	_attractivity = round((mood + campus + attention) / 3 * 100) / 100  # Arrondir à 2 décimales
	
	ObserverGlobalData.notifyAttractivityChanged()

static func adjust_attractivity() -> void:
	var fluctuation : float
	var performance : float = Student.avg_level() # on ajuste en fonction du niveau des étudiants
	# idéalement, il faudrait trouver une modélisation mathématique un minimum correcte ;
	# pour l'instant, cela ne fait que donner une priorité aléatoire à un critère.
	# Et que cela ne soit pas au pif.
	if performance >= 0.7: # i.e. 14/20 de moyenne globale
		fluctuation = Utils.randfloat_in_range(1.2, 1.4)
	elif performance >= 0.5: # i.e. 10/20 de moyenne globale
		fluctuation = Utils.randfloat_in_range(1.0, 1.2)
	else: # donner une chance, même
		fluctuation = Utils.randfloat_in_range(0.9, 1.1)
	_attractivity *= fluctuation
	if _attractivity > 1:
		_attractivity = .99
	
	_attractivity = round(_attractivity * 100) / 100

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
	# moduler l'attractivité à la fin de l'année
	if isEndofYear():
		set_attractivity()
		adjust_attractivity()
	ObserverGlobalData.notifyAttractivityChanged()
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
			return 3500000
			#return 0
		2:
			return 2200000
			#return 0
		3:
			return 1000000
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
			return 0.8
		2:
			return 0.6  
		3:
			return 0.3
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
