extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_result()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_result() -> void:
	var node
	var dept
	
	node = "Resultat"
	node = get_node(node)
	if Vote.election_gagnee():
		node.text = "Vous avez remporté les éléctions ! Félicitations (ou pas)!"
	else:
		node.text = "Vous avez perdu les éléctions. Dommage.."
	
	
	node = "Vote/total_teach"
	node = get_node(node)
	node.text = "%s / %s" % [Vote.popularity_among_teachers(), Vote.nb_voix_teacher()]
	
	node = "Vote/total_stud"
	node = get_node(node)
	node.text = "%s / %s" % [Vote.popularity_among_students(), Vote.nb_voix_student()]
	
	node = "Vote/total"
	node = get_node(node)
	node.text = "%s / %s" % [Vote.popularity_total(), Vote.nb_voix_total()]
	
	for i in 5:
		dept = Utils.dept_index_to_string(i+1)
		node = "Vote/dept%s" % [i+1]
		node = get_node(node)
		node.text = "%s" % [dept]
		
		node = "Vote/teach_dept%s" % [i+1]
		node = get_node(node)
		node.text = "%s / %s" % [Vote.popularity_among_teachers_per_dept(dept), Vote.nb_voix_teacher_per_dept(dept)]
		
		node = "Vote/stud_dept%s" % [i+1]
		node = get_node(node)
		node.text = "%s / %s" % [Vote.popularity_among_students_per_dept(dept), Vote.nb_voix_student_per_dept(dept)]
		
		node = "Vote/total_dept%s" % [i+1]
		node = get_node(node)
		node.text = "%s / %s" % [Vote.popularity_per_dept(dept), Vote.nb_voix_per_dept(dept)]
		
