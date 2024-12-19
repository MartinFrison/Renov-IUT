# Global.gd
class_name Global
extends Node

# Connection globale
var db = DBManager.new("res://data/iut_tables.db")
var ok = db.open_db()

# Variables globales
var normal_inflation_rate = 0.057
var indexation_rate = normal_inflation_rate - 0.01
#var csv_path : String = "res://data/urgencies.csv"

func create_iut_db():
	var delete
	delete = "DROP TABLE IF EXISTS Students"
	db.execute(delete)
	delete = "DROP TABLE IF EXISTS Teachers"
	db.execute(delete)
	delete = "DROP TABLE IF EXISTS Notifications;"
	db.execute(delete)
	
	# Créer les tables si elles n'existent pas déjà
	var create_students_table_query = """
	CREATE TABLE IF NOT EXISTS Students (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		year INTEGER CHECK(year BETWEEN 1 AND 3),
		dept TEXT,
		mood REAL CHECK(mood >= 0 AND mood <= 1),
		level REAL CHECK(level >= 0 AND level <= 1),
		base_level REAL CHECK(level >= -1 AND level <= 1)
	);
	"""

	var create_teachers_table_query = """
	CREATE TABLE IF NOT EXISTS Teachers (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		dept TEXT,
		mood REAL CHECK(mood >= 0 AND mood <= 1),
		full_time BOOLEAN
	);
	"""

	var create_notifications_table_query = """
	CREATE TABLE IF NOT EXISTS Notifications (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		message TEXT,
		object TEXT,
		date TEXT,
		type INTEGER
	);
	"""


	# Exécuter les requêtes de création de tables
	var queries = [
		create_students_table_query,
		create_teachers_table_query,
		create_notifications_table_query,
	]

	for query in queries:
		if !db.execute(query):
			print("Erreur lors de la création de la table.")
	print("Les bases de données on été créer")

	#fill_notifications_from_csv(csv_path)
	
	# db.clear_tables()
	
# Remplit la table Notifications avec des événements contenus dans un fichier CSV
#func fill_notifications_from_csv(file_path : String):
#	return
#	var file = FileAccess.open(file_path, FileAccess.READ)
#	
#	if !file:
#		print("Erreur lors de l'ouverture du fichier CSV.")
#		return
#	
#	# Lire la première ligne pour ignorer les en-têtes
#	file.get_line()
#
#	# Lire le contenu du fichier et insérer dans la base de données
#	while !file.eof_reached():
#		var line = file.get_line()
#		if line.begins_with("#"):
#			continue
#		var data = line.split(";")
#
#		if data.size() < 4:
#			#print("Ligne incomplète : ", line)
#			continue
#
#		var message = data[0].strip_edges()
#		var duration = int(data[1].strip_edges())
#		var is_reproductible = data[2].strip_edges() == "1"
#		var needs_action = data[3].strip_edges() == "1"
#
#		var query = "INSERT INTO Notifications (message, duration, is_reproductible, needs_action) VALUES (?, ?, ?, ?)"
#		if !db.execute(query, [message, duration, is_reproductible, needs_action]):
#			print("Erreur lors de l'ajout de la notification.")
#	file.close()


# Indexation : fonctions utilitaires
#func dept_string_to_index(dept: String) -> int:
#	var query = "SELECT id FROM Depts WHERE lower(name) = lower(?)"
#	var result = db.get_entries(query, [dept])
#	if result.size() > 0:
#		return result[0]["id"] 
#	return -1


static func dept_index_to_string(index: int) -> String:
	match index:
		1:
			return "Chimie"
		2:
			return "Génie civil"
		3:
			return "Information-Communication"
		4:
			return "Informatique"
		5:
			return "Techniques de commercialisation"
		_:
			return "Inconnu"  # Gestion des cas non définis


static func dept_string_to_index(source: String) -> int:
	match source:
		"Chimie":
			return 1
		"Génie civil":
			return 2
		"Information-Communication":
			return 3
		"Informatique":
			return 4
		"Techniques de commercialisation":
			return 5
		_:
			return -1  # Gestion des cas non définis



static func get_month_name(month: int) -> String:
	# Tableau des mois
	var months = ["janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"]
	
	# Vérifie si l'entrée est valide
	if month >= 1 and month <= 12:
		return months[month - 1]  # Les tableaux commencent à 0
	else:
		return "Invalid month"  # Retourne un message d'erreur si le mois est hors de portée




func randint_in_range(min : int, max : int) -> int:
	var rng = RandomNumberGenerator.new()
	return rng.randi_range(min, max)
	
func randfloat_in_range(min : float, max : float) -> float:
	var rng = RandomNumberGenerator.new()
	var randfloat = rng.randf()  # Un nombre flottant entre 0.0 et 1.0
	return randfloat * (max-min) + min

func randfloat_in_square_range(min : float, max : float) -> float:
	var rng = RandomNumberGenerator.new()
	var randfloat = (rng.randf()*rng.randf())**0.5  # Un nombre flottant entre 0.0 et 1.0
	var res = randfloat * (max-min) + min
	return res



# Indexation : fonctions utilitaires
func dept_string_to_index2(dept: String) -> int:
	var query = "SELECT id FROM Depts WHERE lower(name) = lower(?)"
	var result = db.get_entries(query, [dept])
	if result.size() > 0:
		return result[0]["id"] 
	return -1

func dept_index_to_string2(index: int) -> String:
	var query = "SELECT name FROM Depts WHERE id=?"
	var result = db.get_entries(query, [index])
	if result.size() > 0:
		return result[0]["name"]
	return ""
