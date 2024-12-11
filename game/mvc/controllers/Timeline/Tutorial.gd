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


# Appelle le tuto correspondant au nouveau trimestre s'il y en a un de prévus
func tuto_next():
	if _tutorial:
		match _trimester:
			1:
				await tuto_trimester1()
			2:
				await tuto_trimester2()
			3:
				await tuto_trimester3()
			4:
				await tuto_trimester4()
			5:
				await tuto_trimester5()
			_:
				return
		_trimester += 1




# Tutoriel de début de jeu
func tuto_trimester1() -> void:
	var msg
	
	# ¨résentation générale du jeu
	msg = "Bienvenu dans Renov'IUT un jeu de gestion dans lequel vous incarnez "
	msg += "le directeur de l'IUT Robert Schuman"
	await BulleGestion.send_message(msg, false)
	msg = "Votre objectif est de prendre des décisions dans le but de maximiser "
	msg += "la satisfaction des étudiants et des enseignants ainsi que la réussite scolaire"
	await BulleGestion.send_message(msg, false)

	# Explication des donnée générale
	_tuto_buble.show_buble(1148,100,3,1)
	msg = "En haut de l'écran sont afficher les données générale de l'IUT"
	await BulleGestion.send_message(msg, false)
	msg = "Cela comprend la satisfaction, le niveau des étudiants, l'attractivité de l'IUT "
	msg += "ainsi que la date"
	await BulleGestion.send_message(msg, false)
	
	# Explication du budget
	_tuto_buble.show_buble(230,100,3,1)
	msg = "Vous y trouverez également le budget de l'IUT"
	await BulleGestion.send_message(msg, false)
	msg = "Celui ci comprend une partie générale pouvant être aloué pour n'importe quel dépense "
	msg += "et une partie aloué pour chaque batiment qui ne peut être utilisés que pour "
	msg += "financer le batiment auquel il appartient "
	await BulleGestion.send_message(msg, false)
	msg = "Le budget total correspond donc à votre budget générale et au budget de tout "
	msg += "les batiments cumulé"
	await BulleGestion.send_message(msg, false)
	
	# Explication des donnée et infos sur les batiments
	_tuto_buble.show_buble(270,140,875,210)
	msg = "A droite de l'écran vous trouverez les mêmes donnée relative à chaque "
	msg += "batiment spécifique"
	await BulleGestion.send_message(msg, false)
	msg = "Vous trouvez en plus des informations en plus tels que l'état du batiment ou "
	msg += "la difficulté des examens"
	await BulleGestion.send_message(msg, false)
	msg = "Vous pouvez accèder aux informations d'un batiment en cliquant dessus dans la "
	msg += "scène 3D"
	await BulleGestion.send_message(msg, false)
	
	# Explication des actions sur les batiments
	_tuto_buble.show_buble(270,300,875,350)
	msg = "Enfin vous pouvez prendre des décisions relative à chaque batiments dans le "
	msg += "menu à droite"
	await BulleGestion.send_message(msg, false)
	
	# Comment passer au trimestre suivant
	_tuto_buble.show_buble(60,60,1080,23)
	msg = "Une fois que vous avez prit les décisions qui vous semble juste vous pouvez "
	msg += "avancer jusqu'au trimestre suivant en cliquant sur le bouton en haut à droite"
	await BulleGestion.send_message(msg, false)
	_tuto_buble.hide()



# Tutoriel après le premier le premier trimestre de service du directeur
func tuto_trimester2() -> void:
	var msg
	
	# Bilan du premier trimestre
	msg = "Le premier trimestre est passé, "
	msg += "vous pouvez désormais consulté l'impact qu'à eu votre gestion "
	msg += "sur l'IUT"
	await BulleGestion.send_message(msg, false)

	# Explication des notification
	_tuto_buble.show_buble(100,100,5,102)
	msg = "Vous pouvez consulter le bilan de vos dépense ce semestre en cliquant sur "
	msg += "l'historique des notifications à droite de l'écran"
	await BulleGestion.send_message(msg, false)
	_tuto_buble.hide()
	
	# Explication de la renovation
	msg = "Par ailleur vous avez sans doute remarqué que certains batiments sont en "
	msg += "mauvais état.."
	await BulleGestion.send_message(msg, false)
	_tuto_buble.show_buble(270,90,875,355)
	msg = "Vous pouvez y remédier en lancant des travaux de rénovations "
	await BulleGestion.send_message(msg, false)
	msg = "Pour cela vous devez simplement embaucher des ouvriers que vous "
	msg += "devrez rémunérer mensuellement "
	await BulleGestion.send_message(msg, false)
	_tuto_buble.hide()

# Tutoriel avant le trimestre des examens
func tuto_trimester3() -> void:
	var msg
	
	# Explication des examens finaux
	msg = "Le printemps est là et les examens de fin d'année auront bientôt lieu"
	await BulleGestion.send_message(msg, false)
	_tuto_buble.show_buble(270,47,875,520)
	msg = "Vous pouvez ajuster la difficulté de ces examens dans le menu d'action de chaque "
	msg += "batiment"
	await BulleGestion.send_message(msg, false)
	msg = "Cela vous permettra de d'exclure les étudiants que vous jugez trop mauvais,"
	msg += "mais attention cela peut aussi avoir des concéquences"
	await BulleGestion.send_message(msg, false)
	_tuto_buble.hide()


# Tutoriel à la fin de la première année de service du directeur
func tuto_trimester4() -> void:
	var msg
	
	msg = "Vous avez atteint la fin de votre première année d'exercice"
	await BulleGestion.send_message(msg, false)
	msg = "Les examens on eu lieu et les examens on eu lieu"
	msg += "l'historique des notifications à droite de l'écran"
	await BulleGestion.send_message(msg, false)


# Tutoriel au début de la deuxième année de service du directeur
func tuto_trimester5() -> void:
	var msg
	
	msg = "Le premier trimestre est passé, "
	msg += "vous pouvez désormais consulté l'impact qu'à eu votre gestion "
	msg += "sur l'IUT"
	await BulleGestion.send_message(msg, false)
