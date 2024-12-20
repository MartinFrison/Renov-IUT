class_name Budget
extends Node

# Cette classe enregistre toute les sommes du par l'iut à la fin du trimestre

var pay_teacher : Array[int] = [0,0,0,0,0,0]
var nb_pay_teacher : int
var pay_worker : Array[int] = [0,0,0,0,0,0]
var nb_pay_worker : int
var pay_heating	: Array[int] = [0,0,0,0,0,0]
var previous_bill : int


# Une fois les facture payer les sommes du sont remise à 0
func reset_bill() -> void:
	pay_teacher = [0,0,0,0,0,0]
	nb_pay_teacher = 0
	pay_worker = [0,0,0,0,0,0]
	nb_pay_worker = 0
	pay_heating = [0,0,0,0,0,0]


# Rajoute à la facture les sommes pour un trimestre
func add_daily_expense() -> void:
	var b
	var code
	var sumWorker = 0
	for i in 5:
		code = Utils.dept_index_to_string(i+1)
		b = Building.get_building(code)
		
		sumWorker += b.get_ouvriers()
		pay_teacher[i+1] += (b.get_pay_teacher() * Teacher.compute_nb_per_dept(code))*3	
		pay_worker[i+1] += (b.get_ouvriers() * GlobalData.get_pay_worker())*3
		
		# Facture de chauffage 
		# cout en fonction de l'état des batiments et de leur taille
		if b.is_heating():
			var heat_cost = Building.MonthlySquareMetersHeatingCost * b.get_surface() * 3
			heat_cost = heat_cost*(1 + b.get_inventory()/50) # Prix multiplier jusqu'a X2 selon
			# l'état du batiment
			pay_heating[i+1] += heat_cost
	
	nb_pay_teacher = max(nb_pay_teacher, Teacher.compute_nb())
	nb_pay_worker = max(nb_pay_worker, sumWorker)


# Fonction appelé a la fin du trimestre pour payer toutes les factures
func pay_bill() -> void:
	var code
	var sum = 0
	var bill
	# Chaque département s'acquite de ce qu'il a dépenser
	# En se relayant si besoin sur le budget du bloc central
	for i in 5:
		code = Utils.dept_index_to_string(i+1)
		bill = pay_teacher[i+1]
		sum += bill
		Expense.expense_dept(bill, code)
		
		bill = pay_worker[i+1]
		sum += bill
		Expense.expense_dept(bill, code)
		
		bill = pay_heating[i+1]
		sum += bill
		Expense.expense_dept(bill, code)
	
	previous_bill = sum
	send_bill_detail()
	reset_bill()


# Envoie une notification avec le détail de la facture trimestrielle
func send_bill_detail() -> void:
	# index du mois précédent
	var m = GlobalData._month
	
	# Construction du détail de la facture
	var msg = "Récapitulatif de vos factures du mois de " + Utils.get_month_name(m) + " "  + str(GlobalData._year)
	msg += "\nSalaire des enseignants : %s$ (%s personnes payées) ; " % [sum_pay(pay_teacher), nb_pay_teacher]
	msg += "salaire du personelle : %s$ (%s personnes payées)" % [sum_pay(pay_worker), nb_pay_worker]
	msg += "\nFacture de chauffage : %s$" % [sum_pay(pay_heating)]
	var objet = "Facture du mois de " + Utils.get_month_name(m) + " "  + str(GlobalData._year)
	
	# Envoie du détail sous forme de notif
	print(objet)
	BulleGestion.send_notif(objet,msg,1 )


# sert juste a faire la somme d'une depense sur tout les dept confonu
func sum_pay(table : Array[int]) -> int:
	var sum = 0
	for i in table.size():
		sum+= table[i]
	return sum

# Renvoie la somme des factures payé le trimestre précédant
func get_previous_bill() -> int:
	return previous_bill






# Envoie des financements pour l'IUT qui dépendent du nombre d'étudiants inscrits
func send_fund():
	# On prépare une notification pour informer le joueur
	var objet = "Encaissement des financements annuels"
	var msg = "Récapitulatif des financements annuels\n\n"
	
	# Une partie pour le bloc central
	# La valeur est aléatoire et dépend de la difficulté
	var budget : int = GlobalData.adjust_budget_initial() * Utils.randfloat_in_square_range(0.8, 1.2) * 0.6
	# Pondération du budget selon le nombre d'étudiant
	var nb_stud = Student.compute_nb()
	budget *= nb_stud / 1000
	GlobalData.addBudget(budget)
	msg += "%s € reçus pour le bloc central\n" % [budget]
	
	# Une petite partie pour chaque bâtiment
	# Définition d'un budget aléatoire qui dépend de la difficulté
	for i in range(1, 6):
		var code = Utils.dept_index_to_string(i)
		var build = Building.get_building(code)
		budget = GlobalData.adjust_budget_initial() * Utils.randfloat_in_square_range(0.6, 1.4) * 0.65
		# Pondération du budget selon le nombre d'étudiant
		nb_stud = Student.compute_nb_per_dept(code)
		budget *= nb_stud / 1000
		build.add_budget(budget)
		msg += "%s € reçus pour le département %s\n" % [budget, code]
	
	msg += "\n\n Veuillez noter que ces financements sont pondérés en fonction du nombre d'étudiants."
	BulleGestion.send_notif(objet, msg, 1)



# Initialiser le budget du bloc central en appliquant un coefficient
static func init_budget() -> void:
	# Initialisation aléatoire selon la difficulté
	var budget : int = GlobalData.adjust_budget_initial() * Utils.randfloat_in_square_range(0.8, 1.2)
	GlobalData.setBudget(budget)


# Initialiser le budget des batiment en appliquant un coefficient
static func init_budget_building(build : Building) -> void:
		# Definition d'un budget aléatoire qui dépend de la difficulté
		var budget : int = GlobalData.adjust_budget_initial()*0.2 * Utils.randfloat_in_square_range(0.6, 1.4)
		build.add_budget(budget)
