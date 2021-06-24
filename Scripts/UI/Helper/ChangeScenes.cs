using Godot;
using System;

public class ChangeScenes : CanvasLayer
{

	public static string scene = "";
	// Called when the node enters the scene tree for the first time.
	 public static AnimationPlayer anim;
	public override void _Ready()
	{
		anim = GetNode<AnimationPlayer>("Control/AnimationPlayer");
	}

	public static void ChangeScene(string _scene, string animName)
	{
		scene = _scene;
		anim.Play(animName);
	}

	public void NewScene()
	{
		GetTree().ChangeScene(scene);
	}

	public void EndAnimation()
	{
		anim.Stop();
	}


//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
