# Fund.gd
class_name Fund
extends RefCounted # ne nécessite pas d'interaction avec le moteur de scène

static func add_fund(source : String, amount : float, destination : String, time : int) -> void:
	var query = "INSERT INTO Funds (amount, source, area, time) VALUES (?, ?, ?, ?)"
	var src = Utils.source_string_to_index(source)
	var dt = Utils.dept_string_to_index(destination)
	
	if !Utils.db.execute(query, [amount, src, dt, time]):
		print("Erreur d'ajout.")
		return
		
static func add_fund_unspecified(source : String, amount : float, time : int) -> void:
	var query = "INSERT INTO Funds (amount, source, time) VALUES (?, ?, ?)"
	var src = Utils.source_string_to_index(source)
	var dt = Utils.dept_string_to_index(destination)
	
	if !Utils.db.execute(query, [amount, src, time]):
		print("Erreur d'ajout.")
		return		
		
static func add_fund_by_index(source : int, amount : float, destination : int, time : int) -> void:
	var query = "INSERT INTO Funds (amount, source, area, time) VALUES (?, ?, ?, ?)"
	
	if !Utils.db.execute(query, [amount, source, destination, time]):
		print("Erreur d'ajout.")
		return

static func rm_fund_by_id(id : int) -> void:
	var query = "DELETE FROM Funds WHERE id=?"
	if !Utils.db.execute(query, [id]):
		print("Erreur de suppression.")
		return

static func rm_fund_by_source(source : String) -> void:
	var query = "DELETE FROM Funds WHERE source=?"
	var src = Utils.source_string_to_index(source)
	if !Utils.db.execute(query, [src]):
		print("Erreur de suppression.")
		return

# Getters
static func  get_source(id : int) -> String:
	var query = "SELECT source FROM Funds WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		var source = result[0]["source"]
		return Utils.source_index_to_string(source)
	return ""
	
static func get_amount(id : int) -> float:
	var query = "SELECT amount FROM Funds WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["amount"]
	return -1.0
	
static func get_area(id : int) -> String:
	var query = "SELECT area FROM Funds WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		var area = result[0]["area"]
		return Utils.dept_index_to_string(area)
	return ""
	
static func get_time (id : int) -> int:
	var query = "SELECT time FROM Funds WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["time"]
	return -1
	
# Setters
static func set_area(id : int, dest : String) -> void:
	var query = "UPDATE Funds SET area=? WHERE id=?"
	var dst = Utils.dept_string_to_index(dest)
	if !Utils.db.execute(query, [dst, id]):
		return
	
static func set_time(id : int, time : int) -> void:
	var query = "UPDATE Funds SET time=? WHERE id=?"
	if !Utils.db.execute(query, [time, id]):
		return
	
# Stats
static func total() -> float:
	var query = "SELECT sum(amount) AS total FROM Funds"
	var result = Utils.db.get_entries(query)
	if result.size() > 0:
		return result[0]["total"]
	return -1.0
	
static func total_per_dept(dept : String) -> float:
	var query = "SELECT sum(amount) AS total FROM Funds WHERE area=?"
	var dt = Utils.dept_string_to_index(dept)
	var result = Utils.db.get_entries(query, [dt])
	if result.size() > 0:
		return result[0]["total"]
	return -1.0

static func inflation_adjusted(indexation_rate : float) -> void:
	var query = "SELECT id, amount FROM Funds"
	var entries = Utils.db.get_entries(query)
	for entry in entries:
		var fund_id = entry["id"]  # Récupérer l'ID du financement
		var adjusted_amount = entry["amount"] * (1 + indexation_rate)  # Calculer le montant ajusté

		# Mettre à jour le montant
		var query_upd = "UPDATE Funds SET amount = ? WHERE id = ?"
		if !Utils.db.execute(query_upd, [adjusted_amount, fund_id]):
			print("Erreur lors de la mise à jour du montant pour ID : ", fund_id)
			
static func normal_inflation_adjusted() -> void:
	inflation_adjusted(Utils.normal_indexation_rate)

static func check_availability(amount : float, dest : String) -> bool:
	var available = total_per_dept(dest)
	if available>=amount:
		return true
	return false

static func forecast() -> float:
	var query = "SELECT id, amount FROM Funds"
	var entries = Utils.db.get_entries(query)
	var adjusted_total = 0.0
	for entry in entries:
		var fund_id = entry["id"]  # Récupérer l'ID du financement
		adjusted_total += entry["amount"] * (1 + Utils.indexation_rate)  # Calculer en fonction de la constante
	return adjusted_total
