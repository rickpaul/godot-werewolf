extends CanvasLayer

var cloud_scene = preload("res://cloud.tscn")
var spawn_timer = 0
var spawn_interval = 5
var base_wind_speed = 30.0  # Base speed for clouds
var wind_variation = 20.0   # How much wind speed can vary
var noise = FastNoiseLite.new()
var time = 0.0
var wind_change_speed = 0.5  # How fast the wind changes


func _ready():
	# Make sure this CanvasLayer renders behind game elements
	layer = 1
	# Set up noise
	noise.seed = randi()  # Random seed for variation
	noise.frequency = 0.5  # How smooth the transitions are

func _process(delta):
	### Update Wind Speeds
	time += delta * wind_change_speed
	
	# Calculate current wind vector using noise
	var wind_speed = base_wind_speed + (noise.get_noise_1d(time) * wind_variation)
	var wind_angle = noise.get_noise_1d(time + 100.0) * PI / 4  # Varies by ±45 degrees
	var wind_vector = Vector2(wind_speed, 0).rotated(wind_angle)
	
	# Update all existing clouds
	for cloud in get_children():
		if cloud.has_method("set_wind"):  # Make sure it's a cloud
			cloud.set_wind(wind_vector)
	
	### Spawn New Clouds
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0
		spawn_cloud()

func spawn_cloud():
	var cloud = cloud_scene.instantiate()
	cloud.position = Vector2(
		-300,  # Start off-screen
		randi() % int(get_viewport().get_visible_rect().size.y)
	)
	add_child(cloud)
