class_name Teaching
extends RefCounted # ne nécessite pas d'interaction avec le moteur de scène

# Fonction pour embaucher un professeur dans un département spécifique
func hire_teachers(dept: String):
	#vérifie si il y a moins de 20 profs dans le batiments
	if Teacher.compute_nb_per_dept(dept) >= 20:
		print("Deja max de prof dans ce batiments")
		return
		
	#vérifie si un prof est prêt à être recruté
	if true:
		print("Pas de prof disponible")
	
	Teacher.add_teacher(dept,true)
	print("Embauche d'un professeurs pour le département %s" % dept)



# Fonction pour licencier un professeur dans un département spécifique
func fire_teachers(dept: String):
	#vérifie si il y a moins de 20 profs dans le batiments
	if Teacher.compute_nb_per_dept(dept) <= 0:
		print("Déja plus aucun prof dans le batiment (c'est la merde)")
		return
	
	Teacher.rm_teachers_by_dept(dept,1)
	print("Licenciement d'un professeurs pour le département %s" % dept)



# Fonction pour embaucher des enseignants au départ
func populate():
	print("Population initiale des professeur")
