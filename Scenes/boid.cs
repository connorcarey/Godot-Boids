using Godot;
using System;

public partial class boid : Area2D
{

	Vector2 velocity;
	Vector2 acceleration;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		velocity = new Vector2(0, 0);
		acceleration = new Vector2(0, 0);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		wrapPosition();
		updateAcceleration();
		velocity += acceleration;G
		velocity = velocity.clamped((GDScript)Guid.Load("res://Scripts/GlobalVariables.gd").max_speed);
		position += velocity;
		rotation = velocity.angle();
	}

	private void wrapPosition()
	{
		int width = getWidth();
		int height = getHeight();

		if (position.x > width) {
			position.x = 0;
		} else if (position.x < 0) {
			position.x = width;
		}

		if(position.y > height) {
			position.y = 0;
		} else if (position.y < 0) {
			position.y = height;
		}
	}

	public void updateAcceleration()
	{
		Vector2 separate = new Vector2(0, 0);
		Vector2 cohesion = new Vector2(0, 0);
		Vector2 alignment = new Vector2(0, 0);
		int total = 0;

		foreach (Area2D area in getOverlappingAreas()) {
			// Separation
			float sepdiff = position - area.position;
			float dist = position.distanceSquaredTo(area);
			sepdiff /= dist;
			separate += sepDiff;
			// Cohesion
			cohesion += area.position;
			// Alignment
			alignment += area.velocity;
			
			total++;
		}

		if (total == 0) {
			return;
		}

		Vector2 force = new Vector2(0, 0);
		// Separation
		separate /= total;
		separate = separate.normalized() * GlobalVariables.max_speed;
		force = separate - velocity;
		force = force.clamped(GlobalVaribles.max_force);
		force *= GlobalVariables.separation;
		acceleration += force;
		// Cohesion
		cohesion /= total;
		Vector2 target = cohesion - position;
		target = target.normalized() * GlobalVariables.max_speed;
		force = target - velocity;
		force = force.clamped(GlobalVaribles.max_force);
		force *= GlobalVaribles.cohesion;
		acceleration += force;
		// Alignment
		alignment /= total;
		alignment = alignment.normalized() * GlobalVariables.max_speed;
		force = alignment - velocity;
		force = force.clamped(GlobalVaribles.max_force);
		force *= GlobalVariables.alignment;
		acceleration += force;
	}
}
