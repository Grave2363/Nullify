using Godot;
using System;

public class SceneLoader : Node
{

    //the idea is to take in the scene, save it and retrive it later on
    //so for buttons, enter the calling scene (scene that will be calling to go to another scene)
    //then save it.
    //for the back button, call the scene from the saved scene that was called from prev 

    public static string prevScene = "";


    //this could work as everything else works being staticized, but GetTree...
    public void ChangeScene(string destScene)
    {
        //change scene, same as before with destScene passed in
        GetTree().ChangeScene(destScene);
        //plus whatever other transitioning feature

    }

    //GetPrevScene will return the last saved prevScene if it's already assigned with the setter first
    public string GetPrevScene()
    {
        return prevScene;
    }

    //call and set everytime you want to set the calling scene to be saved as a prev scene
    public void SetPrevScene(string sourceScene)
    {
        prevScene = sourceScene;
    }
}
