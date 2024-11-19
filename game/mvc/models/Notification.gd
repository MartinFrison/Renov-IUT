# Notification.gd
class_name Notification
extends Node

# Fonction pour obtenir tous les IDs de la table NotificationSQLTable
static func get_all_ids() -> Array:
	var ids = []
	var query = "SELECT id FROM Notifications"
	var result = Utils.db.get_entries(query)

	for r in result:
		ids.append(r["id"])
	return ids

# Fonction pour récupérer le message d'une notification par ID
static func get_message(id: int) -> String:
	var query = "SELECT message FROM Notifications WHERE id = ?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["message"]
	return ""

# Fonction pour récupérer l'objet d'une notification par ID
static func get_object(id: int) -> String:
	var query = "SELECT object FROM Notifications WHERE id = ?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["object"]
	return ""

# Fonction pour récupérer la date d'une notification par ID (format chaîne)
static func get_date(id: int) -> String:
	var query = "SELECT date FROM Notifications WHERE id = ?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["date"]
	return ""  # Retourne une chaîne vide si non trouvée

# Fonction pour récupérer le type d'une notification par ID
# Décrit le sujet concerner
# 0 = message simple
# 1 = etudiant
# 2 = profs
# 3 = event
# 4 = facture
# 5 = fonds
# 6 = batiment
static func get_type(id: int) -> int:
	var query = "SELECT type FROM Notifications WHERE id = ?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["type"]
	return -1  # Retourne -1 si le type n'est pas trouvé

# Ajout d'une notification (la date est fournie comme chaîne de caractères)
static func add_notification(message: String, object: String, date: String, type: int) -> void:
	var query = "INSERT INTO Notifications (message, object, date, type) VALUES (?, ?, ?, ?)"
	if !Utils.db.execute(query, [message, object, date, type]):
		print("Erreur lors de l'ajout de la notification")
