# Study.gd
# Gère la masse estudiantine.
class_name Study
extends RefCounted

const students_base_nb: Array = [88, 125, 30, 96, 112] # chiffres réels de 2024, tirés de ParcourSup, par département
const fluct = 0.1 # fluctiation, pour la 1ère année
const exam_base_result = 0.8 # On estime qu'à l'examen, on est sur de récupérer 80% de ses points de niveau courants (+ la chance)

# Inscrit tous les étudiants d'une année donnée	(1, 2 ou 3).
# Dans cette fonction, les départements sont numérotés plutot que d'etre nommés : c'est plus simple, on ne les affiche pas, de toute façon
# À noter que cette fonction n'est utilisée qu'au début du jeu et calcule le nombre des 2e et des 3e année comme un pourcentage,
# sans traiter leur niveau comme ce sera fait au cours du jeu.
func populate_promo(dept : int, year : int) -> void:
	var coeff = 0.0
	
	match year:
		1:
			coeff = randf_range(1-fluct, 1+fluct) # 1ère année : juste la fluctuation à appliquer
		2:
			var coeff_1 = randf_range(1-fluct, 1+fluct) # 2e année : fluctuation et pourcentage entre 45% et 75%
			coeff = randf_range(0.45*coeff_1, 0.75*coeff_1)
		3:
			var coeff_1 = randf_range(1-fluct, 1+fluct) # 3e année : fluctuation et pourcentage entre 75% et 100%
			# On triche un peu, comme si la 3e année dépendait de la 2e année actuelle, et non pas précédente
			var coeff_2 = randf_range(0.45*coeff_1, 0.75*coeff_1)
			coeff = randf_range(0.75*coeff_2, 1.0*coeff_2)
		_:
			return
	
	var nb_students = ceil(students_base_nb[dept-1] * coeff)
	for i in range(0, nb_students):
		Student.add_student(Utils.dept_index_to_string(dept), year)
	
# Inscrit tous les étudiants (ceux qui viennent du bac, mais aussi ceux, moins nombreux, qui sont passés en 2e et en 3e année)
func populate() -> void:
	for i in range(1,6): # le département
		for j in range(1,4): # l'année
			populate_promo(i, j)


# Simule les examens basé uniquement sur la chance (certains scénarios peuvent appliquer des coefficients supplémentaires)
func evaluate() -> void:
	var total = Student.compute_nb()
	var luck = randf_range(0.0, 2.0*(1-exam_base_result)) # la chance peut soit se détourner de l'élève, soit lui permettre d'obtenir jusqu'à 20% (ici) de plus
	var exam: float = randf_range(exam_base_result, exam_base_result + luck)
	var id = Student.get_all_ids()
	for student in id:
		Student.set_level(student, exam)

# Simule un passage à l'année suivante, en promouvant ceux qui restent et en excluant ceux qui n'ont pas le niveau et/ou l'envie
func next_year() -> void:
	evaluate()
	var id = Student.get_all_ids()
	for student in id:
		var mood = Student.get_mood(student)
		var level = Student.get_level(student)
		var year = Student.get_year(student)
		if mood>0.5 and level>0.5 and year<3: # passage en année suivante
			Student.set_year(student, Student.get_year(student)+1)
		else: #exclusion, départ ou obtention du diplome
			Student.rm_student_by_id(student)
