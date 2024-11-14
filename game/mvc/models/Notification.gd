# Notification.gd
class_name Notification
extends Node

# Fonction pour obtenir tous les IDs de la table NotificationSQLTable
static func get_all_ids() -> Array:
	var ids = []
	var query = "SELECT id FROM NotificationSQLTable"
	var result = Utils.db.get_entries(query)

	for r in result:
		ids.append(r["id"])
	return ids

# Fonction pour récupérer le message d'une notification par ID
static func get_message(id: int) -> String:
	var query = "SELECT message FROM NotificationSQLTable WHERE id = ?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["message"]
	return ""

# Fonction pour récupérer l'objet d'une notification par ID
static func get_object(id: int) -> String:
	var query = "SELECT object FROM NotificationSQLTable WHERE id = ?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["object"]
	return ""

# Fonction pour récupérer la date d'une notification par ID (format chaîne)
static func get_date(id: int) -> String:
	var query = "SELECT date FROM NotificationSQLTable WHERE id = ?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["date"]
	return ""  # Retourne une chaîne vide si non trouvée

# Fonction pour récupérer le type d'une notification par ID
# 0 = (positif concernant les etudiants)
# 1 = (negatif concernant les etudiants)
# 2 = (positif concernant les profs)
# 3 = (negatif concernant les profs)
# 4 = (positif concernant le budget)
# 5 = (negatif concernant le budget)
# 6 = (positif concernant les batiments)
# 7 = (negatif concernant les batiments)
static func get_type(id: int) -> int:
	var query = "SELECT type FROM NotificationSQLTable WHERE id = ?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["type"]
	return -1  # Retourne -1 si le type n'est pas trouvé

# Ajout d'une notification (la date est fournie comme chaîne de caractères)
static func add_notification(message: String, object: String, date: String, type: int) -> void:
	var query = "INSERT INTO NotificationSQLTable (message, object, date, type) VALUES (?, ?, ?, ?)"
	if !Utils.db.execute(query, [message, object, date, type]):
		print("Erreur lors de l'ajout de la notification")

# Suppression d'une notification par ID
static func delete_notification_by_id(id: int) -> void:
	var query = "DELETE FROM NotificationSQLTable WHERE id = ?"
	if !Utils.db.execute(query, [id]):
		print("Erreur lors de la suppression de la notification")
