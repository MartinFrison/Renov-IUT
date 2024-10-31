# Utils.gd
class_name Glob
extends Node

# Connection globale
var db = DBManager.new("res://data/iut_tables.db")
var ok = db.open_db()

# Fonctions utilitaires
func dept_string_to_index(dept: String) -> int:
	var query = "SELECT id FROM Depts WHERE lower(name) = lower(?)"
	var result = db.get_entries(query, [dept])
	if result.size() > 0:
		return result[0]["id"] 
	return -1

func dept_index_to_string(index: int) -> String:
	var query = "SELECT name FROM Depts WHERE id=?"
	var result = db.get_entries(query, [index])
	if result.size() > 0:
		return result[0]["name"]
	return ""
