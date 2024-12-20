class_name Building
extends RefCounted


const fixed_cost_renovation = 1000000 # Cout fixe en € lié à la rénovation d'un batiment
const coeffTempsRenovation = 4 # Valeur d'un trimestre de travail ouvrier sur la renovation
const MonthlySquareMetersHeatingCost = 8 #8$ par metre carré par mois dans le cas ou
# l'état du batiment est déplorable


static var _buildingsDictionary = {}
static var _total_buildings_under_renovation : int = 0  # Nombre total de bâtiments en travaux


# Attributs privés
var _age : int
var _doorLocked : bool
var _surface : int
var _heating : bool
var _code : String
var _inventory : float
var _ouvriers : int = 0  # Nombre d'ouvriers
var _is_renovation_underway : bool = false  # Indique si des travaux de rénovation sont en cours
var _budget : int
var _pay_teacher : int = 0  # Paiement pour les enseignants
var _entry_exam : float = 0 # difficulté de l'exam d'entrée (0 à 0.5)
var _end_exam : float = 0.5 # difficulté de l'exam de fin d'année (0.3 à 0.7)


# Constructeur de la classe
func _init(age: int, surface: int, heating: bool, code: String, inventory: int) -> void:
	_age = age
	_surface = surface
	_heating = heating
	_code = code
	_inventory = clamp(inventory, 0, 100)  # Limite l'inventaire entre 0 et 100
	_buildingsDictionary[code] = self
	
	_budget = 0
	_ouvriers = 0
	_pay_teacher = 0 

static func get_building(code: String) -> Building:
	if _buildingsDictionary.has(code):
		return _buildingsDictionary.get(code)
	else:
		return null




# Getters
func get_code() -> String:
	return _code

func get_pay_teacher() -> int:
	return _pay_teacher

func get_budget() -> int:
	return _budget

func get_age() -> int:
	return _age

func get_inventory() -> float:
	return _inventory
	
func get_surface() -> int:
	return _surface

func is_heating() -> bool:
	return _heating

func get_ouvriers() -> int:
	return _ouvriers

func is_renovation_underway() -> bool:
	return _is_renovation_underway

static func get_total_buildings_under_renovation() -> int:
	return _total_buildings_under_renovation

# Méthode pour vérifier si la porte est verrouillée
func isDoorLocked() -> bool:
	return _doorLocked

func get_exam_entry() -> float:
	return _entry_exam

func get_exam_end() -> float:
	return _end_exam





# Setters
func set_pay_teacher(amount: int) -> void:
	_pay_teacher = max(amount, 0)  # Assure que le paiement est non négatif

func setHeat(heat: bool) -> void:
	_heating = heat

func setInventory(value: float) -> void:
	_inventory = clamp(value, 0, 100)  # Limite la valeur d'inventaire entre 0 et 100
	ObserverBuilding.notifyStateChanged()


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
	ObserverGlobalData.notifyBudgetChanged()

# Méthode pour définir l'état de verrouillage de la porte
func setDoorLocked(locked: bool) -> void:
	_doorLocked = locked

func set_exam_entry(value :float) -> void:
	_entry_exam = value

func set_exam_end(value :float) -> void:
	_end_exam = value




	
	

# Adders
func add_pay_teacher(amount: int) -> void:
	_pay_teacher = max(_pay_teacher + amount, 0)  # Incrémente en s'assurant qu'il reste non négatif

func add_ouvrier() -> void:
	_ouvriers += 1

func remove_ouvrier() -> void:
	if _ouvriers > 0:
		_ouvriers -= 1

func addInventory(value: int) -> void:
	_inventory = clamp(_inventory + value, 0, 100)  # Limite la valeur d'inventaire entre 0 et 100

func add_budget(amount: int) -> void:
	_budget = max(_budget + amount, 0) 
	ObserverGlobalData.notifyBudgetChanged()







# Méthodes de travaux
func start_renovation_work() -> void:
	if not _is_renovation_underway:
		_is_renovation_underway = true
		_total_buildings_under_renovation += 1

func stop_renovation_work() -> void:
	if _is_renovation_underway:
		_is_renovation_underway = false
		_total_buildings_under_renovation -= 1





# Temps estimer pour finir de renover le batiment en jour
func estimated_renovation_worktime() -> int:
	return (100-_inventory)/ (_ouvriers * coeffTempsRenovation)
