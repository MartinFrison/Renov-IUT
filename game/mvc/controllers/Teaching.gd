class_name Teaching
extends RefCounted

const teachers_base_nb: Array = [21, 24, 18, 27, 18] # chiffres réels tirés du site officiel de l'IUT Robert Schuman

# Fonction pour embaucher un professeur dans un département spécifique
func hire_teachers(dept: String):
	#vérifie si il y a moins de 30 profs dans le batiment
	if Teacher.compute_nb_per_dept(dept) >= 30:
		print("Deja max de prof dans ce batiment")
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
	print("Licenciement d'un professeur pour le département %s" % dept)



# Fonction pour embaucher des enseignants au départ
func populate():
	var nb_teachers = 0
	for i in range(0,5): # par département
		nb_teachers = teachers_base_nb[i]
		for j in range (0, nb_teachers):
			Teacher.add_teacher(Utils.dept_index_to_string(i), true) # Au départ, on n'embauchera que des profs titulaires
