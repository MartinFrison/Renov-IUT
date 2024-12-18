extends Node2D

var code : String
var build : Building
var click : AudioStreamPlayer2D
var under_construction : AudioStreamPlayer2D 

var is_message_active: bool # concerne le message pop-up au survol des +/-

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	click = get_node("PanelGlobal/button")
	under_construction = get_node("PanelGlobal/PanelAction/construction_site")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_and_update_buttons()

func init(id : int) -> void:
	code = Utils.dept_index_to_string(id)
	build = Building.get_building(code)
	show_data()


func show_data() -> void:
	is_message_active = false
	var node
	
	node = get_node("PanelGlobal/name")
	node.text = code
	
	var image = get_node("PanelGlobal/icon")
	var texture_path = "res://mvc/views/images/icons/" + code + ".png"
	var texture = load(texture_path)
	if texture:
		image.texture = texture
	else:
		print("Erreur lors du chargement de la texture :", texture_path)
	
	node = get_node("PanelGlobal/PanelAction/GridContainer/end_exam")
	node.text = "examens (difficulté %s/10)" % [int(build.get_exam_end()*10)]
	
	node = get_node("PanelGlobal/PanelAction/GridContainer/exam_entry")
	node.text = "admission (difficulté %s/10)" % [int(build.get_exam_entry()*10)]
	
	node = get_node("PanelGlobal/PanelAction/GridContainer/pay")
	node.text = "salaires (%s €)" % [build.get_pay_teacher()]
	
	node = get_node("PanelGlobal/PanelStat/GridContainer/mood_student")
	node.text = "Satisfaction étudiante : %s%%" % [int(Student.avg_mood_per_dept(code)*100)]
	
	node = get_node("PanelGlobal/PanelStat/GridContainer/mood_teacher")
	node.text = "Satisfaction enseignante : %s%%" % [int(Teacher.avg_mood_per_dept(code)*100)]
	
	node = get_node("PanelGlobal/PanelStat/GridContainer/level")
	node.text = "Niveau étudiant moyen : %s%%" % [int(Student.avg_level_per_dept(code)*100)]
	
	node = get_node("PanelGlobal/PanelStat/GridContainer/nb_student")
	node.text = "Nombre d'étudiants : %s" % [Student.compute_nb_per_dept(code)]
	
	node = get_node("PanelGlobal/PanelAction/GridContainer/teacher")
	node.text = "enseignants (%s)" % [Teacher.compute_nb_per_dept(code)]
	
	node = get_node("PanelGlobal/PanelAction/GridContainer/worker")
	node.text = "administratifs (%s)" % [build.get_ouvriers()]
	
	node = get_node("PanelGlobal/PanelStat/GridContainer/renovation")
	var n = build.get_inventory()
	if n < 25:
		n = "déplorable"
	elif n < 50:
		n = "mauvais"
	elif n < 75:
		n = "bon"
	else:
		n = "très bon"
	
	var w = ""
	if build.is_renovation_underway():
		w = "(en travaux)"
	node.text = "État du bâtiment : %s %s" % [n, w]
	
	node = get_node("PanelGlobal/PanelAction/renove")
	if build.is_renovation_underway():
		node.set_disabled(true)
		under_construction.play()
	else:
		node.set_disabled(false)
		node.text = "faire des travaux"

	node = get_node("PanelGlobal/PanelStat/GridContainer/budget")
	node.text = "Budget : %s €" % [GlobalData.formatBudget(build.get_budget())]

	node = get_node("PanelGlobal/PanelAction/lock")
	if build.isDoorLocked():	
		node.text = "débloquer les portes"
	else:
		node.text = "bloquer les portes"
		
	node = get_node("PanelGlobal/PanelAction/heat")
	if build.is_heating():	
		node.text = "éteindre le chauffage"
	else:
		node.text = "allumer le chauffage"
		
func check_and_update_buttons() -> void:
	if GlobalData.get_season() == 0:
		get_node("PanelGlobal/PanelAction/GridContainer/add_exem_end").set_disabled(false)
		get_node("PanelGlobal/PanelAction/GridContainer/sub_exem_end").set_disabled(false)
		get_node("PanelGlobal/PanelAction/GridContainer/add_exem_entry").set_disabled(false)
		get_node("PanelGlobal/PanelAction/GridContainer/sub_exem_entry").set_disabled(false)
	else:
		get_node("PanelGlobal/PanelAction/GridContainer/add_exem_end").set_disabled(true)
		get_node("PanelGlobal/PanelAction/GridContainer/sub_exem_end").set_disabled(true)
		get_node("PanelGlobal/PanelAction/GridContainer/add_exem_entry").set_disabled(true)
		get_node("PanelGlobal/PanelAction/GridContainer/sub_exem_entry").set_disabled(true)

func _on_hire_teacher_pressed() -> void:
	click.play()
	Teaching.hire_teachers(code, false)
	show_data()


func _on_fire_teacher_pressed() -> void:
	click.play()
	Teaching.fire_teachers(code)
	show_data()


func _on_renove_pressed() -> void:
	click.play()
	BuildingManagement.start_renovation(build)
	show_data()


func _on_lock_pressed() -> void:
	click.play()
	BuildingManagement.lockDoor(code)
	show_data()


func _on_fire_worker_pressed() -> void:
	click.play()
	BuildingManagement.fireWorker(code)
	show_data()


func _on_hire_worker_pressed() -> void:
	click.play()
	BuildingManagement.hireWorker(code)
	show_data()


func _on_heat_pressed() -> void:
	click.play()
	BuildingManagement.switchHeat(code)
	show_data()



func _on_close_pressed() -> void:
	click.play()
	queue_free()


func _on_increase_pay_pressed() -> void:
	click.play()
	Teaching.increase_salary(code)
	show_data()


func _on_add_exem_end_pressed() -> void:
	click.play()
	BuildingManagement.rise_end_exam_difficulty(code)
	show_data()

func _on_sub_exam_end_pressed() -> void:
	click.play()
	BuildingManagement.decrease_end_exam_difficulty(code)
	show_data()

func _on_add_exem_entry_pressed() -> void:
	click.play()
	BuildingManagement.rise_entry_exam_difficulty(code)
	show_data()

func _on_sub_exam_entry_pressed() -> void:
	click.play()
	BuildingManagement.decrease_entry_exam_difficulty(code)
	show_data()


func _on_decrease_pay_pressed() -> void:
	click.play()
	Teaching.decrease_salary(code)
	show_data()


func _on_sub_teacher_mouse_entered() -> void:
	if !is_message_active:
		var msg = "En faisant partir un enseignant, vous gagnez %s €." % [int(build.get_pay_teacher())]
		await BulleGestion.send_message(msg, false)
		is_message_active = true

func _on_sub_worker_mouse_entered() -> void:
	if !is_message_active:
		var msg = "En licenciant un ouvrier, vous gagnez %s €." % [int(GlobalData._pay_worker)]
		await BulleGestion.send_message(msg, false)
		is_message_active = true

func _on_add_teacher_mouse_entered() -> void:
	if !is_message_active:
		var msg = "En embauchant un enseignant, vous dépensez (au moins) %s € de plus par mois." % [int(build.get_pay_teacher())]
		await BulleGestion.send_message(msg, false)
		is_message_active = true

func _on_add_worker_mouse_entered() -> void:
	if !is_message_active:
		var msg = "En embauchant un ouvrier, vous dépensez (au moins) %s € de plus par mois." % [int(GlobalData._pay_worker)]
		await BulleGestion.send_message(msg, false)
		is_message_active = true

func _on_heat_mouse_entered() -> void:
	if !is_message_active:
		var msg = "L'énergie est chère ! Allumer le chauffage coûte 1100 € par mois." #à corriger, je ne retrouve pas le chiffre du jeu
		await BulleGestion.send_message(msg, false)
		is_message_active = true
