extends Node2D

@onready var current_name_node: Label = $PlayerName
@onready var total_points_node: Label = $PlayerTotalPoints
@onready var current_points_node: Label = $PlayerCurrentPoints

var total_points: int = 0
var current_points: int = 0

func _ready():
	pass 
	

func _process(delta):
	pass

func increase_current_points(points_earned: int):
	current_points += points_earned
	update_node_text(current_points_node, current_points)

func remove_current_points():
	current_points = 0
	update_node_text(current_points_node, current_points)
	
func update_node_text(updated_node: Label, new_text):
	updated_node.set_text(str(new_text))
