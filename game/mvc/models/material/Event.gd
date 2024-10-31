class_name Event
extends Node



# Récupère le nom de l'événement en fonction de l'id_event
func event_name(id_event: int) -> String:
	var query = "SELECT name FROM Events WHERE id_event = ?"
	var result = Utils.db.get_entries(query, [id_event])
	if result.size() > 0:
		return result[0]["name"]
	return ""


# Récupère les choix associés à un événement
func event_choice(id_event: int) -> Array:
	var query = "SELECT id_choice, description FROM Choices WHERE id_event = ?"
	var result = Utils.db.get_entries(query, [id_event])
	return result


# Récupère les conséquences associées à un choix donné
func choice_consequences(id_choice: int) -> Array:
	var query = "SELECT id_consequences, description FROM Consequences WHERE id_choice = ?"
	var result = Utils.db.get_entries(query, [id_choice])
	return result 
