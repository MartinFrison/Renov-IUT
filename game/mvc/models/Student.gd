# Student.gd
class_name Student
extends RefCounted # ne nécessite pas d'interaction avec le moteur de scène

# Attributs
var id: int # dans une version ultérieure, on pourrait donner un nom à chaque étudiant
var year: int # année d'étude, i.e. 1, 2 ou 3
var dept: String # département
var mood: float # taux de satisfaction, entre 0 et 1
var level: float # niveau académique, entre 0 et 1

# Ajout et suppression
func add_student(dept : String) -> void:
	var query = "INSERT INTO Students (year, dept, mood, level) VALUES (?, ?, ?, ?)"
	var dt = Utils.dept_string_to_index(dept)
	if !Utils.db.execute(query, [1, dt, randf_range(0.7, 1.0), randf_range(0.5, 1.0)]):
		print("Erreur d'ajout.")
		return

func rm_student_by_id(id : int) -> void:
	var query = "DELETE FROM Students WHERE id=?"
	if !Utils.db.execute(query, [id]):
		print("Erreur de suppression.")
		return

func rm_students_by_dept(dept: String, nb: int) -> void:
	# Récupérer les IDs des étudiants dans le département spécifié
	var ids_query = "SELECT id FROM Students WHERE dept = ? LIMIT ?"
	var dt = Utils.dept_string_to_index(dept)
	var ids = Utils.db.get_entries(ids_query, [dt, nb])  # Récupérer les IDs avec une limite

	# Supprimer les étudiants en fonction des IDs récupérés
	var delete_query = "DELETE FROM Students WHERE id = ?"
	
	for id_entry in ids:
		var id = id_entry["id"]  # Récupérer l'ID de l'étudiant
		if !Utils.db.execute(delete_query, [id]):
			print("Erreur de suppression de l'étudiant avec ID:", id)
			return

# Getters
func get_year(id : int) -> int:
	var query = "SELECT year FROM Students WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["year"]
	return -1

func get_dept(id : int) -> String:
	var query = "SELECT dept FROM Students WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		var dept = result[0]["dept"]
		return Utils.dept_index_to_string(dept)
	return ""

func get_mood(id : int) -> float:
	var query = "SELECT mood FROM Students WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["mood"]
	return -1.0

func get_level(id : int) -> float:
	var query = "SELECT level FROM Students WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["level"]
	return -1.0

# Setters
func set_year(id : int, new_year: int) -> void:
	var query = "UPDATE Students SET year=? WHERE id=?"
	if !Utils.db.execute(query, [new_year, id]):
		return

func set_mood(id : int, coeff: float) -> void:
	var query = "UPDATE Students SET mood=mood*? WHERE id=?"
	if !Utils.db.execute(query, [coeff, id]):
		return

func set_level(id : int, coeff: float) -> void:
	var query = "UPDATE Students SET level=level*? WHERE id=?"
	if !Utils.db.execute(query, [coeff, id]):
		return

# Stats
func compute_nb_per_dept(dept : String) -> float:
	var query = "SELECT count(*) AS nb FROM Students WHERE dept=?"
	var dt = Utils.dept_string_to_index(dept)
	var result = Utils.db.get_entries(query, [dt])
	if result.size() > 0:
		return result[0]["nb"]
	return -1.0

func avg_mood_per_dept(dept: String) -> float:
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

func compute_nb() -> float:
	var query = "SELECT count(*) AS nb FROM Students"
	var result = Utils.db.get_entries(query)
	if result.size() > 0:
		return result[0]["nb"]
	return -1.0

func avg_mood() -> float:
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
	
func success_rate_per_dept(dept : String) -> float:
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

func success_rate() -> float:
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
