class_name Study
extends RefCounted # ne nécessite pas d'interaction avec le moteur de scène


# Fonction pour peupler les étudiants
func populate():
	print("Population initiale étudiants")

# Fonction pour peupler une promotion donnée (en fonction du département et de l'année)
func populate_promo(dept: String, year: int):
	print("Peuplement de la promotion du département %s, année %d" % [dept, year])


# Fonction pour évaluer la situation actuelle (peut-être des performances, satisfaction, etc.)
func evaluate():
	print("Évaluation des performances actuelles, satisfaction des étudiants et professeurs, etc.")


# Fonction pour passer les étudiants à l'année suivante
func next_year():
	print("Passage à l'année suivante")
