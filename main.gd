extends Node

@export var mob_scene: PackedScene
@export var life_scene: PackedScene = preload("res://life.tscn")
var score
var difficulty_levl = 0


func add_life():
	if $Player.lifes >= $Player.max_lifes:
		return false
		
	$Player.lifes += 1
	$HUD.set_lifes($Player.lifes)
	return true
	
func remove_life():
	$Player.lifes -= 1
	$HUD.set_lifes($Player.lifes)
	
func reset_life_timer():
	$LifeTimer.start()

func game_over() -> void:
	$HUD.set_lifes($Player.lifes)
	
	if $Player.is_dead():
		$ScoreTimer.stop()
		$MobTimer.stop()
		$HUD.show_game_over()
		

func new_game():
	score = 0
	difficulty_levl = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.set_lifes($Player.lifes)
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	$LifeTimer.start()


func _on_score_timer_timeout() -> void:
	score += 1
	difficulty_levl = score / 10
	$MobTimer.wait_time = max(1.5 - (difficulty_levl * 0.5), 0.25)
	#print("wait_time", $MobTimer.wait_time)
	$HUD.update_score(score)


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity_multiplier = 1 + (difficulty_levl * 0.25)
	#print("velocity_multiplier", velocity_multiplier)
	var velocity = Vector2(randf_range(150.0*velocity_multiplier, 250.0*velocity_multiplier), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _ready():
	pass 
	
func _process(_delta: float) -> void:
	if $Player.lifes:
		$HUD.set_lifes($Player.lifes)


func _on_life_timer_timeout() -> void:
	var life = life_scene.instantiate()
	
	life.position = Vector2(
		randf_range(0, $Player.screen_size.x),
		randf_range(0, $Player.screen_size.y),
	)
	add_child(life)
