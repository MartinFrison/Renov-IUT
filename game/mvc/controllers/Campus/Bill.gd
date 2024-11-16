class_name Bill
extends Node

# Cette classe enregistre toute les sommes du par l'iut à la fin du mois

var pay_teacher : Array[int] = [0,0,0,0,0,0]
var nb_pay_teacher : int
var pay_agent : Array[int] = [0,0,0,0,0,0]
var nb_pay_agent : int
var pay_worker : Array[int] = [0,0,0,0,0,0]
var nb_pay_worker : int
var pay_heating	: Array[int] = [0,0,0,0,0,0]



func reset_bill() -> void:
	pay_teacher = [0,0,0,0,0,0]
	nb_pay_teacher = 0
	pay_agent = [0,0,0,0,0,0]
	nb_pay_agent = 0
	pay_worker = [0,0,0,0,0,0]
	nb_pay_worker = 0
	pay_heating = [0,0,0,0,0,0]

# Rajoute à la facture les sommes dû du jour
func add_daily_expense() -> void:
	var b
	var code
	var sumAgent = 0
	var sumWorker = 0
	for i in 5:
		code = Utils.dept_index_to_string(i+1)
		b = Building.get_building(code)
		
		sumAgent += b.get_agents_nb()
		sumWorker += b.get_ouvriers()
		pay_teacher[i+1] += (b.get_pay_teacher() * Teacher.compute_nb_per_dept(code))/30	
		pay_agent[i+1] += (b.get_agents_nb() * GlobalData.get_pay_agent())/30
		pay_worker[i+1] += (b.get_ouvriers() * GlobalData.get_pay_worker())/30
		
		if b.is_heating():
			pay_heating[i+1] += Building.MonthlySquareMetersHeatingCost * b.get_surface() / 30
	
	nb_pay_teacher = max(nb_pay_teacher, Teacher.compute_nb())
	nb_pay_worker = max(nb_pay_worker, sumWorker)
	nb_pay_agent = max(nb_pay_agent, sumAgent)


# Fonction appelé a la fin du mois pour payer tout les dû
func pay_bill() -> void:
	var code
	for i in 5:
		code = Utils.dept_index_to_string(i+1)
		Expense.expense_dept(pay_teacher[i+1], code)
		Expense.expense_dept(pay_agent[i+1], code)
		Expense.expense_dept(pay_worker[i+1], code)
		Expense.expense_dept(pay_heating[i+1], code)
	send_bill_detail()
	reset_bill()


# Envoie une notification avec le détail de la facture mensuel
func send_bill_detail() -> void:
	# index du mois précédent
	var m = GlobalData._month-1
	if m<1:
		m=12
	
	var msg = "Récapitulatif de vos facture du mois de " + Utils.get_month_name(m)
	msg += "\nSalaire des enseignants: %s$ (%s enseignants payés)" % [sum_pay(pay_teacher), nb_pay_teacher]
	msg += "\nSalaire des enseignants: %s$ (%s enseignants payés)" % [sum_pay(pay_worker), nb_pay_worker]
	msg += "\nSalaire des agents d'entretien: %s$ (%s agents d'entretien payés)" % [sum_pay(pay_agent), nb_pay_agent]
	msg += "\nFacture de chauffage: %s$" % [sum_pay(pay_heating), nb_pay_teacher]
	var objet = "Facture du mois de " + Utils.get_month_name(m)
	
	print("Facture du mois de " + Utils.get_month_name(m))
	BulleGestion.send_notif(objet,msg,1 )


# sert juste a faire la somme d'une depense sur tout les dept confonu
func sum_pay(table : Array[int]) -> int:
	var sum = 0
	for i in table.size():
		sum+= table[i]
	return sum
