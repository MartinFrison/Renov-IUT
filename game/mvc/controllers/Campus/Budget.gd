class_name Budget
extends RefCounted

# Assure la collecte des financements et fait le bilan

# Rassemble toutes les sources de revenu
func _init():
	pass
	
# Distribuer l'argent disponible en fonction des besoins
static func distribute_funds() -> void:
	return
	
# Affecter une somme particulière à un départment
static func allocate(amount : float, dept : int) -> void:
	return
	
# Réagir dans une situation d'urgence : manque d'argent à un département
static func react_to_lack_of_money(dept : int) -> void:
	return
	
# Réagir à une situation pécuniaire critique au niveau de l'établissement
static func react_to_global_lack_of_money() -> void:
	return
	
# Se voir réduire une source de revenu publique
static func less_public_money() -> void:
	return
	
# Se voir augmenter une source de revenu publique
static func more_public_money() -> void:
	return

# Se voir couper une source de revenu privée
static func minus_private_source() -> void:
	return
	
# Une source de revenu privée se rajoute
static func plus_private_source() -> void:
	return

# Les finances qui diminuent / augmentent en fonction du nombre d'étudiants
static func finance_adaptation() -> void:
	return
