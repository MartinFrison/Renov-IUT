# Teacher.gd
class_name Teacher
extends Node

static var teacher_id_counter: int = 0  # Compteur d'ID pour les enseignants

# Fonction pour obtenir tous les IDs de la table TeacherSQLTable
static func get_all_ids() -> Array:
	var ids = []
	var query = "SELECT id FROM Teachers"
	var result = Utils.db.get_entries(query)

	for r in result:
		ids.append(r["id"])
	return ids

# Fonction pour obtenir tous les IDs de la table par departement
static func get_dept_ids(dept : String) -> Array:
	var ids = []
	var dt = Utils.dept_string_to_index(dept)
	var query = "SELECT id FROM Teachers where dept= ? "
	var result = Utils.db.get_entries(query, [dt])

	for r in result:
		ids.append(r["id"])
	return ids



# Ajout et suppression
# Retourne l'id du prof ajouter
static func add_teacher(dept: String) -> int:
	# Incrémente le compteur pour générer un nouvel ID
	teacher_id_counter += 1

	var query = "INSERT INTO Teachers (id, dept, mood) VALUES (?, ?, ?)"
	var dt = Utils.dept_string_to_index(dept)
	if !Utils.db.execute(query, [teacher_id_counter, dt, randf_range(0.4, 0.6)]): # Les enseignants sont moins emballés que les élèves !
		print("Erreur d'ajout.")
		teacher_id_counter -= 1  # Réinitialise le compteur si l'insertion échoue
		return -1  # Retourne -1 en cas d'échec

	# Retourne le nouvel ID
	return teacher_id_counter


static func rm_teacher_by_id(id : int) -> void:
	var query = "DELETE FROM Teachers WHERE id=?"
	if !Utils.db.execute(query, [id]):
		print("Erreur de suppression.")
		return

static func rm_teachers_by_dept(dept: String, nb: int) -> void:
	# Récupérer les IDs des profs dans le département spécifié
	var ids_query = "SELECT id FROM Teachers WHERE dept = ? LIMIT ?"
	var dt = Utils.dept_string_to_index(dept)
	var ids = Utils.db.get_entries(ids_query, [dt, nb])  # Récupérer les IDs avec une limite

	# Supprimer les profs en fonction des IDs récupérés
	for id_entry in ids:
		var id = id_entry["id"]  # Récupérer l'ID du prof
		rm_teacher_by_id(id)

# Fonction pour supprimer les profs insatisfait
static func rm_teacher_by_mood(mood : float) -> void:
	var query = "DELETE FROM Teachers WHERE mood<?"
	if !Utils.db.execute(query, [mood]):
		print("Erreur de suppression.")
		return


# Getters
static func get_dept(id : int) -> String:
	var query = "SELECT dept FROM Teachers WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		var dept = result[0]["dept"]
		return Utils.dept_index_to_string(dept)
	return ""

static func get_mood(id : int) -> float:
	var query = "SELECT mood FROM Teachers WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["mood"]
	return -1.0

# Setters
static func set_mood(id : int, coeff: float) -> void:
	coeff = max(min(1,coeff),0)
	var query = "UPDATE Teachers SET mood=? WHERE id=?"
	if !Utils.db.execute(query, [coeff, id]):
		return

# Stats
static func compute_nb_per_dept(dept : String) -> int:
	var query = "SELECT count(*) AS nb FROM Teachers WHERE dept=?"
	var dt = Utils.dept_string_to_index(dept)
	var result = Utils.db.get_entries(query, [dt])
	if result.size() > 0:
		return result[0]["nb"]
	return -1

static func avg_mood_per_dept(dept: String) -> float:
	var query = "SELECT mood FROM Teachers WHERE dept = ?"
	var dt = Utils.dept_string_to_index(dept)
	var entries = Utils.db.get_entries(query, [dt])
	var mood_sum: float = 0.0
	var count: int = entries.size()

	for entry in entries:
		mood_sum += entry["mood"]

	if count > 0:
		return round((mood_sum / count) * 100) / 100
	else:
		return 0.0

static func compute_nb() -> float:
	var query = "SELECT count(*) AS nb FROM Teachers"
	var result = Utils.db.get_entries(query)
	if result.size() > 0:
		return result[0]["nb"]
	return -1.0

static func avg_mood() -> float:
	var query = "SELECT mood FROM Teachers"
	var entries = Utils.db.get_entries(query)
	var mood_sum: float = 0.0
	var count: int = entries.size()

	for entry in entries:
		mood_sum += entry["mood"]

	if count > 0:
		return round((mood_sum / count) * 100) / 100
	else:
		return 0.0
	
	return 1.0
