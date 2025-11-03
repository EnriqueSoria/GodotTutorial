extends Node2D

@export var lifetime = 3;  # in seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	var main = area.get_parent()
	if main.has_method("add_life"):
		var life_added = main.add_life()
		if life_added:
			main.reset_life_timer()
			queue_free()
		
