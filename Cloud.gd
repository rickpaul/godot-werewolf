extends Node2D

var speed = Vector2(30, 0)
var shadow_intensity = 0.1

func _ready():
	# Make sure clouds are in the right layer and blend correctly
	z_index = 1
	generate_cloud_shape()

func _process(delta):
	position += speed * delta
	if position.x > get_viewport_rect().size.x + 300:  # 300 is approximate cloud width
		position.x = -300
		generate_cloud_shape()


func set_wind(wind_vector: Vector2):
	speed = wind_vector

func generate_cloud_shape():
	# Clear previous shape
	for child in get_children():
		child.queue_free()
	
	# Generate a collection of connected rectangles
	var num_rectangles = randi() % 60 + 40  # 4-9 rectangles per cloud
	var center = Vector2(0, 0)
	
	for i in range(num_rectangles):
		var rectangle = ColorRect.new()
		
		# Vary rectangle sizes
		var width = randi() % 10 + 40   # 40-160 pixels
		var height = randi() % 10 + 30    # 30-110 pixels
		rectangle.set_size(Vector2(width, height))
		
		# Position rectangles so they overlap
		var angle = randf() * PI * 2
		var distance = randf() * 100
		var offset = Vector2(
			cos(angle) * distance,
			sin(angle) * distance
		)
		
		# Rotate rectangle
		#var rotation_degrees = randf() * 45 - 22.5
		#rectangle.rotation_degrees = rotation_degrees
		
		# Position relative to center
		rectangle.position = center + offset - rectangle.size / 2
		
		# Semi-transparent black for shadow
		rectangle.color = Color(0, 0, 0, shadow_intensity)
		
		add_child(rectangle)
