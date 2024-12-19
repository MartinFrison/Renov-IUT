class_name BuildingAction
extends Node2D

var code : String
var build : Building
var click : AudioStreamPlayer2D
var under_construction : AudioStreamPlayer2D 
var _loaded : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	click = get_node("PanelGlobal/button")
	under_construction = get_node("PanelGlobal/PanelAction/construction_site")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_and_update_buttons()
	update_message_action()



func init(id : int) -> void:
	code = Utils.dept_index_to_string(id)
	build = Building.get_building(code)
	show_data()

func load():
	_loaded = true
	show_data()


# Met à jours l'affichage de toute les texte et donnée du panel d'action
func show_data() -> void:
	if !_loaded:
		return
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
	node.text = "ouvriers (%s)" % [build.get_ouvriers()]
	
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




# Renvoie si la souris se trouve sur un bouton
func is_button_hovered(button : Button) -> bool:
	# Position de la souris dans le viewport
	var mouse_position = get_viewport().get_mouse_position()
	# Rectangle global du bouton (pour encadrer la position de la souris)
	var global_rect = Rect2(button.global_position, button.get_size())
	return global_rect.has_point(mouse_position)


# Affiche des infos sur les actions quand la souris passe sur le bouton correspondant
func update_message_action() -> void:
	if !_loaded:
		return
	var button
	
	# On teste si le bouton pour lancer des travaux est en focus
	button = get_node("PanelGlobal/PanelAction/renove")
	if is_button_hovered(button):
		# Si oui on affiche une bulle d'info
		var msg = "Rénover les bâtiments est essentiel. Mais cela coûte cher et cela fait déménager un département,
		. Les étudiants et le personnel seront mécontents si ce n'est pas fait durant les grandes vacances."
		msg += "En plus du personnel requis, un coût fixe initial de %s est à débourser." % [Building.fixed_cost_renovation]
		show_message_action(msg, button.get_global_position().y)
		return
	
	# On teste si le bouton pour enlever un ouvrier est en focus
	button = get_node("PanelGlobal/PanelAction/GridContainer/sub_worker")
	if is_button_hovered(button):
		# Si oui on affiche le cout d'un ouvrier
		var msg = "En licenciant un personnel, vous gagnez %s €... mais pensez à l'entretien du bâtiment." % [int(GlobalData.get_pay_worker())]
		show_message_action(msg, button.get_global_position().y)
		return
	
	# On teste si le bouton pour ajouter un ouvrier est en focus
	button = get_node("PanelGlobal/PanelAction/GridContainer/add_worker")
	if is_button_hovered(button):
		# Si oui on affiche le cout d'un ouvrier
		var msg = "En embauchant un personnel, vous dépensez %s € de plus par mois.\n" % [int(GlobalData.get_pay_worker())]
		msg += "Ils servent à entretenir le bâtiment et à le rénover au cas où des travaux seraient nécessaires."
		show_message_action(msg, button.get_global_position().y)
		return
	
	# On teste si le bouton pour enlever un prof est en focus
	button = get_node("PanelGlobal/PanelAction/GridContainer/sub_teacher")
	if is_button_hovered(button):
		# Si oui on affiche le cout d'un prof
		var msg = "En faisant partir un enseignant, vous gagnez %s €. Mais comment apprendre sans profs ?" % [int(build.get_pay_teacher())]
		show_message_action(msg, button.get_global_position().y)
		return
		
	# On teste si le bouton pour augmenter le salaire des profs est en focus
	button = get_node("PanelGlobal/PanelAction/GridContainer/add_pay")
	if is_button_hovered(button):
		# Si oui on affiche une bulle d'info
		var msg = "Un enseignant coûte entre 4000 € et 7000 € à l'IUT.\nCe salaire brut peut être modifié par paliers de 500 €."
		show_message_action(msg, button.get_global_position().y)
		return
		
	# On teste si le bouton pour baisser le salaire des profs est en focus
	button = get_node("PanelGlobal/PanelAction/GridContainer/sub_pay")
	if is_button_hovered(button):
		# Si oui on affiche une bulle d'info
		var msg = "Un enseignant coûte entre 4000 € et 7000 € à l'IUT.\nCe salaire brut peut être modifié par paliers de 500 €."
		show_message_action(msg, button.get_global_position().y)
		return
			
	# On teste si le bouton pour ajouter un prof est en focus
	button = get_node("PanelGlobal/PanelAction/GridContainer/add_teacher")
	if is_button_hovered(button):
		# Si oui on affiche le cout d'un prof
		var msg = "En embauchant un enseignant, vous dépensez %s € de plus par mois." % [int(build.get_pay_teacher())]
		show_message_action(msg, button.get_global_position().y)
		return
	
	# On teste si le bouton pour allumer/eteindre le chauffage est en focus
	button = get_node("PanelGlobal/PanelAction/heat")
	if is_button_hovered(button):
		# Si oui on affiche le cout du chauffage
		var msg = "L'énergie est chère ! Allumer le chauffage coûte %s € par mois. " % [build.get_surface() * Building.MonthlySquareMetersHeatingCost]
		msg += "Attention, ce coût peut augmenter encore si le bâtiment est dégradé !"
		show_message_action(msg, button.get_global_position().y)
		return
		
	# On teste si le bouton pour fermer les portes
	button = get_node("PanelGlobal/PanelAction/lock")
	if is_button_hovered(button):
		# Si oui on affiche une bulle d'info
		var msg = "Les portes fermées agacent les étudiants, mais cela permet de minimiser les dégradations !"
		msg += "(Et d'éviter de trop chauffer, en hiver.)"
		show_message_action(msg, button.get_global_position().y)
		return
	
	#Si la souris n'est sur aucun bouton on cache le message
	hide_message_action()



# Montre le message d'information pour un bouton d'action avec un texte en paramètre
# un message qui contient les info nécéssaire ainsi que la hauteur du bouton concerner
func show_message_action(msg : String, posY : int) -> void:
	var node = get_node("message_action") as Label

	# On définie la position du message en fonction de celle du bouton
	var global_position = node.get_global_position()
	# Modifier la composante Y en fonction de posY - 50
	global_position.y = posY - 50
	# Convertir la position globale en position locale par rapport au parent
	node.position = node.get_parent().to_local(global_position)
	node.reset_size()

	# Rendre le node visible et mettre à jour le texte
	node.visible = true
	node.text = msg



# cache le message d'information pour un bouton d'action
func hide_message_action() -> void:
	var node = get_node("message_action") as Label
	node.visible = false
	
# BOUTON D'ACTION

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
