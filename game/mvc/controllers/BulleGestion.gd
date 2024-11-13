class_name BulleGestion
extends RefCounted


static func ask_question(question : String, reponse : Array[String] ,fonction : String, node : Node) -> void:
	TimeManagement.pause(false)
	
	var scene = load("res://mvc/views/Node2D/Bulle/BulleQuestion/PanelBulleQuestion.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	if bulle.has_method("init"):
		bulle.init(question, reponse, fonction, node)


static func send_message(message : String) -> void:
	TimeManagement.pause(false)
	
	var scene = load("res://mvc/views/Node2D/Bulle/BulleMessage/PanelBulleMessage.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	if bulle.has_method("init"):
		bulle.init(message)
