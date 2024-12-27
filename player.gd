extends Area2D

@export var base_speed = 100;
@export var quick_speed = 600;
var screen_size;
var in_shadow = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_physics_process(delta)
	_check_shadow_status()


func _physics_process(delta):
	"""
	desc:
		+   Does the movement of the player
	"""
	# Movement
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("ui_up",true):
		$AnimatedSprite2D.play("walk_up")
		velocity.y -= 1
	if Input.is_action_pressed("ui_down",true):
		$AnimatedSprite2D.play("walk_down")
		velocity.y += 1
	if Input.is_action_pressed("ui_left",true):
		$AnimatedSprite2D.play("walk_left")
		velocity.x -= 1
	if Input.is_action_pressed("ui_right",true):
		$AnimatedSprite2D.play("walk_right")
		velocity.x += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * base_speed
	position += velocity * delta
	position = position.clamp(screen_size*0.05, screen_size*0.95)

func _check_shadow_status():
	"""
	desc:
		+   Checks if the player is in shadow 
	"""
	# Get total shadow value at player position
	var shadow_value = 0.0
	var clouds = get_tree().get_nodes_in_group("Cloud")
	print(len(clouds))
	
	for cloud in clouds:
		# Check if player is within cloud's shadow
		#if cloud.get_global_rect().has_point(global_position):
			#shadow_value += cloud.shadow_intensity
		pass
	
	in_shadow = shadow_value > 0.3  # Threshold for being "in shadow"
	#print(in_shadow)
