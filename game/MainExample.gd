# Main.gd
# Ceci est juste un test, pour prendre en main la gestion des BDD sur Godot 4.
# Seront ajoutés des populate() etc.
# Dans le jeu, il faudra aussi mettre en place le mode déconnecté, bien sur.
extends Node

func _ready():
	var database_manager = DBManager.new("res://data/iut_tables.db")  # Correctement instancié
	if database_manager.open_db():
		# Ajoutons un étudiant
		var query = "INSERT INTO Students (year, dept, mood, level) VALUES (?, ?, ?, ?)"
		if database_manager.execute(query, [1, 2, randf_range(0.7, 1.0), randf_range(0.5, 1.0)]):
			print("Étudiant ajouté avec succès.")
			database_manager.print_entries("SELECT * FROM Students")
	else:
		print("Échec de l'ouverture de la base de données.")
	
	#database_manager.clear_tables() # uniquement à la fin du jeu
	database_manager.close_db()
	print("Fin du test.")
