extends Node2D

var code : String
var build : Building

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init(id : int) -> void:
	code = Utils.dept_index_to_string(id)
	build = Building.get_building(code)
	show_data()


func show_data() -> void:
	var node
	node = get_node("PanelGlobal/name")
	node.text = code
	
	node = get_node("PanelGlobal/PanelStat/end_exam")
	node.text = "Difficulté des examens de fin d'années : %s" % [int(build.get_exam_end()*100)]
	
	node = get_node("PanelGlobal/PanelStat/entry_exam")
	node.text = "Difficulté des examens d'entrées: %s" % [int(build.get_exam_entry()*100)]
	
	node = get_node("PanelGlobal/PanelStat/pay")
	node.text = "Salaire des enseigants : %s$" % [build.get_pay_teacher()]
	
	node = get_node("PanelGlobal/PanelStat/mood_student")
	node.text = "Satisfaction étudiante : %s%%" % [int(Student.avg_mood_per_dept(code)*100)]
	
	node = get_node("PanelGlobal/PanelStat/mood_teacher")
	node.text = "Satisfaction enseignante : %s%%" % [int(Teacher.avg_mood_per_dept(code)*100)]
	
	node = get_node("PanelGlobal/PanelStat/level")
	node.text = "Niveau étudiant moyen : %s%%" % [int(Student.avg_level_per_dept(code)*100)]
	
	node = get_node("PanelGlobal/PanelStat/nb_student")
	node.text = "Nombre d'étudiants : %s" % [Student.compute_nb_per_dept(code)]
	
	node = get_node("PanelGlobal/PanelStat/nb_teacher")
	node.text = "Nombre d'enseignants : %s" % [Teacher.compute_nb_per_dept(code)]
	
	node = get_node("PanelGlobal/PanelStat/nb_worker")
	node.text = "Nombre d'ouvriers : %s" % [build.get_ouvriers()]
	

	
	
	node = get_node("PanelGlobal/PanelStat/renovation")
	var n = build.get_inventory()
	if n < 25:
		n = "Déplorable"
	elif n < 50:
		n = "Mauvais"
	elif n < 75:
		n = "Bon"
	else:
		n = "Très bon"
	
	var w = ""
	if build.is_renovation_underway():
		w = "(en travaux)"
	node.text = "Etat du batiment : %s %s" % [n, w]
	
	node = get_node("PanelGlobal/PanelStat/budget")
	node.text = "Budget : %s$" % [build.get_budget()]

	node = get_node("PanelGlobal/PanelAction/lock")
	if build.isDoorLocked():	
		node.text = "Débloquer les portes"
	else:
		node.text = "Bloquer les portes"
		
	node = get_node("PanelGlobal/PanelAction/heat")
	if build.is_heating():	
		node.text = "Eteindre le chauffage"
	else:
		node.text = "Allumer le chauffage"
	


func _on_hire_teacher_pressed() -> void:
	Teaching.hire_teachers(code)
	show_data()


func _on_fire_teacher_pressed() -> void:
	Teaching.fire_teachers(code)
	show_data()


func _on_renove_pressed() -> void:
	BuildingManagement.start_renovation(build)
	show_data()


func _on_lock_pressed() -> void:
	BuildingManagement.lockDoor(code)
	show_data()


func _on_fire_worker_pressed() -> void:
	BuildingManagement.fireWorker(code)
	show_data()


func _on_hire_worker_pressed() -> void:
	BuildingManagement.hireWorker(code)
	show_data()


func _on_heat_pressed() -> void:
	BuildingManagement.switchHeat(code)
	show_data()



func _on_close_pressed() -> void:
	queue_free()


func _on_increase_pay_pressed() -> void:
	Teaching.increase_salary(code)
	show_data()


func _on_add_exem_end_pressed() -> void:
	BuildingManagement.rise_end_exam_difficulty(code)
	show_data()

func _on_sub_exam_end_pressed() -> void:
	BuildingManagement.decrease_end_exam_difficulty(code)
	show_data()

func _on_add_exem_entry_pressed() -> void:
	BuildingManagement.rise_entry_exam_difficulty(code)
	show_data()

func _on_sub_exam_entry_pressed() -> void:
	BuildingManagement.decrease_entry_exam_difficulty(code)
	show_data()
