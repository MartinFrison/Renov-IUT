# Database.gd
class_name Database
extends Node

var db: SQLite
var db_path: String

# Constructeur
func _init(path: String):
	db_path = path

# Ouvrir la base de données
func open_database() -> bool:
	db = SQLite.new()
	if db.open(db_path) != OK:
		print("Erreur lors de l'ouverture de la base de données.")
		return false
	return true

# Fermer la base de données
func close_database() -> void:
	if db:
		db.close()

# Exécuter une requête générale (INSERT, SELECT, DELETE, UPDATE)
func execute_query(query: String, params: Array = []) -> bool:
	db.query_begin()

	# Préparer la requête
	var statement = db.prepare(query)
	if statement == null:
		print("Erreur à la préparation de la requête : ", db.get_last_error())
		db.query_rollback()
		return false

	# Lier les paramètres
	for i in range(params.size()):
		statement.bind_value(i + 1, params[i])  # Les index commencent à 1 pour SQLite

	# Exécuter la requête
	if statement.step() != OK:
		print("Erreur à l'exécution de la requête : ", db.get_last_error())
		db.query_rollback()
		return false

	db.query_commit()
	return true

# Obtenir plusieurs entrées
func get_entries(query: String, params: Array = []) -> Array:
	var results = []

	# Préparer la requête
	var statement = db.prepare(query)
	if statement == null:
		print("Erreur à la préparation de la requête : ", db.get_last_error())
		return results

	# Lier les paramètres
	for i in range(params.size()):
		statement.bind_value(i + 1, params[i])  # Les index commencent à 1 pour SQLite

	# Exécuter la requête
	if statement.step() != OK:
		print("Erreur la récupération des entrées : ", db.get_last_error())
		return results

	# Ajouter les lignes dans le tableau de résultats
	while statement.fetch_row():
		var result_entry = {}
		for column_idx in range(statement.get_column_count()):
			result_entry[statement.get_column_name(column_idx)] = statement.get_column_data(column_idx)
		results.append(result_entry)

	return results
