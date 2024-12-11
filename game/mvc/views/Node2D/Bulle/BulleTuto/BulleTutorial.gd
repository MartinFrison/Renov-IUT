class_name BulleTutorial
extends Node2D

var buble : Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buble = get_node("Panel")


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
	
	
	
