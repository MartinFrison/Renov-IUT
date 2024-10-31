# Building.gd
class_name Building
extends Object

# Propriétés privées
var _age: int
var _isolation: int
var _surface: int
var _heating: bool
var _maintenance_agents_nb: int
var _code: String


# Constructeur pour initialiser les propriétés
func _init(age: int, isolation: int, surface: int, heating: bool, maintenance_agents_nb: int):
	_age = age
	_isolation = isolation
	_surface = surface
	_heating = heating
	_maintenance_agents_nb = maintenance_agents_nb



# Accesseurs pour chaque propriété 
func get_code() -> String:
	return _code

func get_age() -> int:
	return _age

func get_isolation() -> int:
	return _isolation

func get_surface() -> int:
	return _surface

func is_heating() -> bool:
	return _heating

func get_maintenance_agents_nb() -> int:
	return _maintenance_agents_nb
