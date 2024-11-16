class_name Bill
extends Node

# Cette classe enregistre toute les sommes du par l'iut à la fin du mois

var pay_teacher : Array[int] = [0,0,0,0,0]
var nb_pay_teacher : int
var pay_agent : Array[int] = [0,0,0,0,0]
var nb_pay_agent : int
var pay_worker : Array[int] = [0,0,0,0,0]
var nb_pay_worker : int
var pay_heating : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset_bill() -> void:
	pay_teacher = [0,0,0,0,0]
	nb_pay_teacher

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
			pay_heating += Building.MonthlySquareMetersHeatingCost * b.get_surface() / 30
	
	nb_pay_teacher = max(nb_pay_teacher, Teacher.compute_nb())
	nb_pay_worker = max(nb_pay_worker, sumWorker)
	nb_pay_agent = max(nb_pay_agent, sumAgent)


# Fonction appelé a la fin du mois pour payer tout les dû
func pay_bill() -> void:
	pass
