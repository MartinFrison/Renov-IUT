class_name BulleGestion
extends Node


static var liste_notif_count : Array = []



# Fonction pour afficher un message en bas de l'écran
# Le joueur doit cliquer avec la souris pour le passer
# Un booléen spécifie si ce message doit être stoqué dans l'historique des notifications
static func send_message(message : String, notif : bool) -> void:
	if notif:
		Notification.add_notification(message,message.substr(0,30)+"..",GlobalData.get_date(), 0 )
	
	#stocker le message dans la file d'attente
	var count
	if liste_notif_count.size() > 0:
		count = liste_notif_count[liste_notif_count.size()-1]+1
	else:
		count = 1
	liste_notif_count.append(count)
	
	# tant que la file est prise on attend
	while liste_notif_count[0] != count:
		await RenovIUTApp.app.get_tree().create_timer(0.5).timeout
	
	# quand la file est libre on affiche le message
	var scene = load("res://mvc/views/Node2D/Bulle/BulleMessage/PanelBulleMessage.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	if bulle.has_method("init"):
		bulle.init(message)
	await bulle.tree_exited
	liste_notif_count.erase(count)


# Fonction pour envoyer une notification au joueur avec:
# Un objet, un message et un type représenté par un int
static func send_notif(objet : String, message : String, type : int) -> void:
	Notification.add_notification(message,objet,GlobalData.get_date(), type )
	
	#stocker la notif dans la file d'attente
	var count
	if liste_notif_count.size() > 0:
		count = liste_notif_count[liste_notif_count.size()-1]+1
	else:
		count = 1
	liste_notif_count.append(count)
	
	# tant que la file est prise on attend
	while liste_notif_count[0] != count:
		await RenovIUTApp.app.get_tree().create_timer(0.5).timeout
	
	
	# quand la file est libre on affiche la notif
	var scene = load("res://mvc/views/Node2D/Bulle/BulleNotif/PanelBulleNotif.tscn")
	var bulle = scene.instantiate()
	RenovIUTApp.app.add_child(bulle)
	if bulle.has_method("init"):
		bulle.init(objet, message, type)
	
	# Une fois la notif passé on l'enlève de la liste pour permettre à la suivante de s'afficher
	await RenovIUTApp.app.get_tree().create_timer(2.8).timeout
	liste_notif_count.erase(count)
