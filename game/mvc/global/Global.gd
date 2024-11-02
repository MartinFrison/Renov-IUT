# Global.gd
class_name Global
extends Node

# Connection globale
var db = DBManager.new("res://data/iut_tables.db")
var ok = db.open_db()

# Variables globales
var normal_inflation_rate = 0.057
var indexation_rate = normal_inflation_rate - 0.01




func create_iut_db():
	
	# Créer les tables si elles n'existent pas déjà
	var create_students_table_query = """
	CREATE TABLE IF NOT EXISTS Students (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		year INTEGER CHECK(year BETWEEN 1 AND 3),
		dept TEXT,
		mood REAL CHECK(mood >= 0 AND mood <= 1),
		level REAL CHECK(level >= 0 AND level <= 1)
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

	var create_funds_table_query = """
	CREATE TABLE IF NOT EXISTS Funds (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		amount REAL,
		source TEXT,
		area TEXT,
		time INTEGER
	);
	"""

	var create_notifications_table_query = """
	CREATE TABLE IF NOT EXISTS Notifications (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		message TEXT,
		duration INTEGER,
		is_reproductible BOOLEAN,
		needs_action BOOLEAN,
		area TEXT
	);
	"""

	# Requête pour créer la table EventSQLTable
	var create_events_table_query = """
	CREATE TABLE IF NOT EXISTS Events (
		id_event INTEGER PRIMARY KEY AUTOINCREMENT,
		name TEXT
	);
	"""

	# Requête pour créer la table choiceSQLTable
	var create_choices_table_query = """
	CREATE TABLE IF NOT EXISTS Choices (
		id_event INTEGER,
		id_choice INTEGER,
		description TEXT,
		PRIMARY KEY(id_event, id_choice),
		FOREIGN KEY(id_event) REFERENCES Events(id_event) ON DELETE CASCADE
	);
	"""

	# Requête pour créer la table ConsequencesSQLTable
	var create_consequences_table_query = """
	CREATE TABLE IF NOT EXISTS Consequences (
		id_choice INTEGER,
		id_consequences INTEGER,
		description TEXT,
		PRIMARY KEY(id_choice, id_consequences),
		FOREIGN KEY(id_choice) REFERENCES Choices(id_choice) ON DELETE CASCADE
	);
	"""

	# Exécuter les requêtes de création de tables
	var queries = [
		create_students_table_query,
		create_teachers_table_query,
		create_funds_table_query,
		create_notifications_table_query,
		create_events_table_query,
		create_choices_table_query,
		create_consequences_table_query
	]

	for query in queries:
		if !db.db.query(query):
			print("Erreur lors de la création de la table.")
		else:
			print("Table créée avec succès.")

	db.clear_tables()







# Fonctions utilitaires
func dept_string_to_index(dept: String) -> int:
	var query = "SELECT id FROM Depts WHERE lower(name) = lower(?)"
	var result = db.get_entries(query, [dept])
	if result.size() > 0:
		return result[0]["id"] 
	return -1

func dept_index_to_string(index: int) -> String:
	var query = "SELECT name FROM Depts WHERE id=?"
	var result = db.get_entries(query, [index])
	if result.size() > 0:
		return result[0]["name"]
	return ""
	
func source_string_to_index(source : String) -> int:
	var query = "SELECT id FROM Sources WHERE lower(name) = lower(?)"
	var result = db.get_entries(query, [source])
	if result.size() > 0:
		return result[0]["id"]
	return -1
	
func source_index_to_string(index : int) -> String:
	var query = "SELECT name FROM Sources WHERE id=?"
	var result = db.get_entries(query, [index])
	if result.size() > 0:
		return result[0]["name"]
	return ""
