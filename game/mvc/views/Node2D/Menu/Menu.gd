extends Control

# Fonction appelée lorsque le bouton "Quitter le jeu" est pressé
func _on_QuitterButton_pressed():
	get_tree().quit()  # Ferme le jeu

# Fonction appelée lorsque le bouton "Fermer le menu" est pressé
func _on_FermerMenuButton_pressed():
	hide()  # Cache le menu


func _on_OuvrirPanelButton_pressed() -> void:
	print("Ouvrir les options...")
