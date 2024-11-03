# Main.gd
# Ceci est juste un test, pour prendre en main la gestion des BDD sur Godot 4.
# Seront ajoutés des populate() etc.
class_name Exemple
extends Node

func _init():
	if Utils.ok:
		var s = Study.new()
		var t = Teaching.new()
		s.populate()
		t.populate()
	
	#Utils.db.clear_tables()
	Utils.db.close_db()
	print("Fin du test.")
