extends Node2D

var width : int
var height : int
var boid_scene

var rng = RandomNumberGenerator.new()

func _ready():
	boid_scene = load("res://Scenes/boid.tscn")
	resize_window()
	
	for i in GlobalVariables.Count : 
		spawn_boid()
	
	$CanvasLayer/Options/VBoxContainer/SliderContainer/AlignmentSlider.set_value_no_signal(GlobalVariables.Alignment)
	$CanvasLayer/Options/VBoxContainer/SliderContainer/CohesionSlider.set_value_no_signal(GlobalVariables.Cohesion)
	$CanvasLayer/Options/VBoxContainer/SliderContainer/SeparationSlider.set_value_no_signal(GlobalVariables.Separation)
	$CanvasLayer/Options/VBoxContainer/SliderContainer/SpeedSlider.set_value_no_signal(GlobalVariables.MaxSpeed)
	$CanvasLayer/Options/VBoxContainer/SliderContainer/CountSlider.set_value_no_signal(GlobalVariables.Count)

func resize_window() -> void:
	width = get_viewport().size.x
	height = get_viewport().size.y
	$Background.size.x = width
	$Background.size.y = height

func spawn_boid() -> void:
	var boid = boid_scene.instantiate()
	$BoidContainer.add_child(boid)
	boid.position = Vector2(rng.randf_range(0, width), rng.randf_range(0, height))
	boid.velocity = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()

func _process(delta):
	if get_viewport().size.x != width || get_viewport().size.y != height :
		resize_window
	
	while $BoidContainer.get_child_count() < GlobalVariables.Count :
		spawn_boid()
	while $BoidContainer.get_child_count() > GlobalVariables.Count :
		$BoidContainer.get_children().pop_back().free()


func _on_alignment_slider_value_changed(value):
	GlobalVariables.Alignment = value


func _on_cohesion_slider_value_changed(value):
	GlobalVariables.Cohesion = value


func _on_separation_slider_value_changed(value):
	GlobalVariables.Separation = value


func _on_speed_slider_value_changed(value):
	GlobalVariables.MaxSpeed = value


func _on_count_slider_value_changed(value):
	GlobalVariables.Count = value
