class_name Budget
extends RefCounted

# Assure la collecte des financements et fait le bilan

static var time = 4 # Les subventions se font au rythme annuel, i.e. 4 trimestres. Les montants arriveront par trimestre,
			 # ce qui est une convention de cette version du jeu ; en vrai, cela peut être plus compliqué. 

# Rassemble toutes les sources de revenu
# Dans cette première version, on part avec beaucoup de financement publics : un coup de boost pour notre IUT !
static func basic_finance() -> void:
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
	
# Redistribuer l'argent disponible en fonction des besoins
static func redistribute_funds(fund_id : int, new_dept : String, amount : float) -> void:
	var money_left = Fund.get_amount(fund_id) - amount
	var old_dept = Fund.get_area(fund_id)
	var source = Fund.get_source(fund_id)
	var time = Fund.get_time(fund_id) # par souci de simplicité dans cette version, la durée ne change pas
	Fund.rm_fund_by_id(fund_id) # supprimer pour éviter la confusion, et surtout pour pouvoir modifier le montant
	Fund.add_fund(source, amount, new_dept, time) 
	Fund.add_fund(source, money_left, old_dept, time) # recopie, mais avec un montant diminué
	
# Affecter une somme particulière à un départment (si elle n'était pas spécifiquement destinée à un départment ou un autre)
static func allocate(fund_id : int, area : String) -> void:
	Fund.set_area(fund_id, area)
	# dans une amélioration, demander au joueur ce qu'il veut en faire ; surcharge de cette fonction
	# sans destination en paramètre
	
# Réagir dans une situation d'urgence : manque d'argent à un département
static func react_to_lack_of_money(dept : int) -> void:
	return
	
# Réagir à une situation pécuniaire critique au niveau de l'établissement
static func react_to_global_lack_of_money() -> void:
	return
	
# Chercher (et trouver !) une source publique
static func find_public_source() -> int:
	randomize()
	var first = 1
	var last_exclusive = 5
	var new_source = randf_range(first, last_exclusive)
	return floor(new_source)

# Chercher (et trouver !) une source privée
static func find_private_source() -> int:
	randomize()
	var new_source = randf_range(5,8)
	if (floor(new_source) == 6):
		return 5
	else:
		return new_source
	
# Déterminer le montant d'une (nouvelle) subvention
static func find_new_amount() -> float:
	randomize()
	var min = 200 # fourchette que rien n'empêche d'ajuster
	var max = 10001
	return randf_range(min, max)
	
# Se voir /couperréduire une source de revenu publique
static func less_public_money() -> void:
	var fund_id = find_public_source()
	Fund.rm_fund_by_id(fund_id)
	# éventullement ajouter un 'setter' à Fund, pour pouvoir modifier le code trop facilement
	
# Ajouter une source de revenu publique, sans allouer à un bâtiment
static func more_public_money() -> void:
	var new_source = find_public_source()
	var amount = find_new_amount()
	Fund.add_fund_unspecified(new_source, amount, time)
	return

# Se voir couper une source de revenu privée
static func minus_private_source() -> void:
	var fund_id = find_private_source()
	Fund.rm_fund_by_id(fund_id)
	
# Une source de revenu privée se rajoute, sans être allouée à un bâtiment précis
static func plus_private_source() -> void:
	var new_source = find_private_source()
	var amount = find_new_amount()
	Fund.add_fund_unspecified(new_source, amount, time)
	return

# Les finances qui diminuent / augmentent en fonction du nombre d'étudiants
static func finance_adaptation() -> void:
	return
