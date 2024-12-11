class_name Tutorial
extends Node


var _tutorial : bool # Défini si le tutoriel est activé ou non
var _tuto_buble : BulleTutorial
var _trimester : int = 1


func _init(tuto : bool) -> void:
	_tutorial = tuto



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene = load("res://mvc/views/Node2D/Bulle/BulleTuto/BulleTutorial.tscn")
	_tuto_buble = scene.instantiate()
	RenovIUTApp.app.add_child(_tuto_buble)
	_tuto_buble.hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func tuto_next():
	if _tutorial:
		match _trimester:
			1:
				tuto_trimester1()
			2:
				tuto_trimester2()
			4:
				tuto_trimester4()
			5:
				tuto_trimester5()
			_:
				return
		_trimester += 1




# Tutoriel de début de jeu
func tuto_trimester1() -> void:
	var msg
	
	msg = "Bienvenu dans Renov'IUT un jeu de gestion dans lequel vous incarnez "
	msg += "le directeur de l'IUT Robert Schuman"
	await BulleGestion.send_message(msg, false)
	
	msg = "Votre objectif est de prendre des décisions dans le but de maximiser "
	msg += "la satisfaction des étudiants et des enseignants ainsi que la réussite scolaire"
	await BulleGestion.send_message(msg, false)

	_tuto_buble.show_buble(250,100,200,200)
	msg = "En haut de l'écran sont afficher"
	msg += "la satisfaction des étudiants et des enseignants ainsi que la réussite scolaire"
	await BulleGestion.send_message(msg, false)
	_tuto_buble.hide()





# Tutoriel après le premier le premier trimestre de service du directeur
func tuto_trimester2() -> void:
	var msg
	
	msg = "Le premier trimestre est passé, "
	msg += "vous pouvez désormais consulté l'impact qu'à eu votre gestion "
	msg += "sur l'IUT"
	await BulleGestion.send_message(msg, false)



# Tutoriel à la fin de la première année de service du directeur
func tuto_trimester4() -> void:
	var msg
	
	msg = "Le premier trimestre est passé, "
	msg += "vous pouvez désormais consulté l'impact qu'à eu votre gestion "
	msg += "sur l'IUT"
	await BulleGestion.send_message(msg, false)


# Tutoriel au début de la deuxième année de service du directeur
func tuto_trimester5() -> void:
	var msg
	
	msg = "Le premier trimestre est passé, "
	msg += "vous pouvez désormais consulté l'impact qu'à eu votre gestion "
	msg += "sur l'IUT"
	await BulleGestion.send_message(msg, false)
