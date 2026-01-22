extends Area2D 
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var lifes: int
var initial_lifes = 2
var max_lifes = 3
@export var screen_size: Vector2 # Size of the game window.
@onready var superpower = get_node("Superpower")


func add_shield():
	$Superpower/Sprite2D.visible = true
	$Superpower/Timer.start()
	
func remove_shield():
	$Superpower/Sprite2D.visible = false
	
func has_shield():
	return $Superpower/Sprite2D.visible

func is_dead():
	return lifes == 0
	
func is_low_life():
	return lifes == 1

func _on_body_entered(body):
	if not has_shield():
		lifes -= 1
	
	# Emit hit (this calls game_over)
	hit.emit()
	
	# Hide mob
	body.hide()
	
	
func start(pos):
	position = pos
	
	# Reset state
	lifes = initial_lifes
	$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)
	remove_shield()
	
	show()
	$CollisionShape2D.disabled = false

func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _process(delta):
	$AnimatedSprite2D.play()
	
	var velocity = get_local_mouse_position()

	if velocity.length() > 10:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if has_shield():
		$Superpower/Sprite2D.position = position
		$Superpower/Sprite2D.rotate(delta)
	
	if is_dead():
		hide() # Player disappears after being hit.
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
	elif lifes == 2:
		# Change color to low life
		$AnimatedSprite2D.modulate = Color(1.0, 0.75, 0.75, 1.0)
	elif lifes == 1:
		# Change color to low life
		$AnimatedSprite2D.modulate = Color(1.0, 0.0, 0.0, 1.0)
	else:
		# Go back to normal color
		$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)

	if velocity.x:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if velocity.y:
		$AnimatedSprite2D.flip_v = velocity.y > 0
	if velocity.y > 20:
		$AnimatedSprite2D.animation = "up"


func _on_timer_timeout() -> void:
	remove_shield()
