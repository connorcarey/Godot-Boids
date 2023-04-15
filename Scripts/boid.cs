using Godot;
using System;

public partial class boid : Area2D
{

	public Vector2 Velocity;
	public Vector2 Acceleration;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Velocity = new Vector2(0, 0);
		Acceleration = new Vector2(0, 0);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		WrapPosition();
		UpdateAcceleration();
		Velocity += Acceleration;
		Velocity = Velocity.LimitLength(GlobalVariables.MaxSpeed);
		Position += Velocity;
		Rotation = Velocity.Angle();
	}

	private void WrapPosition()
	{
		float Width = GetViewportRect().Size.X;
		float Height = GetViewportRect().Size.Y;
		Vector2 Temp = Position;

		if (Position.X > Width) {
			Temp.X = 0;
		} else if (Position.X < 0) {
			Temp.X = Width;
		}

		if(Position.Y > Height) {
			Temp.Y = 0;
		} else if (Position.Y < 0) {
			Temp.Y = Height;
		}

		Position = Temp;
	}

	public void UpdateAcceleration()
	{
		Vector2 Separate = new Vector2(0, 0);
		Vector2 Cohesion = new Vector2(0, 0);
		Vector2 Alignment = new Vector2(0, 0);
		int Total = 0;

		foreach (Area2D Area in GetOverlappingAreas()) {
			// Separation
			Vector2 SepDiff = Position - Area.Position;
			float dist = Position.DistanceSquaredTo(Area.Position);
			SepDiff /= dist;
			Separate += SepDiff;
			// Cohesion
			Cohesion += Area.Position;
			// Alignment
			Alignment += ((boid)Area).Velocity;
			
			Total++;
		}

		if (Total == 0) {
			return;
		}

		Vector2 Force = new Vector2(0, 0);
		// Separation
		Separate /= Total;
		Separate = Separate.Normalized() * GlobalVariables.MaxSpeed;
		Force = Separate - Velocity;
		Force = Force.LimitLength(GlobalVariables.MaxForce);
		Force *= GlobalVariables.Separation;
		Acceleration += Force;
		// Cohesion
		Cohesion /= Total;
		Vector2 Target = Cohesion - Position;
		Target = Target.Normalized() * GlobalVariables.MaxSpeed;
		Force = Target - Velocity;
		Force = Force.LimitLength(GlobalVariables.MaxForce);
		Force *= GlobalVariables.Cohesion;
		Acceleration += Force;
		// Alignment
		Alignment /= Total;
		Alignment = Alignment.Normalized() * GlobalVariables.MaxSpeed;
		Force = Alignment - Velocity;
		Force = Force.LimitLength(GlobalVariables.MaxForce);
		Force *= GlobalVariables.Alignment;
		Acceleration += Force;
	}
}
