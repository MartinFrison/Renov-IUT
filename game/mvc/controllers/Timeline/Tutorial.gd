class_name Tutorial
extends Node


var _tutorial : bool # Défini si le tutoriel est activé ou non


func _init(tuto : bool) -> void:
	_tutorial = tuto



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene = load("res://mvc/views/Node2D/Bulle/BulleTuto/BulleTutorial.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func tuto_start() -> void:
	if _tutorial:
		var msg
		
		msg = "Bienvenu dans Renov'IUT un jeu de gestion ou vous incarnez "
		msg += "le directeur de l'IUT Robert Schuman"
		await BulleGestion.send_message(msg, false)
		
