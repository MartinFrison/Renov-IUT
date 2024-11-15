# Building.gd
class_name Building
extends RefCounted

static var _buildingsDictionary = {}
static var _codeList = []

# Attributs privés
var _age : int
var _doorLocked : bool
var _surface : int
var _heating : bool
var _maintenance_agents_nb : int
var _code : String
var _isolation : int
var _inventory : int
var _ouvriers : int = 0  # Nombre d'ouvriers
var _grevistes : int = 0  # Nombre de grévistes


# Constructeur de la classe
func _init(age: int, isolation: int, surface: int, heating: bool, maintenance_agents_nb: int, code: String, inventory: int) -> void:
	_age = age
	_isolation = clamp(isolation, 0, 100)  # Limite l'isolation entre 0 et 100
	_surface = surface
	_heating = heating
	_maintenance_agents_nb = maintenance_agents_nb
	_code = code
	_inventory = clamp(inventory, 0, 100)  # Limite l'inventaire entre 0 et 100
	_buildingsDictionary[code] = self
	_codeList.append(code)


static func get_building(code: String) -> Building:
	if _buildingsDictionary.has(code):
		return _buildingsDictionary.get(code)
	else:
		return null


# Getters
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

func get_agents_nb() -> int:
	return _maintenance_agents_nb

func get_ouvriers() -> int:
	return _ouvriers

func get_grevistes() -> int:
	return _grevistes


# Méthodes de gestion des ouvriers
func add_ouvrier() -> void:
	_ouvriers += 1

func remove_ouvrier() -> void:
	if _ouvriers > 0:
		_ouvriers -= 1

func convert_ouvriers_to_grevistes(n: int) -> void:
	if n > 0 and _ouvriers >= n:
		_ouvriers -= n
		_grevistes += n

func convert_grevistes_to_ouvriers(n: int) -> void:
	if n > 0 and _grevistes >= n:
		_grevistes -= n
		_ouvriers += n


# Méthodes de gestion des agents
func add_agent() -> void:
	_maintenance_agents_nb += 1

func rm_agent() -> void:
	if _maintenance_agents_nb > 0:
		_maintenance_agents_nb -= 1


# Setters
func setHeat(heat: bool) -> void:
	_heating = heat

func setIsolation(value: int) -> void:
	_isolation = clamp(value, 0, 100)  # Limite la valeur d'isolation entre 0 et 100
	ObserverBuilding.notifyStateChanged()

func setInventory(value: int) -> void:
	_inventory = clamp(value, 0, 100)  # Limite la valeur d'inventaire entre 0 et 100
	ObserverBuilding.notifyStateChanged()


# Méthodes d'ajout
func addIsolation(value: int) -> void:
	_isolation = clamp(_isolation + value, 0, 100)  # Limite la valeur d'isolation entre 0 et 100

func addInventory(value: int) -> void:
	_inventory = clamp(_inventory + value, 0, 100)  # Limite la valeur d'inventaire entre 0 et 100


# Méthode pour vérifier si la porte est verrouillée
func isDoorLocked() -> bool:
	return _doorLocked


# Méthode pour définir l'état de verrouillage de la porte
func setDoorLocked(locked: bool) -> void:
	_doorLocked = locked
