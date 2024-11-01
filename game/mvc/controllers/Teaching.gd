class_name Teaching
extends RefCounted # ne nécessite pas d'interaction avec le moteur de scène

# Fonction pour embaucher un professeur dans un département spécifique
func hire_teachers(dept: String):
	print("Embauche de professeurs pour le département %s" % dept)


# Fonction pour licencier un professeur dans un département spécifique
func fire_teachers(dept: String):
	print("Licenciement de professeurs pour le département %s" % dept)

# Fonction pour embaucher des enseignants au départ
func populate():
	print("Population initiale des professeur")
