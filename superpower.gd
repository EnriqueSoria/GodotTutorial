extends CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	#var main = area.get_parent()
	print("Ha entrat area", area)


func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
	print("Ha entrat body", body) # Replace with function body.
