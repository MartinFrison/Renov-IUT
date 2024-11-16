class_name BulleGestion
extends Node


static func ask_question(question : String, reponse : Array[String] ,fonction : String, node : Node) -> void:
	var objet = question.substr(0,15)+".."
	Notification.add_notification(question,objet,GlobalData.get_date(), 0 )
	
	var scene = load("res://mvc/views/Node2D/Bulle/BulleQuestion/PanelBulleQuestion.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	if bulle.has_method("init"):
		bulle.init(question, reponse, fonction, node)
	await bulle.tree_exited


static func send_message(message : String, notif : bool) -> void:
	if notif:
		Notification.add_notification(message,message.substr(0,30)+"..",GlobalData.get_date(), 0 )
	
	var scene = load("res://mvc/views/Node2D/Bulle/BulleMessage/PanelBulleMessage.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	if bulle.has_method("init"):
		bulle.init(message)
	await bulle.tree_exited


static func send_notif(objet : String, message : String, type : int) -> void:
	Notification.add_notification(message,objet,GlobalData.get_date(), type )
	
	var scene = load("res://mvc/views/Node2D/Bulle/BulleNotif/PanelBulleNotif.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	if bulle.has_method("init"):
		bulle.init(objet, message, type)
