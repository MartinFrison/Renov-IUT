class_name Budget
extends RefCounted

# Assure la collecte des financements et fait le bilan

# Rassemble toutes les sources de revenu
# Dans cette première version, on part avec beaucoup de financement publics : un coup de boost pour notre IUT !
static func basic_finance() -> void:
	var time = 4 # Les subventions se font au rythme annuel, i.e. 4 trimestres. Les montants arriveront par trimestre,
				 # ce qui est une convention de cette version du jeu ; en vrai, cela peut être plus compliqué. 
	# Pour tous les départements, financement de l'Etat (1), de la région (2) et ceux venant des frais de scolarité (6)
	for i in 5:
		for j in [1,2]: # On estime que les subventions sont bien plus importantes que les frais de scolarité
						# on les traite donc séparément.
						# Pour nous rapprocher des chiffres réels, nous nous sommes renseignés sur le site
						# de l'Education nationale, ainsi que d'autres sources officielles.
						# Dans les versions ultérieures, on pourrait et on devrait affiner !
			Fund.add_fund_by_index(j, i+1, (12250 * Student.compute_nb_per_dept(Global.dept_index_to_string(i+1)))/time, time)
		Fund.add_fund_by_index(6, i+1, (175 * Student.compute_nb_per_dept(Global.dept_index_to_string(i+1)))/time, time)	
	
	# L'Eurométropole (3) subventionne Informatique, Chimie et Génie civil (hypothèse que nous trouvions plausible) :
	for k in [1, 2, 4]:
		Fund.add_fund_by_index(3, k, (250 * Student.compute_nb_per_dept(Global.dept_index_to_string(k)))/time, time)
		
	# Il existe des partenariats (5) avec Informatique, Chimie, Génie civil et Infocom.
	# On utilisera un montant et une durée aléatoires dans une certaine fourchette (raisonnable, il s'agit là de petits partenariats)
	randomize()
	var min_fund = 5000
	var max_fund = 50000
	var amount_rand = randf_range(min_fund, max_fund)
	var min = time # un an
	var max = time * 7 # 7 ans
	var time_rand = randi() % (max - min + 1) + min
	for l in 4:
		Fund.add_fund_by_index(5, l+1, amount_rand/time_rand, time_rand)
	
	# L'université de Strasbourg (4) estime qu'il faut soutenir Infocom et Techniques de commercialisation :
	for m in [4, 5]:
		Fund.add_fund_by_index(4, m, 10000/time, time)
	
	# Enfn, Chimie et Génie civil sous-louent des locaux (7) :
	for n in [1,2]:
		Fund.add_fund_by_index(7, n, 10000 * 3, time) # 10000 par mois
	
# Distribuer l'argent disponible en fonction des besoins
static func distribute_funds() -> void:
	return
	
# Affecter une somme particulière à un départment
static func allocate(amount : float, dept : int) -> void:
	return
	
# Réagir dans une situation d'urgence : manque d'argent à un département
static func react_to_lack_of_money(dept : int) -> void:
	return
	
# Réagir à une situation pécuniaire critique au niveau de l'établissement
static func react_to_global_lack_of_money() -> void:
	return
	
# Se voir réduire une source de revenu publique
static func less_public_money() -> void:
	return
	
# Se voir augmenter une source de revenu publique
static func more_public_money() -> void:
	return

# Se voir couper une source de revenu privée
static func minus_private_source() -> void:
	return
	
# Une source de revenu privée se rajoute
static func plus_private_source() -> void:
	return

# Les finances qui diminuent / augmentent en fonction du nombre d'étudiants
static func finance_adaptation() -> void:
	return
