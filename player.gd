extends Area2D 
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var lifes = 2;

var screen_size # Size of the game window.


func is_dead():
	return lifes == 0
	
func is_low_life():
	return lifes == 1

func _on_body_entered(_body):
	lifes -= 1
	
	if is_dead():
		hide() # Player disappears after being hit.
	elif is_low_life():
		# Change color to low life
		$AnimatedSprite2D.modulate = Color(1.0, 0.0, 0.0, 1.0)
		
	hit.emit()
	
	if is_dead():
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	
	# Reset state
	lifes = 2
	$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	show()
	$CollisionShape2D.disabled = false

func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _process(delta):
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()
	
	var velocity = Vector2.ZERO # The player's movement vector.


	velocity = get_local_mouse_position()

	if velocity.length() > 10:
		velocity = velocity.normalized() * speed
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
		if velocity.y != 0:
			$AnimatedSprite2D.flip_v = velocity.y > 0
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
