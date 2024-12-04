class_name Bill
extends Node

# Cette classe enregistre toute les sommes du par l'iut à la fin du trimestre

var pay_teacher : Array[int] = [0,0,0,0,0,0]
var nb_pay_teacher : int
var pay_worker : Array[int] = [0,0,0,0,0,0]
var nb_pay_worker : int
var pay_heating	: Array[int] = [0,0,0,0,0,0]
var previous_bill : int


func reset_bill() -> void:
	pay_teacher = [0,0,0,0,0,0]
	nb_pay_teacher = 0
	pay_worker = [0,0,0,0,0,0]
	nb_pay_worker = 0
	pay_heating = [0,0,0,0,0,0]

# Rajoute à la facture les sommes pour n jours
func add_daily_expense(day : int) -> void:
	var b
	var code
	var sumWorker = 0
	for i in 5:
		code = Utils.dept_index_to_string(i+1)
		b = Building.get_building(code)
		
		sumWorker += b.get_ouvriers()
		pay_teacher[i+1] += (b.get_pay_teacher() * Teacher.compute_nb_per_dept(code))*day/30	
		pay_worker[i+1] += (b.get_ouvriers() * GlobalData.get_pay_worker())*day/30
		
		# Facture de chauffage (cout en fonction de l'isolation)
		if b.is_heating():
			var heat_cost = Building.MonthlySquareMetersHeatingCost * b.get_surface() / 30
			# heat_cost = heat_cost*(1 + b.get_isolation()/25) # Entre 20% et 100% du prix selon l'isolation
			# Ça bogue : soit supprimer l'isolation partout, soit, au contraire, l'implémenter.
			pay_heating[i+1] += heat_cost * day
	
	nb_pay_teacher = max(nb_pay_teacher, Teacher.compute_nb())
	nb_pay_worker = max(nb_pay_worker, sumWorker)


# Fonction appelé a la fin du trimestrepour payer tout les dû
func pay_bill() -> void:
	var code
	var sum = 0
	var bill
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
	var msg = "Récapitulatif de vos factures du mois de " + Utils.get_month_name(m) + " "  + str(GlobalData._year)
	msg += "\nSalaire des enseignants : %s$ (%s enseignants payés)" % [sum_pay(pay_teacher), nb_pay_teacher]
	msg += "\nSalaire des ouvriers : %s$ (%s ouvriers payés)" % [sum_pay(pay_worker), nb_pay_worker]
	msg += "\nFacture de chauffage : %s$" % [sum_pay(pay_heating)]
	var objet = "Facture du mois de " + Utils.get_month_name(m) + " "  + str(GlobalData._year)
	
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
