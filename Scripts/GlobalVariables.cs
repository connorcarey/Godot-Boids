using Godot;
using System;

public partial class GlobalVariables : Node
{
    public static float Separation { get; set; } = 0.5f;
    public static float Cohesion { get; set; } = 0.5f;
    public static float Alignment { get; set; } = 0.5f;
    public static float MaxSpeed { get; set; } = 3f;
    public static float MaxForce { get; set; } = 0.01f;
    public static float Radius { get; set; } = 200f;
    public static float Count { get; set; } = 100f;
}
