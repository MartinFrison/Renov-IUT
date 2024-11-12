class_name Question
extends RefCounted


static func ask_question(question : String, reponse : Array[String] ,fonction : Callable) -> void:
	TimeManagement.pause(false)
	print("bulle1")
	var scene = load("res://mvc/views/Node2D/Bulle/BulleQuestion/PanelBulleQuestion.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	if bulle.has_method("init"):
		bulle.init(question, reponse, fonction)
