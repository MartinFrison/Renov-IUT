class_name Tutorial
extends Node3D


var _tutorial : bool # Défini si le tutoriel est activé ou non
var _tuto_buble : BulleTutorial
var _trimester : int = 1
var _rotation_speed : float = 90.0

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
	
	# Présentation générale du jeu
	msg = "Bienvenue dans Renov'IUT, un jeu de gestion dans lequel vous incarnez "
	msg += "le directeur de l'IUT Robert Schuman."
	await BulleGestion.send_message(msg, false)
	msg = "Votre objectif est de prendre des décisions ajustées dans le but de maximiser "
	msg += "la satisfaction des étudiants et des enseignants ainsi que la réussite scolaire."
	await BulleGestion.send_message(msg, false)
	
	# Explication des contrôles
	# Effet sonore
	var cam = RenovIUTApp.app.get_node("Vue3D/Camera_root") as CameraRoot
	cam.rotate_tutorial(3.5)
	msg = "Vous pouvez regarder le campus du point d'observation d'origine "
	msg += "ou en faire un peu le tour, en utilisant les touches de direction de votre clavier. "
	await BulleGestion.send_message(msg, false)

	# Explication des donnée générale
	_tuto_buble.show_buble(1148,100,3,1)
	msg = "En haut de l'écran sont affichéees les données générales de l'IUT..."
	await BulleGestion.send_message(msg, false)
	msg = "...dont la satisfaction, le niveau des étudiants, l'attractivité de l'établissement, "
	msg += "ainsi que la date."
	await BulleGestion.send_message(msg, false)
	
	# Explication du budget
	_tuto_buble.show_buble(230,100,3,1)
	msg = "Vous y trouverez également le budget de l'IUT."
	await BulleGestion.send_message(msg, false)
	msg = "Celui-ci comprend une partie générale pouvant être allouée pour toutes dépenses "
	msg += "et une partie allouée par bâtiment, qui ne peut être utilisés que pour "
	msg += "financer le bâtiment dont elle relève. "
	await BulleGestion.send_message(msg, false)
	msg = "Le budget total est donc constitué par votre budget général et le budget de tous "
	msg += "les bâtiments cumulés."
	await BulleGestion.send_message(msg, false)
	
	# Explication des donnée et infos sur les batiments
	_tuto_buble.show_buble(270,140,875,210)
	msg = "A droite de l'écran, vous trouverez les mêmes données relatives à chaque "
	msg += "bâtiment spécifique que vous sélectionnez."
	await BulleGestion.send_message(msg, false)
	msg = "En outre, y sont affichées des informations supplémentaires que l'état du bâtiment ou "
	msg += "la difficulté des examens, ceux d'entrée ou de passage à l'année suivante."
	await BulleGestion.send_message(msg, false)
	msg = "Pour accéder aux informations d'un bâtiment, cliquez simplement sur celui qui vous intéresse."
	await BulleGestion.send_message(msg, false)
	
	# Explication des actions sur les batiments
	_tuto_buble.show_buble(270,300,875,350)
	msg = "Plus important encore, vous pouvez prendre des décisions relatives à chaque bâtiment dans le "
	msg += "menu à droite."
	await BulleGestion.send_message(msg, false)
	
	# Comment passer au trimestre suivant
	_tuto_buble.show_buble(60,60,1080,23)
	msg = "Une fois que vous avez pris les décisions qui vous sembles appropriées, vous pouvez "
	msg += "avancer jusqu'au trimestre suivant en cliquant sur le bouton rond avec une flèche, en haut à droite."
	await BulleGestion.send_message(msg, false)
	_tuto_buble.hide()

# Tutoriel après le premier le premier trimestre de service du directeur
func tuto_trimester2() -> void:
	var msg
	
	# Bilan du premier trimestre
	msg = "Le premier trimestre est passé, "
	msg += "vous pouvez désormais consulter l'impact qu'à eu votre gestion "
	msg += "sur l'IUT. Tadam !"
	await BulleGestion.send_message(msg, false)

	# Explication des notification
	_tuto_buble.show_buble(100,100,5,102)
	msg = "Vous pouvez consulter le bilan de vos dépenses courantes en cliquant sur "
	msg += "le menu des notifications à gauche de l'écran."
	await BulleGestion.send_message(msg, false)
	_tuto_buble.hide()
	
	# Explication de la renovation
	msg = "Vous avez sans doute remarqué, par ailleurs, que certains bâtiments sont en "
	msg += "mauvais état..."
	await BulleGestion.send_message(msg, false)
	_tuto_buble.show_buble(270,90,875,355)
	msg = "Vous pouvez y remédier en lancant des travaux de rénovation."
	await BulleGestion.send_message(msg, false)
	msg = "Pour ce faire, pensez à embaucher des ouvriers / administratifs "
	msg += "que vous devrez rémunérer mensuellement. "
	msg += "(Heureusement d'ailleurs, vous ne voudriez pas "
	msg += "aller sur les échafaudages vous-mêmes, j'imagine !)"
	await BulleGestion.send_message(msg, false)
	_tuto_buble.hide()

# Tutoriel avant le trimestre des examens
func tuto_trimester3() -> void:
	var msg
	
	# Explication des examens finaux
	msg = "Une petite rose pour vous @)--`- Le printemps est là et "
	msg += " les examens de fin d'année auront bientôt lieu."
	await BulleGestion.send_message(msg, false)
	_tuto_buble.show_buble(270,47,875,520)
	msg = "Vous pouvez ajuster la difficulté de ces examens dans le menu d'action de chaque "
	msg += "bâtiment (chaque département a le droit d'en décider indépendamment des autres)."
	await BulleGestion.send_message(msg, false)
	msg = "Cela vous permettra d'exclure les étudiants que vous jugez trop mauvais,"
	msg += "mais attention ! Ceci n'est pas sans conséquences."
	await BulleGestion.send_message(msg, false)
	_tuto_buble.hide()


# Tutoriel à la fin de la première année de service du directeur
func tuto_trimester4() -> void:
	var msg
	
	# Rapport sur les examens finaux
	msg = "Première étape révolu : vous avez atteint la fin de votre première année d'exercice."
	await BulleGestion.send_message(msg, false)
	msg = "Les examens ont bien eu lieu et les étudiants n'ayant pas le niveau ont été renvoyés. "
	msg += "(Espérons qu'ils s'étaient inscrits ailleurs sur Parcoursup.)"
	await BulleGestion.send_message(msg, false)
	msg = "Vous pouvez consulter le rapport du résultat de ces examens dans le menu des notifications."
	await BulleGestion.send_message(msg, false)

	# Explication des examens d'entrée
	msg = "La nouvelle année arrive et les nouveaux venus avec !"
	await BulleGestion.send_message(msg, false)
	_tuto_buble.show_buble(270,47,875,485)
	msg = "Afin d'avoir des nouvelles recrues avec un meilleur niveau scolaire, vous pouvez ajuster"
	msg += "la séléction à l'entrée dans le menu des bâtiments."
	await BulleGestion.send_message(msg, false)
	msg = "À noter, cependant, que cela aura un impact direct sur le nombre d'étudiants admis, "
	msg += "ainsi que sur la réputation de l'établissement."
	await BulleGestion.send_message(msg, false)
	_tuto_buble.hide()



# Tutoriel au début de la deuxième année de service du directeur
func tuto_trimester5() -> void:
	var msg
	
	msg = "Une nouvelle année commence, les newbies sont arrivés, vous pouvez consulter "
	msg += "le rapport des nouvelles inscriptions dans le menu des notifications."
	await BulleGestion.send_message(msg, false)
