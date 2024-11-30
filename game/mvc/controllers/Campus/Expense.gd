class_name Expense
extends Node


# Dépense de l'argent, provoque la faillite si la dépense est impossible
static func expense_global(amount : int) -> void:
	if GlobalData.getBudget() < amount: 
		bankrupt()
	else:
		GlobalData.addBudget(-amount)

# Si la dépense est par département ce sont les fonds du département qui sont consommé en premier
static func expense_dept(amount : int, dept : String) -> void:
	if Building.get_building(dept).get_budget() + GlobalData.getBudget() < amount:
		bankrupt()
	else:
		if Building.get_building(dept).get_budget() >= amount:
			Building.get_building(dept).add_budget(-amount)
		else:
			amount -= Building.get_building(dept).get_budget()
			Building.get_building(dept).set_budget(0)
			GlobalData.addBudget(-amount)




# Essai de dépenser de l'argent, renvoie false si dépense impossible
static func try_expense_global(amount : int) -> bool:
	if GlobalData.getBudget() < amount: 
		await BulleGestion.send_message("Vous n'avez pas assez de moyens pour cette opération.", false)
		return false
	else:
		GlobalData.addBudget(-amount)
		return true

# Si la dépense est par département ce sont les fonds du département qui sont consommé en premier
static func try_expense_dept(amount : int, dept : String) -> bool:
	if Building.get_building(dept).get_budget() + GlobalData.getBudget() < amount:
		await BulleGestion.send_message("Vous n'avez pas assez de moyens pour cette opération.", false)
		return false
	else:
		if Building.get_building(dept).get_budget() >= amount:
			Building.get_building(dept).add_budget(-amount)
		else:
			amount -= Building.get_building(dept).get_budget()
			Building.get_building(dept).set_budget(0)
			GlobalData.addBudget(-amount)
		return true



# Fonction appeler si on est en faillite 
static func bankrupt() -> void:
	RenovIUTApp.app.open_bankrupt()
