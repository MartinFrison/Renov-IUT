# Main.gd
# Ceci est juste un test, pour prendre en main la gestion des BDD sur Godot 4.
# Seront ajoutés des populate() etc.
class_name Exemple
extends Node

func add_fund(source : String, amount : float, destination : String, time : int) -> void:
	var query = "INSERT INTO Funds (amount, source, area, time) VALUES (?, ?, ?, ?)"
	var src = Utils.source_string_to_index(source)
	var dt = Utils.dept_string_to_index(destination)
	
	if !Utils.db.execute(query, [amount, src, dt, time]):
		print("Erreur d'ajout.")
		return

func rm_fund_by_id(id : int) -> void:
	var query = "DELETE FROM Funds WHERE id=?"
	if !Utils.db.execute(query, [id]):
		print("Erreur de suppression.")
		return

func rm_fund_by_source(source : String) -> void:
	var query = "DELETE FROM Funds WHERE source=?"
	var src = Utils.source_string_to_index(source)
	if !Utils.db.execute(query, [src]):
		print("Erreur de suppression.")
		return

# Getters
func  get_source(id : int) -> String:
	var query = "SELECT source FROM Funds WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		var source = result[0]["source"]
		return Utils.source_index_to_string(source)
	return ""
	
func get_amount(id : int) -> float:
	var query = "SELECT amount FROM Funds WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["amount"]
	return -1.0
	
func get_area(id : int) -> String:
	var query = "SELECT area FROM Funds WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		var area = result[0]["area"]
		return Utils.dept_index_to_string(area)
	return ""
	
func get_time (id : int) -> int:
	var query = "SELECT time FROM Funds WHERE id=?"
	var result = Utils.db.get_entries(query, [id])
	if result.size() > 0:
		return result[0]["time"]
	return -1
	
# Setters
func set_area(id : int, dest : String) -> void:
	var query = "UPDATE Funds SET area=? WHERE id=?"
	var dst = Utils.dept_string_to_index(dest)
	if !Utils.db.execute(query, [dst, id]):
		return
	
func set_time(id : int, time : int) -> void:
	var query = "UPDATE Funds SET time=? WHERE id=?"
	if !Utils.db.execute(query, [time, id]):
		return
	
# Stats
func total() -> float:
	var query = "SELECT sum(amount) AS total FROM Funds"
	var result = Utils.db.get_entries(query)
	if result.size() > 0:
		return result[0]["total"]
	return -1.0
	
func total_per_dept(dept : String) -> float:
	var query = "SELECT sum(amount) AS total FROM Funds WHERE area=?"
	var dt = Utils.dept_string_to_index(dept)
	var result = Utils.db.get_entries(query, [dt])
	if result.size() > 0:
		return result[0]["total"]
	return -1.0

func inflation_adjusted(indexation_rate : float) -> void:
	var query = "SELECT id, amount FROM Funds"
	var entries = Utils.db.get_entries(query)
	for entry in entries:
		var fund_id = entry["id"]  # Récupérer l'ID du financement
		var adjusted_amount = entry["amount"] * (1 + indexation_rate)  # Calculer le montant ajusté

		# Mettre à jour le montant
		var query_upd = "UPDATE Funds SET amount = ? WHERE id = ?"
		if !Utils.db.execute(query_upd, [adjusted_amount, fund_id]):
			print("Erreur lors de la mise à jour du montant pour ID : ", fund_id)
			
func normal_inflation_adjusted() -> void:
	inflation_adjusted(Utils.normal_indexation_rate)

func check_availability(amount : float, dest : String) -> bool:
	var available = total_per_dept(dest)
	if available>=amount:
		return true
	return false

func forecast() -> float:
	var query = "SELECT id, amount FROM Funds"
	var entries = Utils.db.get_entries(query)
	var adjusted_total = 0.0
	for entry in entries:
		var fund_id = entry["id"]  # Récupérer l'ID du financement
		adjusted_total += entry["amount"] * (1 + Utils.indexation_rate)  # Calculer en fonction de la constante
	return adjusted_total

func _init():
	if Utils.ok:
		 # Tester ajout d'un fonds
		print("Ajout de fonds...")
		add_fund("Etat", 100.0, "Chimie", 2024) 
		add_fund("région Grand-Est", 89.04, "Informatique", 2024) 
		add_fund("Etat", 34.34, "Informatique", 2024)
		add_fund("partenariat", 65.0, "Informatique", 2024)
		add_fund("partenariat", 456.90, "Génie civil", 2024) 
		add_fund("Eurométropole", 54.0, "Génie civil", 2024)
		
		# Tester récupérer le montant
		print("Total des fonds : ", total())

		# Tester obtenir un fonds par ID (vous devrez mettre un ID valide)
		var fund_id = 190
		print("Obtention de la source pour le financement ", fund_id, ": ", get_source(fund_id))
		print("Montant pour le financement ", fund_id, ": ", get_amount(fund_id))

		# Tester mise à jour de la destination
		print("Mise à jour de la destination pour le financement ", fund_id)
		var dt = "Information-Communication"
		set_area(fund_id, dt)
		print("Le financement ", fund_id, " va au département ", get_area(fund_id))

		# Tester mise à jour du temps
		print("Mise à jour du temps pour le financement ", fund_id)
		set_time(fund_id, 2025)

		# Tester suppression par ID
		print("Suppression du fonds ID ", fund_id)
		rm_fund_by_id(fund_id+1)

		# Tester total par département
		var dept = "Informatique"
		print("Total par département ", dept, " : ", total_per_dept(dept))

		# Tester ajustement de l'inflation
		print("Ajustement des fonds en fonction de l'inflation...")
		inflation_adjusted(0.05)
		
		# Tester la récupération des fonds après ajustement
		print("Total par département ", dept, " : ", total_per_dept(dept))
		
		# Tester si le département dispose de 2000€
		var amount = 2000
		print("Le département ", dept, " dispose-t-il de ", amount, "€ ? ", check_availability(amount, dept))
		
		# Anticiper l'indexation des financements
		print("Total espéré l'année prochaine : ", forecast())
	
	
	Utils.db.clear_tables() # uniquement à la fin du jeu
	Utils.db.close_db()
	print("Fin du test.")
