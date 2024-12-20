# DBaseManager.gd
class_name DBManager
extends Node

var db: SQLite = null  # Instance de SQLite pour la base de données
var db_path: String  # Chemin de la base de données



# Constructeur
func _init(path: String):
	db_path = path

# Ouvrir la base de données
func open_db() -> bool:
	db = SQLite.new()
	db.path = db_path
	if !db.open_db():
		print("Erreur lors de l'ouverture de la base de données.")
		return false
	else:
		# optimisations spécifiques à SQLite
		db.query("PRAGMA synchronous = NORMAL;") # ajuste le niveau de synchronisation des transactions
		db.query("PRAGMA journal_mode = WAL;") # Write-Ahead Logging
	return true

# Fermer la base de données
func close_db() -> void:
	if db:
		db.close_db()

# Exécuter une requête générale (INSERT, DELETE, UPDATE)
func execute(query: String, params: Array = []) -> bool:
	# Vérifiez si des paramètres doivent être liés
	if params.size() > 0:
		for i in range(params.size()):
			var param = str(params[i])

			# Échapper les apostrophes pour les chaînes
			if typeof(params[i]) == TYPE_STRING:
				param = "'" + param.replace("'", "''") + "'"  # Échapper les apostrophes

			# Remplacer seulement la première occurrence de '?'
			var placeholder_index = query.find("?")  # Trouver le premier '?'
			if placeholder_index != -1:  # Si trouvé
				query = query.substr(0, placeholder_index) + param + query.substr(placeholder_index + 1)

	# Exécuter la requête
	if !db.query(query):
		print("Erreur à l'exécution de la requête.")
		return false
	return true


# Execute une requete SQL select
func get_entries(query: String, params: Array = []) -> Array:
	var results = []
	if execute(query, params):
		if db.query_result != null:
			for row in db.query_result:
				results.append(row)
		else:
			print("Aucun résultat trouvé pour la requête : ", query)
	else:
		print("Échec de l'exécution de la requête : ", query, " avec params : ", params)
	return results



# Imprimer le résultat d'une requete SELECT
# Fonction de service, par ailleurs inutile
func print_entries(query: String, params: Array = []) -> void:
	var entries = get_entries(query, params)

	if entries.size() > 0:
		var headers = entries[0].keys()  # Récupérer les noms des colonnes
		
		# Définir une largeur fixe
		var column_width = 10  # Largeur des colonnes (vous pouvez ajuster cette valeur)

		# Imprimer les en-têtes des colonnes
		var header_line = ""
		for header in headers:
			header_line += header + " ".repeat(column_width - header.length()) + " | "  # Aligner les en-têtes
		print(header_line.strip_edges())  # Afficher les en-têtes
		
		# Imprimer une ligne de séparation
		print("-".repeat(header_line.length()))  # Ligne de séparation

		# Imprimer chaque entrée
		for entry in entries:
			var values = []
			for header in headers:
				var value = entry[header]

				# Arrondir les flottants à 2 décimales
				if typeof(value) == TYPE_FLOAT:
					value = str(round(value * 100) / 100)  # Arrondir et formater
				else:
					value = str(value)  # Convertir non-flottant en chaîne

				values.append(value + " ".repeat(column_width - value.length()))  # Aligner les valeurs

			print(" | ".join(values))  # Afficher les valeurs avec le séparateur
	else:
		print("Aucune entrée correspondante.")


# Vider toutes les tables
func clear_tables() -> void:
	var tables = ["Students", "Teachers", "Notifications"]
	for table in tables:
		var query = "DELETE FROM " + table
		if !execute(query):
			print("Erreur lors du nettoyage de " + table + ".")
		else:
			print(table + " a été vidé avec succès.")
