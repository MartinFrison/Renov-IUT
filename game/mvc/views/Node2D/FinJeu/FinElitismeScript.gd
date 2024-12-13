extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_bilan()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# On affiche le bilan de la partie au joueur
func show_bilan() -> void:
	# Sur le nombre de d'étudiant ayant rejoins une école d'ingénieur
	var audio_player = get_node("win")
	audio_player.play()
	
	var node = get_node("Message")
	node.text = "Sous votre mandat, %s étudiants ont pu intégrer une école 
	d'ingénieurs à l'issue de leur formation." % [Student.get_engineering()]
	
	# Sur le nombre de diplomé
	node = get_node("Message2")
	node.text = "D'autre part, %s étudiants ont pu obtenir 
	leur diplôme, soit %s par an.
	" % [Student.get_graduate(), round(Student.get_graduate()/5)]


func _on_QuitterButton_pressed(toggled_on: bool) -> void:
	pass # Replace with function body.
