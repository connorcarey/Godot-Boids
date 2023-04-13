extends Area2D

var velocity : Vector2
var acceleration : Vector2

func _ready():
	velocity = Vector2.ZERO
	acceleration = Vector2.ZERO
	$CollisionCircle.shape.radius = GlobalVariables.radius

func _process(delta) -> void:
	# Don't do anything if we're not moving, becasue if we continue with the math we lose our previous velocity data.
	if GlobalVariables.max_speed == 0:
		return
	# Move and point in the direction of the velocity vector.
	wrap_position()
	update_acceleration()
	velocity = velocity + acceleration
	velocity = velocity.limit_length(GlobalVariables.max_speed)
	position = position + velocity
	rotation = velocity.angle()


func wrap_position() -> void:
	# Check that we are still in bounds of the screen, if not then we wrap around.
	# Could possible move this to a helper function? Might if I exceed too many lines.
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	
	if position.x > width :
		position.x = 0
	if position.x < 0 :
		position.x = width
	if position.y > height :
		position.y = 0
	if position.y < 0 :
		position.y = height

func update_acceleration() -> void:
	var separate = Vector2.ZERO
	var cohesion = Vector2.ZERO
	var alignment = Vector2.ZERO
	var total = 0
	
	for boid in get_overlapping_areas():
		# separation
		var sepdiff = position - boid.position
		var dist = position.distance_squared_to(boid.position)
		sepdiff = sepdiff / dist
		separate = separate + sepdiff
		# cohesion
		cohesion = cohesion + boid.position
		# alignment
		alignment = alignment + boid.velocity
		
		total += 1
	
	if total == 0:
		return
	
	var force = Vector2.ZERO
	# Separation vector math
	separate = separate / total
	separate = separate.normalized() * GlobalVariables.max_speed
	force = separate - velocity
	force = force.limit_length(GlobalVariables.max_force)
	force = force * GlobalVariables.separation
	acceleration = acceleration + force
	# Cohesion vector math
	cohesion = cohesion / total
	var target = cohesion - position
	target = target.normalized() * GlobalVariables.max_speed
	force = target - velocity
	force = force.limit_length(GlobalVariables.max_force)
	force = force * GlobalVariables.cohesion
	acceleration = acceleration + force
	# Alignment vector math
	alignment = alignment / total
	alignment = alignment.normalized() * GlobalVariables.max_speed
	force = alignment - velocity
	force = force.limit_length(GlobalVariables.max_force)
	force = force * GlobalVariables.alignment
	acceleration = acceleration + force
