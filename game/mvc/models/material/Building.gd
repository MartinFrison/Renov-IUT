class_name Building
extends RefCounted

const coeffTempsRenovation = 0.2
const coeffTempsInsulation = 0.3

static var _buildingsDictionary = {}
static var _total_buildings_under_renovation : int = 0  # Nombre total de bâtiments en travaux


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
var _is_insulation_underway : bool = false  # Indique si des travaux d'isolation sont en cours
var _is_renovation_underway : bool = false  # Indique si des travaux de rénovation sont en cours
var _budget : int 


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
	_grevistes = 0
	_budget = 0
	_ouvriers = 0


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

func get_inventory() -> int:
	return _inventory
	
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

func is_insulation_underway() -> bool:
	return _is_insulation_underway

func is_renovation_underway() -> bool:
	return _is_renovation_underway

static func get_total_buildings_under_renovation() -> int:
	return _total_buildings_under_renovation


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


# Méthodes de travaux
func start_insulation_work() -> void:
	if not _is_insulation_underway:
		_is_insulation_underway = true
		_total_buildings_under_renovation += 1

func stop_insulation_work() -> void:
	if _is_insulation_underway:
		_is_insulation_underway = false
		_total_buildings_under_renovation -= 1

func start_renovation_work() -> void:
	if not _is_renovation_underway:
		_is_renovation_underway = true
		_total_buildings_under_renovation += 1

func stop_renovation_work() -> void:
	if _is_renovation_underway:
		_is_renovation_underway = false
		_total_buildings_under_renovation -= 1


# Incrémentation des valeurs
func increment_inventory(n: int) -> void:
	_inventory = clamp(_inventory + n, 0, 100)

func increment_isolation(n: int) -> void:
	_isolation = clamp(_isolation + n, 0, 100)


# Setters
func setHeat(heat: bool) -> void:
	_heating = heat

func setIsolation(value: int) -> void:
	_isolation = clamp(value, 0, 100)  # Limite la valeur d'isolation entre 0 et 100
	ObserverBuilding.notifyStateChanged()

func setInventory(value: int) -> void:
	_inventory = clamp(value, 0, 100)  # Limite la valeur d'inventaire entre 0 et 100
	ObserverBuilding.notifyStateChanged()


# Méthodes pour définir l'état des travaux
func set_insulation_underway(underway: bool) -> void:
	if underway and not _is_insulation_underway:
		_is_insulation_underway = true
		_total_buildings_under_renovation += 1
	elif not underway and _is_insulation_underway:
		_is_insulation_underway = false
		_total_buildings_under_renovation -= 1

func set_renovation_underway(underway: bool) -> void:
	if underway and not _is_renovation_underway:
		_is_renovation_underway = true
		_total_buildings_under_renovation += 1
	elif not underway and _is_renovation_underway:
		_is_renovation_underway = false
		_total_buildings_under_renovation -= 1

#definir le budget
func set_budget(value : int) -> void:
	_budget = value

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


# Temps estimer pour finir d'isoler le batiment en jour
func estimated_insulation_worktime() -> int:
	return (100-_isolation)/ (_ouvriers * coeffTempsInsulation)


# Temps estimer pour finir de renover le batiment en jour
func estimated_renovation_worktime() -> int:
	return (100-_isolation)/ (_ouvriers * coeffTempsRenovation)



# Méthodes de gestion du budget
func get_budget() -> int:
	return _budget

func add_budget(amount: int) -> void:
	_budget = max(_budget + amount, 0) 
	ObserverGlobalData.notifyBudgetChanged()
