extends Node2D

var width : int
var height : int
var boid_scene

var rng = RandomNumberGenerator.new()

func _ready():
	boid_scene = load("res://Scenes/boid.tscn")
	var boids = []
	width = get_viewport().size.x
	height = get_viewport().size.y
	$Background.size.x = width
	$Background.size.y = height
	
	for i in GlobalVariables.count : 
		spawn_boid()
	
	$CanvasLayer/Options/VBoxContainer/SliderContainer/AlignmentSlider.set_value_no_signal(GlobalVariables.alignment)
	$CanvasLayer/Options/VBoxContainer/SliderContainer/CohesionSlider.set_value_no_signal(GlobalVariables.cohesion)
	$CanvasLayer/Options/VBoxContainer/SliderContainer/SeparationSlider.set_value_no_signal(GlobalVariables.separation)
	$CanvasLayer/Options/VBoxContainer/SliderContainer/SpeedSlider.set_value_no_signal(GlobalVariables.max_speed)
	$CanvasLayer/Options/VBoxContainer/SliderContainer/CountSlider.set_value_no_signal(GlobalVariables.count)

func spawn_boid():
	var boid = boid_scene.instantiate()
	$BoidContainer.add_child(boid)
	boid.position = Vector2(rng.randf_range(0, width), rng.randf_range(0, height))
	boid.velocity = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()

func _process(delta):
	if get_viewport().size.x != width || get_viewport().size.y != height :
		width = get_viewport().size.x
		height = get_viewport().size.y
		$Background.size.x = width
		$Background.size.y = height
	
	while $BoidContainer.get_child_count() < GlobalVariables.count :
		spawn_boid()
	while $BoidContainer.get_child_count() > GlobalVariables.count :
		$BoidContainer.get_children().pop_back().free()


func _on_alignment_slider_value_changed(value):
	GlobalVariables.alignment = value


func _on_cohesion_slider_value_changed(value):
	GlobalVariables.cohesion = value


func _on_separation_slider_value_changed(value):
	GlobalVariables.separation = value


func _on_speed_slider_value_changed(value):
	GlobalVariables.max_speed = value


func _on_count_slider_value_changed(value):
	GlobalVariables.count = value
