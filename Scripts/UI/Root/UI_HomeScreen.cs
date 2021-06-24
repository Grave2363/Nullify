using Godot;
using System;

public class UI_HomeScreen : Control
{
	public override void _Ready()
	{
		/***   ??UPDATE??  <- SHOULD CHANGE VAR NAME HERE   ***/
		MusicPlayer globals = (MusicPlayer) GetNode("/root/MusicPlayer");
		globals.tempTurnOffSFX();
		globals.onHomeScreen();
		globals.tempTurnOffSFX();
		globals.tempTurnOnSFX();
	}
	
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	// Called when the node enters the scene tree for the first time.

	//public Script change = (Script)ResourceLoader.Load("res://Script/ChangeScenes.cs");
	// SceneLoader loader =  new SceneLoader();
	// string thisScene = "res://Scenes/UI/UI_HomeScreen.tscn";
	// public override void _Ready()
	// {
		
	// }

	// public void OnPlayPressed()
	// {
	//     //GetTree().ChangeScene("res://Scenes/UI/UI_ModeSelect.tscn");


	//     //ChangeScenesAuto.ChangeScene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade");

	//    // var scene = change.GetScript();
		
	//     //scenes.ChangeScene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade");
 

	//     //var changeScenes = (ChangeScenes)GetNode("./ChangeScenes.cs");


	//     //ChangeScenes.ChangeScene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade");  //singleton
	//     //changeScenes.ChangeScene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade"); //local var for GetNode
	//     //change.ChangeScene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade"); //standard class instantiation


	//     // ChangeScemes.change_scene("res://Scenes/UI/UI_ModeSelect.tscn", "Fade");
	//     // ChangeScemes.end_animat();
	//     //ChangeScenes.EndAnimation();
	//     //PackedScene scene = (PackedScene)ResourceLoader.Load("res://Scenes/UI/UI_LevelSelect.tscn");     

	// }

	// public void OnSettingsButtonPressed()
	// {
	//     //set this scene as the prev scene, then switch
	//     //SceneLoader.SetPrevScene(thisScene);
	//     loader.SetPrevScene(thisScene);
	//     GetTree().ChangeScene("res://Scenes/UI/UI_Settings.tscn");   
	// }

	// public void OnQuitPressed()
	// {
	//     GetTree().Quit();
	// }
}

