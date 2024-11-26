# Student.gd
class_name Student
extends Node 


# Fonction pour obtenir tous les IDs de la table StudentSQLTable
static func get_all_ids() -> Array:
	var ids = []
	var query = "SELECT id FROM Students"
	var result = Utils.db.get_entries(query)

	for r in result:
		ids.append(r["id"])
	return ids


# Fonction pour obtenir tous les IDs de la table par departement
static func get_dept_ids(dept : String) -> Array:
	var ids = []
	var dt = Utils.dept_string_to_index(dept)
	var query = "SELECT id FROM Students where dept= ? "
	var result = Utils.db.get_entries(query, [dt])
	for r in result:
		ids.append(r["id"])
	return ids


# Ajout et suppression
static func add_student(dept : String, year : int) -> void:
	var query = "INSERT INTO Students (year, dept, mood, level) VALUES (?, ?, ?, ?)"
	var dt = Utils.dept_string_to_index(dept)
	if !Utils.db.execute(query, [year, dt, randf_range(0.7, 1.0), randf_range(0.5, 1.0)]):
		print("Erreur d'ajout.")
		return

static func rm_student_by_id(id : int) -> void:
	var query = "DELETE FROM Students WHERE id=?"
	if !Utils.db.execute(query, [id]):
		print("Erreur de suppression.")
		return


static func rm_students_by_dept(dept: String, nb: int) -> void:
	# Récupérer les IDs des étudiants dans le département spécifié
	var ids_query = "SELECT id FROM Students WHERE dept = ? LIMIT ?"
	var dt = Utils.dept_string_to_index(dept)
	var ids = Utils.db.get_entries(ids_query, [dt, nb])  # Récupérer les IDs avec une limite

	# Supprimer les étudiants en fonction des IDs récupérés
	for id_entry in ids:
		var id = id_entry["id"]  # Récupérer l'ID de l'étudiant
		rm_student_by_id(id)

# Fonction pour supprimer les etudiants insatisfait
static func rm_student_by_mood(mood : float) -> void:
	var query = "DELETE FROM Students WHERE mood<?"
	if !Utils.db.execute(query, [mood]):
		print("Erreur de suppression.")
		return




# Getters
static func get_year(id : int) -> int:
	var query = "SELECT year FROM Students WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["year"]
	return -1

static func get_dept(id : int) -> String:
	var query = "SELECT dept FROM Students WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		var dept = result[0]["dept"]
		return Utils.dept_index_to_string(int(dept))
	return ""

static func get_mood(id : int) -> float:
	var query = "SELECT mood FROM Students WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["mood"]
	return -1.0

static func get_level(id : int) -> float:
	var query = "SELECT level FROM Students WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["level"]
	return -1.0

# Setters
static func set_year(id : int, new_year: int) -> void:
	var query = "UPDATE Students SET year=? WHERE id=?"
	if !Utils.db.execute(query, [new_year, id]):
		return

static func set_mood(id : int, coeff: float) -> void:
	coeff = max(min(1,coeff),0)
	var query = "UPDATE Students SET mood=mood*? WHERE id=?"
	if !Utils.db.execute(query, [coeff, id]):
		return

static func set_level(id : int, coeff: float) -> void:
	coeff = max(min(1,coeff),0)
	var query = "UPDATE Students SET level=level*? WHERE id=?"
	if !Utils.db.execute(query, [coeff, id]):
		return

# Stats
static func compute_nb_per_dept(dept : String) -> float:
	var query = "SELECT count(*) AS nb FROM Students WHERE dept=?"
	var dt = Utils.dept_string_to_index(dept)
	var result = Utils.db.get_entries(query, [dt])
	if result.size() > 0:
		return result[0]["nb"]
	return -1.0

static func avg_mood_per_dept(dept: String) -> float:
	var query = "SELECT mood FROM Students WHERE dept = ?"
	var dt = Utils.dept_string_to_index(dept)
	var entries = Utils.db.get_entries(query, [dt])
	var mood_sum: float = 0.0
	var count: int = entries.size()

	for entry in entries:
		mood_sum += entry["mood"]

	if count > 0:
		return round((mood_sum / count)* 100) / 100
	else:
		return 0.0


static func avg_level_per_dept(dept: String) -> float:
	var query = "SELECT level FROM Students WHERE dept = ?"
	var dt = Utils.dept_string_to_index(dept)
	var entries = Utils.db.get_entries(query, [dt])
	var level_sum: float = 0.0
	var count: int = entries.size()

	for entry in entries:
		level_sum += entry["level"]

	if count > 0:
		return round((level_sum / count)* 100) / 100
	else:
		return 0.0


static func compute_nb() -> float:
	var query = "SELECT count(*) AS nb FROM Students"
	var result = Utils.db.get_entries(query)

	if result.size() > 0:
		return result[0]["nb"]
	return -1.0

static func avg_mood() -> float:
	var query = "SELECT mood FROM Students"
	var entries = Utils.db.get_entries(query)
	var mood_sum: float = 0.0
	var count: int = entries.size()

	for entry in entries:
		mood_sum += entry["mood"]

	if count > 0:
		return round((mood_sum / count)* 100) / 100
	else:
		return 0.0
	
	return 1.0


static func avg_level() -> float:
	var query = "SELECT level FROM Students"
	var entries = Utils.db.get_entries(query)
	var level_sum: float = 0.0
	var count: int = entries.size()

	for entry in entries:
		level_sum += entry["level"]

	if count > 0:
		return round((level_sum / count)* 100) / 100
	else:
		return 0.0
	
	return 1.0


static func success_rate_per_dept(dept : String) -> float:
	var query = "SELECT level FROM Students WHERE dept = ?"
	var dt = Utils.dept_string_to_index(dept)
	var entries = Utils.db.get_entries(query, [dt])
	var success: float = 0.0
	var count: int = entries.size()

	for entry in entries:
		if entry["level"]>0.5:
			success+=1.0

	if count > 0:
		return round((success / count)* 100) / 100
	else:
		return 0.0


static func success_rate() -> float:
	var query = "SELECT level FROM Students"
	var entries = Utils.db.get_entries(query)
	var success: float = 0.0
	var count: int = entries.size()

	for entry in entries:
		if entry["level"]>0.5:
			success+=1.0

	if count > 0:
		return round((success / count)* 100) / 100
	else:
		return 0.0
	
	return 1.0
