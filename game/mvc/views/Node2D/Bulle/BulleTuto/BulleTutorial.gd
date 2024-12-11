class_name BulleTutorial
extends Node2D

var buble : Panel
var style : StyleBoxFlat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buble = get_node("Panel")
	style = StyleBoxFlat.new()  # Crée un nouveau StyleBoxFlat
	style.bg_color = Color(0, 0, 0, 0)  # Change la couleur de fond
	style.border_color = Color(1, 1, 0)
	set_border_width(10) # Defini la largeur du contour
	buble.add_theme_stylebox_override("panel", style) # Ajoute le style au panel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func hide_buble():
	visible = false


func show_buble(sx:int, sy:int, px:int, py:int):
	visible = true
	buble.size.x = sx
	buble.size.y = sy
	buble.position.x = px
	buble.position.y = py
	special_effect()

	
func set_border_width(width : int):
	style.border_width_bottom = width
	style.border_width_top = width
	style.border_width_left = width
	style.border_width_right = width
	style.corner_radius_bottom_left = width*2
	style.corner_radius_bottom_right = width*2
	style.corner_radius_top_left = width*2
	style.corner_radius_top_right = width*2	



func special_effect():
	var c : Color = Color(1, 1, 0)
	style.border_color = c
	
	# On fait clignoter la couleur de la bulle
	for k in 3:
		for i in 10:
			c.g -= 0.035
			await get_tree().create_timer(0.025).timeout
			style.border_color = c
		for i in 10:
			c.g += 0.035
			await get_tree().create_timer(0.025).timeout
			style.border_color = c
