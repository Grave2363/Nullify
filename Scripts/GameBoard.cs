/***   TASKS TO DO:   ***/
/*** 3. Change Buttons to Purple When Pressed   ***/
/*** 4. Fix array in Level Editor when a value is deleted   ***/
/*** 5. Triple Check Level Editor has even margins/padding   ***/
/*** 6. Get Second Version of Level Editor UI Where Message is replaced with E's <- Use New Branch   ***/
/***   END OF TASKS   ***/




/***   NEW VERSION   ***/
using Godot;
using System;
using System.Collections.Generic;


public struct playerStruct
{
	public int player;
	public int player2;
	public Vector2 prevPos;
	public Vector2 currPos;
	public int currNum;
	public int prevNum;
	public int tile1State;
	public int tile2State;
	public int grabbedCollectableNum;
	public string action;
}


public class GameBoard : Node2D
{
////
//
//	100 - LOCKED TILE
//
//	95 - PLATFORM IMMINENT
//
//	90 - PLATFORM TILE
//
//	80 - WALL TILE
//	
//	[Number Desired] - PLAYER TILES <- Number is randomized based on level size
//
//	70 - Star or jewewl <- pick-up item for extra score
//
////
[Signal] 
public delegate void sendIsMoved();

private Stack<playerStruct> undoStack;
private Node scoring ;
private Node leaderMessenger;
private Texture wallTexture =  (Texture)ResourceLoader.Load("res://Assets/Sprites/icon.png");
private Script gameScript = (Script)ResourceLoader.Load("res://Scripts/Game.gd");
private PackedScene tileScene = (PackedScene)ResourceLoader.Load("res://Scenes/Tile.tscn");	
private Node globalNode ;
private Node MusicNode ;
private Node2D swipeScene;
private PackedScene playerScene = (PackedScene)ResourceLoader.Load("res://Scenes/Player.tscn");
private PackedScene collectScene = (PackedScene)ResourceLoader.Load("res://Scenes/Collectable.tscn");
private Vector2 collectableOnePos = new Vector2(0,0); 
private Vector2 collectableTwoPos = new Vector2(0,0); 
private Vector2 collectableThreePos = new Vector2(0,0); 
private bool isCollectOne = false;
private bool isCollectTwo = false;
private bool isCollectThree = false;
private Vector2 currScale = new Vector2(0,0); 
private string boardName = "";

private int playerNum = -1;
private int immenentNum = -1;
private int coreNum = -1;


public int textureSize = 64;
public int xOffset = 25;
public int yOffset = 25;
public int invisibleTileX = 17;
public int invisibleTileY = 19;
public Node2D[] stars;

/***    !!CHANGE!!  <- WE NO LONGER NEED THESE VARIABLES, WE HAVE GLOBALS!!   ***/
//public enum gridSize{FIVE = 0, SIX = 1, EIGHT = 2};
//private gridSize currGridSize;
//public enum diff{EASY = 0, MEDIUM = 1, HARD = 2, CUSTOM = 3};
//private diff currDiff;
private bool did_win = false;

private Node2D gameNode;
private Label boardSizeLabel;

public static int[,] currBoard;
public static Node2D[,] tileState;


public override void _Ready()
{
	stars = new KinematicBody2D[3];
	swipeScene = (Node2D)GetNode<Node2D>("SwipeDetector");
	gameNode = new Node2D();
	globalNode = GetNode("/root/Global");
	MusicNode = GetNode("/root/MusicPlayer");
	gameNode.SetScript(gameScript);
	AddChild(gameNode);
	scoring = (Node)GetNode<Node>("../../../UI/ScorePanel");
	leaderMessenger = (Node)GetNode<Node>("messenger");
//	currGridSize = (gridSize)globalNode.Call("get_grid"); /***   >>NOTE>>  GLOBALS NOW   ***/
//	currDiff = (diff)globalNode.Call("get_diff");
	playerNum = (int)globalNode.Call("get_player_Num");
	immenentNum = (int)globalNode.Call("get_immenent_Num");
	coreNum = (int)globalNode.Call("get_max_val");
	undoStack = new Stack<playerStruct>();
	globalNode.Call("connect_Pause_Play", this);
	boardSizeLabel = (Label)GetNode<Label>("../../../UI/BoardSizeLabel");
	

	//Level Reseting is pressed
	if ((bool)globalNode.Call("get_isLevelReset"))
	{
//		GD.Print("RESET");
		if(!(bool)globalNode.Call("get_is_add_button"))
			globalNode.Call("toggle_is_add_button");
		globalNode.Call("set_is_input_handled",false);
		scoring.Call("set_base_score", globalNode.Call("get_Original_Score"));
		CreateBoard(currBoard);
	}

	//Tutorial Mode
	else if ((bool)globalNode.Call("get_isTutorial"))
	{
		TutorialLevel();
		GD.Print("Tutorial ON");
	}

	//RoadMap Mode
	else if ((bool)globalNode.Call("get_isRoadMap"))
	{
		GD.Print("Roadmap ON");
		StartRoadMapGame();
	}
//
	//Custom Play Mode
	else if ((bool)globalNode.Call("get_isCustom"))
	{
//		currDiff = GameBoard.diff.CUSTOM; /*** !!CHANGE!!!  <-  WE HAVE GLOABLS FOR THIS VAR   ***/
		CreateRandomBoard(playerNum,immenentNum, coreNum, (bool)globalNode.Call("get_isCustom"));
		GD.Print("Custom Play ON");
	}
	else if ((bool)globalNode.Call("get_isLevelEditor"))
	{
		if((int)globalNode.Call("get_grid") == 5)
		{
			scoring.Call("set_base_score", 1000);
			globalNode.Call("set_Original_Score", 1000);
		}
		if((int)globalNode.Call("get_grid") == 6)
		{
			scoring.Call("set_base_score", 3000);
			globalNode.Call("set_Original_Score", 3000);
		}
		if((int)globalNode.Call("get_grid") == 8)
		{
			scoring.Call("set_base_score", 5000);
			globalNode.Call("set_Original_Score", 5000);
		}
		CreateBoard(currBoard);
		GD.Print("Level Editor Play ON");
	}
	//Standard Play
	else 
	{
		GD.Print("Standard Play ON");
		CreateRandomBoard(-1,-1,-1, (bool)globalNode.Call("get_isCustom"));
	}
	//Make another signal from _player_moved to sendIsMoved so Tutorial Panel can receieve it
	Panel tutPanel = GetParent().GetParent().GetParent().GetNode<Panel>("UI/TutorialPanel");
	Connect("sendIsMoved", tutPanel, "on_sendIsMoved");

}

	public void CreateBoard(int[,] suggestedLevel)
	{
		int xMax = 0,yMax = 0;
		GameBoard.currBoard = suggestedLevel;
		switch(globalNode.Call("get_grid"))
		{
			//TODO: from top left of board, make new parameters
			case 5:
				Position = new Vector2(xOffset - 50, yOffset - 75);
				textureSize = 80;
				xMax = yMax = 7;
				currScale = new Vector2(1.6f, 1.6f);
				if(!(bool)globalNode.Call("get_isTutorial"))
					if(!(bool)globalNode.Call("get_isCustom"))
						boardSizeLabel.Text = "5x5     Free Number: 16";
					else
						boardSizeLabel.Text = "5x5     Free Number: " + globalNode.Call("get_max_val");
				break;
			case 6:
				Position = new Vector2(xOffset - 30, yOffset - 55);
				xMax = yMax = 8;
				textureSize = 64;
				currScale = new Vector2(1.3f, 1.3f);
				if(!(bool)globalNode.Call("get_isTutorial"))
					if(!(bool)globalNode.Call("get_isCustom"))
						boardSizeLabel.Text = "6x6     Free Number: 32";
					else
						boardSizeLabel.Text = "6x6     Free Number: " + globalNode.Call("get_max_val");
				break;
			case 8:
				Position = new Vector2(xOffset - 35, yOffset - 60);
				xMax = yMax = 10;
				textureSize = 50;
				currScale = new Vector2(1.0f, 1.0f);
				if(!(bool)globalNode.Call("get_isTutorial"))
					if(!(bool)globalNode.Call("get_isCustom"))
						boardSizeLabel.Text = "8x8     Free Number: 64";
					else
						boardSizeLabel.Text = "8x8     Free Number: " + globalNode.Call("get_max_val");
				break;
			default:
				GD.Print("Error, Invalid GridSize");
				return;
		}

		globalNode.Call("set_textureDistance", textureSize);
		gameNode.Call("setPlayerScale", currScale);
		tileState = new Node2D[xMax,yMax];
		for(int y = 0; y < yMax; y++)
		{
			for(int x = 0; x < xMax; x++)
			{
				if(suggestedLevel[y,x] == 80)
				{
					tileState[y,x] = null;
					KinematicBody2D wall = new KinematicBody2D();
					CollisionShape2D collision = new CollisionShape2D();
					RectangleShape2D rect = new RectangleShape2D();
					rect.Extents = new Vector2(invisibleTileX,invisibleTileY);
					collision.Shape = rect;
					wall.AddChild(collision);
					wall.Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
					gameNode.AddChild(wall);
				}
				else if(suggestedLevel[y,x] == 70)
				{

					// ADDING BACKGROUND PLATFORM
					tileState[y,x] = (Node2D)tileScene.Instance();
					tileState[y,x].Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
					tileState[y,x].Scale = currScale;

					gameNode.AddChild(tileState[y,x]);

					Node2D collectable = (Node2D)collectScene.Instance();
					collectable.Call("set_collect_grid", x, y);
					gameNode.Call("add_to_collect_array", collectable);
					collectable.Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
					collectable.Scale = currScale;
					if(stars[0] == null)
						stars[0] = collectable;
					else if(stars[1] == null)
						stars[1] = collectable;
					else if(stars[2] == null)
						stars[2] = collectable;

					gameNode.AddChild(collectable);

					if(collectableOnePos == new Vector2(0,0))
						collectableOnePos = new Vector2(x,y);
					else if(collectableTwoPos == new Vector2(0,0))
						collectableTwoPos = new Vector2(x,y);
					else if(collectableThreePos == new Vector2(0,0))
						collectableThreePos = new Vector2(x,y);
				}

				else if(suggestedLevel[y,x] == 90)
				{
					tileState[y,x] = (Node2D)tileScene.Instance();
					tileState[y,x].Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
					tileState[y,x].Scale = currScale;

					gameNode.AddChild(tileState[y,x]);
				}

				else if(suggestedLevel[y,x] == 95)
				{
					tileState[y,x] = (Node2D)tileScene.Instance();
					tileState[y,x].Call("set_state_onGen", 1);
					tileState[y,x].Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
					tileState[y,x].Scale = currScale;
					gameNode.AddChild(tileState[y,x]);
				}

				else if(suggestedLevel[y,x] == 100)
				{
					tileState[y,x] = (Node2D)tileScene.Instance();
					tileState[y,x].Call("set_state_onGen", 2);
					tileState[y,x].Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
					tileState[y,x].Scale = currScale;
					gameNode.AddChild(tileState[y,x]);
				}

				else
				{	
					//ADDING BACKGROUND PLATFORM
					tileState[y,x] = (Node2D)tileScene.Instance();
					tileState[y,x].Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
					tileState[y,x].Scale = currScale;

					gameNode.AddChild(tileState[y,x]);

					Node2D playerNode = (Node2D)playerScene.Instance();
					playerNode.SetScript(ResourceLoader.Load("res://Scripts/Player_Script.gd"));
					playerNode.Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
					playerNode.Scale = currScale;
					gameNode.AddChild(playerNode);
					playerNode.Call("set_current_value", suggestedLevel[y,x]);
					swipeScene.Call("connect_node", playerNode);
					playerNode.Call("set_main_game_node", this);
					Vector2 grid_pos = new Vector2(x,y);
					playerNode.Call("set_player_grid_vector", grid_pos);
					gameNode.Call("add_to_player_array", playerNode); // this is for adding the player to the array to be managed
					playerNode.Call("connect_player"); 
				}
			}
		}
	}

	/*** MAKE BOOLEAN TO FORCE NON-RANDOMNESS  ***/
	public void CreateRandomBoard(int numPlayers = -1,
	int numImminent = -1, int coreDiv = -1, bool isCustom = false) //CORE_DIV REFERS TO SUMMATION OF ALL PLAYER TILE NUMBERS
	{
		int gridSize = (int)globalNode.Call("get_grid");
		int diff = (int)globalNode.Call("get_diff");

		if(numPlayers == 0)
			numPlayers = -1;
		if(coreDiv == 0 || isCustom)
			coreDiv = -1;
		int[,] arr;
		int maxNum = 0;
		int currStar = 0;
		int currPlayer = 0;
		int currImminent = 0;
		int freeNum = 0;
		if((int)globalNode.Call("get_max_val") < 3)
			globalNode.Call("set_max_val", 3);

		switch(gridSize)
		{
			case 5:
				maxNum = 7;
				if(isCustom)
					freeNum = (int)globalNode.Call("get_max_val") - 1;
				else
					freeNum = 14;
				break;
			case 6:
				maxNum = 8;
				if(isCustom)
					freeNum = (int)globalNode.Call("get_max_val") - 1;
				else
					freeNum = 30;
				break;
			case 8:
				maxNum = 10;
				if(isCustom)
					freeNum = (int)globalNode.Call("get_max_val") - 1;
				else
					freeNum = 62;
				break;
		}		
		arr = new int[maxNum, maxNum];
		Random rnd = new Random();
		switch(diff)
		{
			case 0:
				if(gridSize == 5)
				{
					scoring.Call("set_base_score", 1000);
					globalNode.Call("set_Original_Score", 1000);
					boardName = "5x5";
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 4) + 3;
					if(coreDiv == -1)
						coreDiv = (rnd.Next() % 20) + 50;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 2);
				}
				else if(gridSize == 6)
				{
					boardName = "6x6";
					scoring.Call("set_base_score", 2000);
					globalNode.Call("set_Original_Score", 2000);
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 8) + 3;
					if(coreDiv == -1)
						coreDiv = (rnd.Next() % 30) + 20;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 5);
				}
				else
				{
					scoring.Call("set_base_score", 3000);
					globalNode.Call("set_Original_Score", 3000);
					boardName = "8x8";
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 10) + 5;
					if(coreDiv == -1)	
						coreDiv = (rnd.Next() % 80) + 20;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 12);
				}
				break;
			case 1:
				if(gridSize == 5)
				{
					scoring.Call("set_base_score", 2000);
					globalNode.Call("set_Original_Score", 2000);
					boardName = "5x5";
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 3) + 8;
					if(coreDiv == -1)
						coreDiv = (rnd.Next() % 40) + 30;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 12);
				}
				else if(gridSize == 6)
				{
					scoring.Call("set_base_score", 3000);
					globalNode.Call("set_Original_Score", 3000);
					boardName = "6x6";
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 14) + 6;
					if(coreDiv == -1)
						coreDiv = (rnd.Next() % 20) + 40;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 25);
				}
				else
				{
					scoring.Call("set_base_score", 4000);
					globalNode.Call("set_Original_Score", 4000);
					boardName = "8x8";
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 10) + 12;
					if(coreDiv == -1)
						coreDiv = (rnd.Next() % 70) + 60;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 20) + 10;
				}
				break;
			case 2:
				if(gridSize == 5)
				{
					scoring.Call("set_base_score", 4000);
					globalNode.Call("set_Original_Score", 4000);
					boardName = "5x5";
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 4) + 10;
					if(coreDiv == -1)
						coreDiv = (rnd.Next() % 40) + 60;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 3) + 12;
				}
				else if(gridSize == 6)
				{
					scoring.Call("set_base_score", 4500);
					globalNode.Call("set_Original_Score", 4500);
					boardName = "6x6";
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 10) + 8;
					if(coreDiv == -1)
						coreDiv = (rnd.Next() % 50) + 60;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 10) + 12;
				}
				else
				{
					scoring.Call("set_base_score", 5000);
					globalNode.Call("set_Original_Score", 5000);
					boardName = "8x8";
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 20) + 20;
					if(coreDiv == -1)
						coreDiv = (rnd.Next() % 30) + 100;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 40) + 10;
				}
				break;
				// for the custom version of the grid
			case 3:
				if(gridSize == 5)
				{
					scoring.Call("set_base_score", 1250);
					globalNode.Call("set_Original_Score", 1250);
					boardName = "custom";
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 4) + 4;
					if(coreDiv == -1)	
						coreDiv = (rnd.Next() % 20) + 40;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 10);
				}
				else if(gridSize == 6)
				{
					scoring.Call("set_base_score", 2250);
					globalNode.Call("set_Original_Score", 2250);
					boardName = "custom";
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 15) + 5;
					if(coreDiv == -1)	
						coreDiv = (rnd.Next() % 30) + 50;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 45);
				}
				else
				{
					scoring.Call("set_base_score", 2750);
					globalNode.Call("set_Original_Score", 2750);
					boardName = "custom";
					if(numPlayers == -1)
						numPlayers = (rnd.Next() % 20) + 20;
					if(coreDiv == -1)	
						coreDiv = (rnd.Next() % 30) + 100;
					if(numImminent == -1)
						numImminent = (rnd.Next() % 25) + 20;
				}
				break;
		}

		for(int y = 0; y < maxNum; ++y)
			{
				for(int x = 0; x < maxNum; ++x)
				{
					if(x == 0 || y == 0 || x == maxNum - 1 || y == maxNum - 1)
						arr[y,x] = 80;
					else
						while(true)
						{
							int tileNum = rnd.Next() % 11;
							if(tileNum == 1 && currPlayer < numPlayers && coreDiv != 0)
							{
								tileNum = (rnd.Next() % freeNum) + 1;
								if(tileNum < coreDiv)
								{
									arr[y,x] = (int)tileNum;
									coreDiv -= tileNum;
								}
								else
								{
									arr[y,x] = (int)coreDiv;
									coreDiv -= coreDiv;
								}
								currPlayer++;
								break;
							}

							else if(tileNum == 2 && currStar != 3)
							{
								arr[y,x] = 70;
								currStar++;
								break;
							}

							else if(tileNum == 10 && numImminent > currImminent)
							{
								arr[y,x] = 95;
								currImminent++;
								break;
							}
							else
							{
								arr[y,x] = 90;
								break;
							}
						}
				}
			}

		while(currStar != 3)
		{
			int x = (rnd.Next() % (maxNum - 2)) + 1;
			int y = (rnd.Next() % (maxNum - 2)) + 1;
			if(arr[y,x] == 90)
			{
				arr[y,x] = 70;
				currStar++;
			}
		}		

		while(currPlayer < numPlayers)
		{
			int x = (rnd.Next() % (maxNum - 2)) + 1;
			int y = (rnd.Next() % (maxNum - 2)) + 1;
			if(arr[y,x] == 90 || arr[y,x] == 95 )
			{
				arr[y,x] = (rnd.Next() % freeNum) + 1;
				currPlayer++;
			}
		}

		while(currImminent < numImminent)
		{
			int x = (rnd.Next() % (maxNum - 2)) + 1;
			int y = (rnd.Next() % (maxNum - 2)) + 1;
			if(arr[y,x] == 90)
			{
				arr[y,x] = 95;
			}
			currImminent++;
		}

		switch(maxNum)
		{
			case 7:
				CreateBoard(arr);
				break;
			case 8:
				CreateBoard(arr);
				break;
			case 10:
				CreateBoard(arr);
				break;
		}
	}

	public void TutorialLevel()
	{
		globalNode.Call("set_grid",2);
		int[,] arr = new int[10,10]
		{
			{80, 80, 80, 80, 80, 80, 80, 80, 80, 80},
			{80, 14, 95,  1, 95, 95, 95, 95, 95, 80},
			{80,100,100,100, 95,100,100,100, 95, 80},
			{80, 95, 70,100, 95, 90, 95, 95, 95, 80},
			{80, 70,100,100,100, 95,100,100,100, 80},
			{80, 90, 90,100,100,100,100,100, 32, 80},
			{80,100, 90, 90, 90,100, 95, 95,  2, 80},
			{80,100, 95,100, 90, 90, 90,100,100, 80},
			{80,  8,100,100, 70,100, 90,100, 13, 80},
			{80, 80, 80, 80, 80, 80, 80, 80, 80, 80}
		};
		CreateBoard(arr);
	}


	public void StartRoadMapGame()
	{
		switch(globalNode.Call("get_roadMapLevel"))
		{
			case 1:
				scoring.Call("set_base_score", 2000);
				globalNode.Call("set_Original_Score", 2000);
				boardName = "01";
				RoadMapLevelOne();
				break;
			case 2:
				scoring.Call("set_base_score", 3000);
				globalNode.Call("set_Original_Score", 3000);
				boardName = "02";
				RoadMapLevelTwo();
				break;
			case 3:
				scoring.Call("set_base_score", 4000);
				globalNode.Call("set_Original_Score", 4000);
				boardName = "03";
				RoadMapLevelThree();
				break;
			case 4:
				scoring.Call("set_base_score", 4500);
				globalNode.Call("set_Original_Score", 4500);
				boardName = "04";
				RoadMapLevelFour();
				break;
			case 5:
				scoring.Call("set_base_score", 5000);
				globalNode.Call("set_Original_Score", 5000);
				boardName = "05";
				RoadMapLevelFive();
				break;
			case 6:
				scoring.Call("set_base_score", 5500);
				globalNode.Call("set_Original_Score", 5500);
				boardName = "06";
				RoadMapLevelSix();
				break;
			case 7:
				scoring.Call("set_base_score", 6000);
				globalNode.Call("set_Original_Score", 6000);
				boardName = "07";
				RoadMapLevelSeven();
				break;
			case 8:
				scoring.Call("set_base_score", 6500);
				globalNode.Call("set_Original_Score", 6500);
				boardName = "08";
				RoadMapLevelEight();
				break;
			case 9:
				scoring.Call("set_base_score", 7500);
				globalNode.Call("set_Original_Score", 7500);
				boardName = "09";
				RoadMapLevelNine();
				break;
			case 10:
				scoring.Call("set_base_score", 10000);
				globalNode.Call("set_Original_Score", 10000);
				boardName = "Final Level";
				RoadMapLevelTen();
				break;
			default:
				GD.Print("ERROR ON GET ROAD MAP NUMBER");
				break;
		}
	}


	public void RoadMapLevelOne()
	{
		globalNode.Call("set_grid",2);
		globalNode.Call("set_max_val",64);
		int[,] arr = new int[10,10]
			{
				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80},
				{80, 70, 95, 95, 95, 95, 95, 90, 70, 80},
				{80,100, 95,100,100,100, 95,100,100, 80},
				{80,100, 95,100, 35, 90, 95, 90, 90, 80},
				{80,100, 95,100, 90, 90, 95, 90, 90, 80},
				{80,100, 95,100,100, 90, 95, 90, 90, 80},
				{80, 95, 95, 95,100, 90, 95, 90, 90, 80},
				{80, 95, 15, 95,100, 95, 95, 90, 90, 80},
				{80, 95, 70, 95,100, 95, 95, 95, 10, 80},
				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80}
			};
		CreateBoard(arr);

	}

	public void RoadMapLevelTwo()
	{
		globalNode.Call("set_grid",1);
		globalNode.Call("set_max_val",32);
		int[,] arr = new int[8,8]
			{
				{80, 80, 80, 80, 80, 80, 80, 80},
				{80, 20,100, 90, 70,100, 70, 80},
				{80, 10,100, 90, 90,100, 95, 80},
				{80, 90,100, 90, 90,100, 95, 80},
				{80, 90, 95, 90, 90, 95, 95, 80},
				{80, 90,100,100,100,100, 95, 80},
				{80, 90, 90, 95, 70, 95, 90, 80},
				{80, 80, 80, 80, 80, 80, 80, 80}
			};
		CreateBoard(arr);

	}

	public void RoadMapLevelThree()
	{
		globalNode.Call("set_grid",0);
		globalNode.Call("set_max_val",16);
		int[,] arr = new int[7,7]
			{
				{80, 80, 80, 80, 80, 80, 80},
				{80, 10, 90,  1, 90,  1, 80},
				{80,100,100,100, 70, 90, 80},
				{80,  1, 90, 70,100,  1, 80},
				{80, 90,100,100, 70, 90, 80},
				{80,  1, 90,  1, 90,  1, 80},
				{80, 80, 80, 80, 80, 80, 80}
			};
		CreateBoard(arr);

	}

	public void RoadMapLevelFour()
	{
		globalNode.Call("set_grid",0);
		globalNode.Call("set_max_val",16);
		int[,] arr = new int[7,7]
			{
				{80, 80, 80, 80, 80, 80, 80},
				{80, 70,100, 90,  2, 90, 80},
				{80,100,100, 90, 90, 90, 80},
				{80, 70, 90, 70, 90, 90, 80},
				{80, 15, 90, 90, 90, 90, 80},
				{80, 14, 90, 90, 90, 90, 80},
				{80, 80, 80, 80, 80, 80, 80}
			};
		CreateBoard(arr);

	}

	public void RoadMapLevelFive()
	{
		globalNode.Call("set_grid",1);
		globalNode.Call("set_max_val",32);
		int[,] arr = new int[8,8]
			{
				{80, 80, 80, 80, 80, 80, 80, 80},
				{80,  2, 90,  2, 90,100, 70, 80},
				{80, 90,  2, 90,  2,100, 90, 80},
				{80,  2, 90,  2,100,100, 90, 80},
				{80, 70,  2, 90, 90, 90, 90, 80},
				{80,  2, 90,  2,100,100, 90, 80},
				{80, 90,  2, 90,  2,100, 70, 80},
				{80, 80, 80, 80, 80, 80, 80, 80}
			};
		CreateBoard(arr);

	}

	public void RoadMapLevelSix()
	{
		globalNode.Call("set_grid",2);
		globalNode.Call("set_max_val",64);
		int[,] arr = new int[10,10]
			{
				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80},
				{80, 70, 70, 70, 95, 95, 95, 95, 95, 80},
				{80,100,100,100,100,100, 95, 95, 95, 80},
				{80, 95, 95, 95, 95,100, 95, 95, 95, 80},
				{80, 95,  1,100, 95,100, 95, 95, 95, 80},
				{80, 95, 95,100, 20,100, 95, 95, 95, 80},
				{80,  1,  2,100,100,100, 95, 95, 95, 80},
				{80, 95, 95, 95,  1, 95,  2,  2,  2, 80},
				{80, 95,  1, 95,  1, 95,  5,  3, 95, 80},
				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80}
			};
		CreateBoard(arr);

	}

	public void RoadMapLevelSeven()
	{
		globalNode.Call("set_grid",0);
		globalNode.Call("set_max_val",16);
		int[,] arr = new int[7,7]
			{
				{80, 80, 80, 80, 80, 80, 80},
				{80, 90,  7,100, 90, 70, 80},
				{80, 90, 90,100, 70, 90, 80},
				{80, 90, 90,100, 90, 90, 80},
				{80, 90, 90, 90, 90, 90, 80},
				{80, 70, 90,100,  4, 90, 80},
				{80, 80, 80, 80, 80, 80, 80}
			};
		CreateBoard(arr);

	}

	public void RoadMapLevelEight()
	{
		globalNode.Call("set_grid",1);
		globalNode.Call("set_max_val",32);
		int[,] arr = new int[8,8]
			{
				{80, 80, 80, 80, 80, 80, 80, 80},
				{80,100, 95, 14, 12, 90, 90, 80},
				{80, 95, 90,100,100, 90,100, 80},
				{80, 90, 95,100, 90, 90, 90, 80},
				{80, 90, 95,100, 90,100, 90, 80},
				{80, 70, 90,100, 90,100, 90, 80},
				{80,100,100,100, 70,100, 70, 80},
				{80, 80, 80, 80, 80, 80, 80, 80}
			};
		CreateBoard(arr);

	}

	public void RoadMapLevelNine()
	{
		globalNode.Call("set_grid",2);
		globalNode.Call("set_max_val",64);
		int[,] arr = new int[10,10]
			{
				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80},
				{80, 90, 90, 90,100, 90, 90, 90, 70, 80},
				{80, 90, 90, 90,100, 90,100,100,100, 80},
				{80, 90, 90, 90,100, 90,100, 90, 90, 80},
				{80,100,100,100,100, 90,100,100,100, 80},
				{80, 90, 90, 90, 90, 50, 90, 90, 90, 80},
				{80, 90,100,100,100, 90,100,100, 90, 80},
				{80, 90,100, 90, 90, 90, 90,100, 90, 80},
				{80, 70,100, 90, 90, 90, 90,100, 70, 80},
				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80}
			};
		CreateBoard(arr);
	}

	public void RoadMapLevelTen()
	{
		globalNode.Call("set_grid",2);
		globalNode.Call("set_max_val",64);
		int[,] arr = new int[10,10]
			{
				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80},
				{80, 70,100, 90, 90,  5, 90, 90, 90, 80},
				{80,100,100,  2, 90,  5, 90, 90, 90, 80},
				{80,  2,  2,  2, 90,  5, 90,100,100, 80},
				{80, 64, 64,  2, 90,  5, 90, 95, 70, 80},
				{80, 64, 64,  2, 90,  5, 90,100,100, 80},
				{80,  2,  2,  2, 90,  5, 90, 90, 90, 80},
				{80,100,100,  2, 90,  5, 90, 90, 90, 80},
				{80, 70,100, 90, 90,  5, 90, 90, 90, 80},
				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80}
			};
		CreateBoard(arr);

	}


	public bool IsSpaceAvailable(int x, int y) 
	{ 
		if (tileState[y,x] != null)
		return (currBoard[y,x] != 70 && currBoard[y,x] != 80) && !(bool)tileState[y,x].Call("is_tile_locked"); 
		return false;
	}
	public bool IsTileLocked(int x, int y) 
		{
			if (tileState[y,x] != null)
			return  (bool)tileState[y,x].Call("is_tile_locked"); 
			else 
			return false;
		}
	public bool IsTileImm(int x, int y) {return  (bool)tileState[y,x].Call("is_tile_imm"); }
	public void SetTileState(int x, int y, int state) { tileState[y,x].Call("set_state", state); }
	public void SetTileAfterMerge(int x, int y) { tileState[y,x].Call("setTileAfterMerge"); }
	public void DisableTile(int x, int y) {tileState[y,x].Call("turn_off_area_exit"); }
	public void EnableTile(int x, int y) { tileState[y,x].Call("turn_on_area_exit"); }
	public void EnableTileForUndoStack(int x, int y) { tileState[y,x].Call("turn_on_area_exit_for_stack"); }
	public bool IsTileExist(int x, int y) 
	{
		try
		{
			bool result = tileState[y,x] != null; 
			return result;
		}
		catch(Exception e)
		{
			return false;
		}
	}
	public bool IsTileAStar(int x, int y) { return currBoard[y,x] == 70; }
	public void UnlockLocked(int x, int y) { tileState[y,x].Call("unlock"); }
	public void UnlockLocked(int x, int y, bool isStuck) { tileState[y,x].Call("set_state", 1); }
	public float GetScore() {return GetNode<Label>("Label").Text.ToFloat();}
//	public diff GetLevelDifficulty() { return currDiff; }  /***   !!CHANGE!!  <- USE THE GLOBAL FUNCTONS, SAME RESULTS   ***/
//	public gridSize GetLevelGridSize() { return currGridSize; } 



/***  >>NOTE>>  UNDO IS NOT SOLVED ^^STOPPED HERE^^   ***/
/***  >>NOTE>>  TUTORIAL IS NOT SOLVED ^^STOPPED HERE^^   ***/
/***  >>NOTE>>  AND THEN GAME IS FINISHED!!!!   ***/
	public void addToUndoStack(int currPlayer, int Player2, Vector2 prevPos, Vector2 currPos, int prevNum, int currNum, string _action)
	{
		int isCollectable = 0;
		if(currPos == collectableOnePos && !isCollectOne)
		{
			GD.Print("COLLECT ONE");
			isCollectOne = true;
			isCollectable = 1;
		}
		else if(currPos == collectableTwoPos && !isCollectTwo)
		{
			GD.Print("COLLECT TWO");
			isCollectTwo = true;
			isCollectable = 2;
		}
		else if(currPos == collectableThreePos && !isCollectThree)
		{
			GD.Print("COLLECT THREE");
			isCollectThree = true;
			isCollectable = 3;
		}
//		GD.Print("\n");
//		GD.Print("currPlayer -> ",currPlayer);
//		GD.Print("Player2 -> ", (int)Player2);
//		GD.Print("prevPos -> ",(Vector2)prevPos);
//		GD.Print("currPos -> ", (Vector2)currPos);
//		GD.Print("prevNum -> ", (int)prevNum);
//		GD.Print("currNum -> ", (int)currNum);
//		GD.Print("grabbed collectable -> ", (bool)isCollectable);
//		GD.Print("action -> ", _action);
//		GD.Print("---PLAYERS---");
//		GD.Print("---END OF PLAYERS---");
//		gameNode.Call("printPlayers");

		playerStruct p = new playerStruct()
		{
			player = currPlayer,
			player2 = (int)Player2,
			prevPos = (Vector2)prevPos,
			currPos = (Vector2)currPos,
			prevNum = (int)prevNum,
			currNum = (int)currNum,
			grabbedCollectableNum = isCollectable,
			action = _action
		};
		int tempPrevY = (int)prevPos.y;
		int tempPrevX = (int)prevPos.x;
		int tempCurrX = (int)currPos.x;
		int tempCurrY = (int)currPos.y;
		if(tileState[tempPrevY,tempPrevX] != null)
			p.tile1State = (int)tileState[tempPrevY,tempPrevX].Call("get_state");
		else
			p.tile1State = 0;
			
		if(_action == "DELETE")
			p.tile2State = 2;
		else if(tileState[tempCurrY,tempCurrX] != null)
			p.tile2State = (int)tileState[tempCurrY,tempCurrX].Call("get_state");
		else
			p.tile2State = 0;
		
//		GD.Print("tile1State -> ", (int)p.tile1State);
//		GD.Print("tile2State -> ", (int)p.tile2State);
		undoStack.Push(p);
		GD.Print("Num In Stack -> ", undoStack.Count);
		GD.Print("\n");

	}

	public string peekUndoStackAction()
	{
		if(undoStack.Count != 0)
		{
			playerStruct p = undoStack.Peek();
			return p.action;
		}
		else return "OK";
	}


	public int GetNumberOfFreeSpaces()
	{
		int result = 0;
		for(int y = 0; y < tileState.GetLength(0); y++)
		{
			for(int x = 0; x < tileState.GetLength(1);x++)
			{
				if(tileState[y,x] != null)
					if((int)tileState[y,x].Call("get_state") == 0)
						result++;
			}
		}
		return result;
	}
	public int GetNumberOfLockedSpaces()
	{
		int result = 0;
		for(int y = 0; y < currBoard.GetLength(0); y++)
		{
			for(int x = 0; x < currBoard.GetLength(1);x++)
			{
				if(tileState[y,x] != null)
					if((int)tileState[y,x].Call("get_state") == 2)
						result++;
			}
		}
		return result;
	}


	private void _on_SpliButton_pressed() { gameNode.Call("player_split"); }

	private void _on_ResetButton_pressed()
	{
		MusicNode.Call("onReset");
		globalNode.Call("set_isLevelReset", true);
		GetTree().ChangeScene("res://Scenes/UI/UI_GameHub.tscn");
	}

	private void _on_SwapPlayerButton_pressed() { gameNode.Call("Change_player"); }


	/*** THIS WORKS BUT NOT WITH SPLITS OR DELETION YET   ***/
	private void _on_UndoButton_pressed()
	{
		
		GD.Print("---PLAYERS BEFORE UNDO---");
		gameNode.Call("printPlayers");
		scoring.Call("start_timer");
		MusicNode.Call("onUndo");
		if(undoStack.Count == 0)
		{
			_on_ResetButton_pressed();
		}
		else
		{
			playerStruct p = undoStack.Pop();
			if(p.action == "MOVE")
			{
				GD.Print("MOVE <- Unwind");
				DisableTile((int)p.prevPos.x, (int)p.prevPos.y);
				DisableTile((int)p.currPos.x, (int)p.currPos.y);
				//CHANGE PLAYER MOVE
				KinematicBody2D playerThis = (KinematicBody2D)gameNode.Call("get_player_at_index", p.player);
				playerThis.Call("set_player_grid_vector", p.prevPos);
				playerThis.Call("set_pos", (int)p.prevPos.x * textureSize+xOffset, (int)p.prevPos.y * textureSize+yOffset);
				if(p.currNum != (int)globalNode.Call("get_max_val"))
					playerThis.Call("set_current_value", p.currNum + 1);
				else
					playerThis.Call("set_current_value", globalNode.Call("get_max_val"));

				if(p.grabbedCollectableNum == 0)
				{
					//CHANGE TILE STATE
					tileState[(int)p.prevPos.y,(int)p.prevPos.x].Call("set_state", p.tile1State);
					tileState[(int)p.currPos.y,(int)p.currPos.x].Call("set_state", p.tile2State);
					EnableTile((int)p.prevPos.x, (int)p.prevPos.y);
					EnableTile((int)p.currPos.x, (int)p.currPos.y);
				}
				else
				{
					if(p.grabbedCollectableNum == 1)
						isCollectOne = true;
					else if(p.grabbedCollectableNum == 2)
						isCollectTwo = true;
					else
						isCollectThree = true;
					//CREATE COLLECTABLE
					scoring.Call("collectable_added");
					Node2D collectable = (Node2D)collectScene.Instance();
					collectable.Scale = currScale;
					collectable.Call("set_collect_grid", (int)p.currPos.x, (int)p.currPos.y);
					collectable.Position = new Vector2((int)p.currPos.x*textureSize+xOffset, (int)p.currPos.y*textureSize+yOffset);
					gameNode.AddChild(collectable);

					//CHANGE TILE STATE
					tileState[(int)p.prevPos.y,(int)p.prevPos.x].Call("set_state", p.tile1State);
					tileState[(int)p.currPos.y,(int)p.currPos.x].Call("set_state", 0);
					EnableTile((int)p.prevPos.x, (int)p.prevPos.y);
					EnableTile((int)p.currPos.x, (int)p.currPos.y);
				}
				
			}
			else if(p.action == "MERGE")
			{
				GD.Print("MERGE <- Unwind");
				
				DisableTile((int)p.prevPos.x, (int)p.prevPos.y);
				DisableTile((int)p.currPos.x, (int)p.currPos.y);
				//CHANGE PLAYER MOVE
				//CREATE DELETED PLAYER
				KinematicBody2D playerNode = (KinematicBody2D)playerScene.Instance();
				playerNode.Scale = currScale;
				playerNode.SetScript(ResourceLoader.Load("res://Scripts/Player_Script.gd"));
				playerNode.Call("set_pos", (int)p.currPos.x * textureSize+xOffset, (int)p.currPos.y * textureSize+yOffset);
				gameNode.AddChild(playerNode);
				swipeScene.Call("connect_node", playerNode);
				playerNode.Call("set_main_game_node", this);
				playerNode.Call("set_player_grid_vector", p.currPos);
				playerNode.Call("set_current_value", p.currNum);
				playerNode.Call("connect_player"); 
				gameNode.Call("placeAtIndexInArray", p.player2, playerNode);
				GD.Print("---PLAYERS AFTER UNDO---");
				gameNode.Call("printPlayers");
				
				KinematicBody2D playerThis = (KinematicBody2D)gameNode.Call("get_player_at_index", p.player);
				playerThis.Call("set_pos", (int)p.prevPos.x * textureSize+xOffset, (int)p.prevPos.y * textureSize+yOffset);
				playerThis.Call("set_player_grid_vector", p.prevPos);
				playerThis.Call("set_current_value", p.prevNum);
				gameNode.Call("update_player_vals", playerThis);
				//CHANGE TILE STATE
				tileState[(int)p.prevPos.y,(int)p.prevPos.x].Call("set_state", p.tile1State);
				tileState[(int)p.currPos.y,(int)p.currPos.x].Call("set_state", p.tile2State);
				EnableTile((int)p.prevPos.x, (int)p.prevPos.y);
				EnableTile((int)p.currPos.x, (int)p.currPos.y);
			}
			else if(p.action == "DELETE")
			{
				GD.Print("DELETE <- Unwind");
				DisableTile((int)p.prevPos.x, (int)p.prevPos.y);
				DisableTile((int)p.currPos.x, (int)p.currPos.y);
				KinematicBody2D playerNode2 = (KinematicBody2D)playerScene.Instance();
				playerNode2.Scale = currScale;
				playerNode2.SetScript(ResourceLoader.Load("res://Scripts/Player_Script.gd"));
				playerNode2.Call("set_pos", (int)p.prevPos.x * textureSize+xOffset, (int)p.prevPos.y * textureSize+yOffset);
				gameNode.AddChild(playerNode2);
				swipeScene.Call("connect_node", playerNode2);
				playerNode2.Call("set_main_game_node", this);
				playerNode2.Call("set_player_grid_vector", p.prevPos);
				playerNode2.Call("set_current_value", p.prevNum);
				playerNode2.Call("connect_player"); 
				gameNode.Call("placeAtIndexInArray", p.player2, playerNode2);
				gameNode.Call("update_player_vals", playerNode2);
				GD.Print("State 1 -> ", p.tile1State);
				GD.Print("State 2 -> ", p.tile2State);
				if(p.grabbedCollectableNum == 0)
				{
					//CHANGE TILE STATE
					tileState[(int)p.prevPos.y,(int)p.prevPos.x].Call("set_state", p.tile1State);
					tileState[(int)p.currPos.y,(int)p.currPos.x].Call("set_state", p.tile2State);
					EnableTile((int)p.prevPos.x, (int)p.prevPos.y);
					EnableTile((int)p.currPos.x, (int)p.currPos.y);
				}
				else
				{
					if(p.grabbedCollectableNum == 1)
						isCollectOne = true;
					else if(p.grabbedCollectableNum == 2)
						isCollectTwo = true;
					else
						isCollectThree = true;
					//CREATE COLLECTABLE
					scoring.Call("collectable_added");
					Node2D collectable = (Node2D)collectScene.Instance();
					collectable.Scale = currScale;
					collectable.Call("set_collect_grid", (int)p.currPos.x, (int)p.currPos.y);
					collectable.Position = new Vector2((int)p.currPos.x*textureSize+xOffset, (int)p.currPos.y*textureSize+yOffset);
					gameNode.AddChild(collectable);

					//CHANGE TILE STATE
					tileState[(int)p.prevPos.y,(int)p.prevPos.x].Call("set_state", p.tile1State);
					tileState[(int)p.currPos.y,(int)p.currPos.x].Call("set_state", 0);
					EnableTile((int)p.prevPos.x, (int)p.prevPos.y);
					EnableTile((int)p.currPos.x, (int)p.currPos.y);
				}
				if (peekUndoStackAction() == "MOVE")
					_on_UndoButton_pressed();
			}
			else if(p.action == "SPLIT")
			{
				GD.Print("SPLIT <- Unwind");
				globalNode.Call("set_tile_toggle", false);
				DisableTile((int)p.prevPos.x, (int)p.prevPos.y);
				DisableTile((int)p.currPos.x, (int)p.currPos.y);
				KinematicBody2D playerThis = (KinematicBody2D)gameNode.Call("get_player_at_index", p.player);
				KinematicBody2D playerSplit = (KinematicBody2D)gameNode.Call("get_player_at_index", p.player2);
				gameNode.Call("remove_player_from_array", playerSplit);
				playerThis.Call("set_current_value", p.currNum);
				
				//CHANGE TILE STATE
				tileState[(int)p.prevPos.y,(int)p.prevPos.x].Call("set_state", p.tile1State);
				tileState[(int)p.currPos.y,(int)p.currPos.x].Call("set_state", p.tile2State);
				tileState[(int)p.prevPos.y,(int)p.prevPos.x].Call("turn_on_area_exit_for_stack");
				tileState[(int)p.currPos.y,(int)p.currPos.x].Call("turn_on_area_exit_for_stack");
			}
		}

//		GD.Print("---PLAYERS---");
//		gameNode.Call("printPlayers");
//		GD.Print("Stack Count -> ", undoStack.Count);
	}

	private void _on_AddButton_pressed() { globalNode.Call("toggle_is_add_button"); }


	/***   !!CHANGE!!   <-  THIS SHOULD BE REPLACED WITH GLOBAL VARIBALE   ***/
//	public void player_removed()
//	{
//		scoring.Call("player_removed");
//	}
//	public void collect_removed()
//	{
//		scoring.Call("collectable_removed");
//	}



	public void win_condition()
	{
		// place what happens when the player wins here
		//call and show the "You Win" popup, unless its tutorial as that doesnt need popup
		if (!(bool)globalNode.Call("get_isTutorial"))
		{
			var popup = GetParent().GetParent().GetParent().GetNode<PopupDialog>("WinPopup/PopupDialog");
			if(popup != null && did_win == false)
			{
				did_win = true;
				scoring.Call("End_timer");
				popup.Popup_();
				MusicNode.Call("gameWin");
				leaderMessenger.Call("send_score", scoring.Call("get_score"), boardName);
				GD.Print(boardName);
			}
		}
	}
	public void game_over()
	{
			scoring.Call("End_timer");
			GD.Print("Game Over!?!");
		// place a game over event here	
	}

	//from player's movement signal send another signal that theres movement to TutorialPanel - signalception
	public void _player_moved() 
	{
		EmitSignal("sendIsMoved");
	}

	//TODO: get game info here
	public int GetPlayer(int index)
	{	
		int x = 0;
		Node2D piece = (Node2D)gameNode.Call("get_player_at_index", index);
		if(piece != null)
		{
			x = (int)piece.Call("get_current_value");
			return x;
		}
		else
			return x;

	}
	public int GetCurrentPlayer()
	{
		int x = 0;
		Node2D piece = (Node2D)gameNode.Call("get_cur_player");
		if(piece != null)
		{
			x = (int)piece.Call("get_current_value");
			return x;
		}
		else 
			return x;
	}


	//TODO: For some reason, its stops calling when theres one collectible left
	public int GetNumCollectibles()
	{
		int i = 0;
		if(!isCollectOne)
			i++;
		if(!isCollectTwo)
			i++;
		if(!isCollectThree)
			i++;
//		int size = (int)gameNode.Call("get_collectible_array_size");
//		GD.Print("Collectible Count: " + i);
		return i;
	}

	public int GetNumPlayers()
	{
		int size = (int)gameNode.Call("get_player_array_size");
		return size;
	}
	public void Pause()
	{
//		gameNode.Call("pause_game");
//		GD.Print("PAUSE!!");
		globalNode.Call("set_is_input_disabled", true);
		scoring.Call("End_timer");
	}
	public void Play()
	{
//		GD.Print("PLAYY!!");
		globalNode.Call("set_is_input_disabled", false);
		scoring.Call("start_timer");
	}

	private void _on_BackToWin_pressed()
	{
		did_win = false;
		win_condition();
	}

/***   !!CHANGE!!   THIS IS NO LONGER A NEEDED FUNCTION  ***/
/***   IF YOU NEED TO CHECK IF A TILE IS NULL  USE ***/
/***   THE IsTileExist() FUNCTION AND IF YOU NEED TO ***/
/***   CHANGE THE STATE OF THE TILE USE THE setTileState() FUNCTION ***/
//	public object GetTileState(int x, int y)
//	{
//		if (tileState[y,x] != null)
//		{
//		return tileState[y,x].Call("get_state");
//		}
//		return null;
//	}


	public void SetTileState(int x, int y, object state)
	{
		if (tileState[y,x] != null)
		tileState[y,x].Call("set_state", state);
	}

	public void EnablePlayer(int index)
	{
		gameNode.Call("enable_player", index);
	}
	public void DisablePlayer(int index)
	{
		gameNode.Call("disable_player", index);
	}


	public void InPlay(int index)
	{
		gameNode.Call("in_play", index);
	}

	public void ChangeTileColor(int y, int x)
	{
		tileState[y,x].Call("change_tile_color");
	}


	public void ResetTileColor(int y, int x)
	{
		tileState[y,x].Call("reset_tile_color");
	}

	//special case for tiles with a collectible, its actually not the same as regular tiles
	public void ChangeCollectTileColor(int index)
	{
////		GD.Print("HERE!");
//		GD.Print(index);
//		GD.Print(collectableOnePos.y);
//		GD.Print(collectableOnePos.x);
		Node2D collect = (Node2D)stars[index];
		collect.Call("change_collect_tile_color");
	}

}










///***   PREV VERSION   ***/
//using Godot;
//using System;
//using System.Collections.Generic;
//
//
//public struct playerStruct
//{
//	public int player;
//	public int player2;
//	public int prevX;
//	public int prevY;
//	public int currX;
//	public int currY;
//	public int currNum;
//	public int prevNum;
//	public int tile1State;
//	public int tile2State;
//	public bool grabbedCollectable;
//	public string action;
//}
//
//
//public class GameBoard : Node2D
//{
//////
////
////	100 - LOCKED TILE
////
////	95 - PLATFORM IMMINENT
////
////	90 - PLATFORM TILE
////
////	80 - WALL TILE
////	
////	[Number Desired] - PLAYER TILES <- Number is randomized based on level size
////
////	70 - Star or jewewl <- pick-up item for extra score
////
//////
//[Signal] 
//public delegate void sendIsMoved();
//
//private Stack<playerStruct> undoStack;
//private Node scoring ;
//private Node leaderMessenger;
//private Texture wallTexture =  (Texture)ResourceLoader.Load("res://Assets/Sprites/icon.png");
//private Script gameScript = (Script)ResourceLoader.Load("res://Scripts/Game.gd");
//private PackedScene tileScene = (PackedScene)ResourceLoader.Load("res://Scenes/Tile.tscn");	
//private Node globalNode ;
//private Node MusicNode ;
//private Node2D swipeScene;
//private PackedScene playerScene = (PackedScene)ResourceLoader.Load("res://Scenes/Player.tscn");
//private PackedScene collectScene = (PackedScene)ResourceLoader.Load("res://Scenes/Collectable.tscn");
//private int free_num_player = 0;
//private Vector2 collectableOnePos = new Vector2(0,0); 
//private Vector2 collectableTwoPos = new Vector2(0,0); 
//private Vector2 collectableThreePos = new Vector2(0,0); 
//private Vector2 currScale = new Vector2(0,0); 
//private string boardName = "";
//
//private int playerNum = -1;
//private int immenentNum = -1;
//private int coreNum = -1;
//
//
//public int textureSize = 64;
//public int xOffset = 25;
//public int yOffset = 25;
//public int invisibleTileX = 18;
//public int invisibleTileY = 20;
//
//
//public enum gridSize{FIVE = 0, SIX = 1, EIGHT = 2};
//private gridSize currGridSize;
//public enum diff{EASY = 0, MEDIUM = 1, HARD = 2, CUSTOM = 3};
//private diff currDiff;
//private bool did_win = false;
//
//private Node2D gameNode;
//private Label boardSizeLabel;
//
//public static int[,] currBoard;
//public static Node2D[,] tileState;
//
//
//public override void _Ready()
//{
//	swipeScene = (Node2D)GetNode<Node2D>("SwipeDetector");
//	gameNode = new Node2D();
//	globalNode = GetNode("/root/Global");
//	MusicNode = GetNode("/root/MusicPlayer");
//	gameNode.SetScript(gameScript);
//	AddChild(gameNode);
//	scoring = (Node)GetNode<Node>("../../../UI/ScorePanel");
//	leaderMessenger = (Node)GetNode<Node>("messenger");
//	currGridSize = (gridSize)globalNode.Call("get_grid");
//	currDiff = (diff)globalNode.Call("get_diff");
//	playerNum = (int)globalNode.Call("get_player_Num");
//	immenentNum = (int)globalNode.Call("get_immenent_Num");
//	coreNum = (int)globalNode.Call("get_max_val");
//	undoStack = new Stack<playerStruct>();
//	globalNode.Call("connect_Pause_Play", this);
//	boardSizeLabel = (Label)GetNode<Label>("../../../UI/BoardSizeLabel");
//
//
//	//Level Reseting is pressed
//	if ((bool)globalNode.Call("get_isLevelReset"))
//	{
////		GD.Print("RESET");
////		MusicNode.Call("SwapTrack");
//		CreateBoard(currGridSize, GameBoard.currBoard);
//	}
//
//	//Tutorial Mode
//	else if ((bool)globalNode.Call("get_isTutorial"))
//	{
//		TutorialLevel();
//		GD.Print("Tutorial ON");
//	}
//
//	//RoadMap Mode
//	else if ((bool)globalNode.Call("get_isRoadMap"))
//	{
//		GD.Print("Roadmap ON");
//		StartRoadMapGame();
//	}
////
//	//Custom Play Mode
//	else if ((bool)globalNode.Call("get_isCustom"))
//	{
//		currDiff = GameBoard.diff.CUSTOM;
//		CreateRandomBoard(currGridSize,currDiff,playerNum,immenentNum, coreNum, (bool)globalNode.Call("get_isCustom"));
//		GD.Print("Custom Play ON");
//	}
//	else if ((bool)globalNode.Call("get_isLevelEditor"))
//	{
//		CreateBoard(currGridSize, GameBoard.currBoard);
//		GD.Print("Level Editor Play ON");
//	}
//	//Standard Play
//	else 
//	{
//		GD.Print("Standard Play ON");
//		CreateRandomBoard(currGridSize,currDiff,-1,-1,-1, (bool)globalNode.Call("get_isCustom"));
//	}
//	//Make another signal from _player_moved to sendIsMoved so Tutorial Panel can receieve it
//	Panel tutPanel = GetParent().GetParent().GetParent().GetNode<Panel>("UI/TutorialPanel");
//	Connect("sendIsMoved", tutPanel, "on_sendIsMoved");
//
//}
//
//	public void CreateBoard(gridSize _size, int[,] suggestedLevel)
//	{
//		currGridSize = _size;
//		globalNode.Call("set_grid", currGridSize);
//
//
//		int xMax = 0,yMax = 0;
//		GameBoard.currBoard = suggestedLevel;
//		switch(_size)
//		{
//			//TODO: from top left of board, make new parameters
//			case gridSize.FIVE:
//				Position = new Vector2(xOffset - 50, yOffset - 75);
//				textureSize = 64 + 16;
//				xMax = yMax = 7;
//				currScale = new Vector2(1.6f, 1.6f);
//				if(!(bool)globalNode.Call("get_isTutorial"))
//					if(!(bool)globalNode.Call("get_isCustom"))
//						boardSizeLabel.Text = "5x5     Free Number: 16";
//					else
//						boardSizeLabel.Text = "5x5     Free Number: " + globalNode.Call("get_max_val");
//				break;
//			case gridSize.SIX:
//				Position = new Vector2(xOffset - 30, yOffset - 55);
//				xMax = yMax = 8;
//				textureSize = 64;
//				currScale = new Vector2(1.3f, 1.3f);
//				if(!(bool)globalNode.Call("get_isTutorial"))
//					if(!(bool)globalNode.Call("get_isCustom"))
//						boardSizeLabel.Text = "6x6     Free Number: 32";
//					else
//						boardSizeLabel.Text = "6x6     Free Number: " + globalNode.Call("get_max_val");
//				break;
//			case gridSize.EIGHT:
//				Position = new Vector2(xOffset - 35, yOffset - 60);
//				xMax = yMax = 10;
//				textureSize = 50;
//				currScale = new Vector2(1.0f, 1.0f);
//				if(!(bool)globalNode.Call("get_isTutorial"))
//					if(!(bool)globalNode.Call("get_isCustom"))
//						boardSizeLabel.Text = "8x8     Free Number: 64";
//					else
//						boardSizeLabel.Text = "8x8     Free Number: " + globalNode.Call("get_max_val");
//				break;
//			default:
//				GD.Print("Error, Invalid GridSize");
//				return;
//		}
//
//		gameNode.Call("setPlayerScale", currScale);
//		tileState = new Node2D[xMax,yMax];
//		for(int y = 0; y < yMax; y++)
//		{
//			for(int x = 0; x < xMax; x++)
//			{
//				if(suggestedLevel[y,x] == 80)
//				{
//					tileState[y,x] = null;
//					KinematicBody2D wall = new KinematicBody2D();
//					CollisionShape2D collision = new CollisionShape2D();
//					RectangleShape2D rect = new RectangleShape2D();
//					rect.Extents = new Vector2(invisibleTileX,invisibleTileY);
//					collision.Shape = rect;
//					wall.AddChild(collision);
//					wall.Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
//					gameNode.AddChild(wall);
//				}
//				else if(suggestedLevel[y,x] == 70)
//				{
//
//					// ADDING BACKGROUND PLATFORM
//					tileState[y,x] = (Node2D)tileScene.Instance();
//					tileState[y,x].Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
//					tileState[y,x].Scale = currScale;
//
//					gameNode.AddChild(tileState[y,x]);
//
//					Node2D collectable = (Node2D)collectScene.Instance();
//					collectable.Call("set_collect_grid", x, y);
//					gameNode.Call("add_to_collect_array", collectable);
//					collectable.Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
//					collectable.Scale = currScale;
//
//					gameNode.AddChild(collectable);
//
//					if(collectableOnePos == new Vector2(0,0))
//						collectableOnePos = new Vector2(x,y);
//					else if(collectableTwoPos == new Vector2(0,0))
//						collectableTwoPos = new Vector2(x,y);
//					else if(collectableThreePos == new Vector2(0,0))
//						collectableThreePos = new Vector2(x,y);
//				}
//
//				else if(suggestedLevel[y,x] == 90)
//				{
//					tileState[y,x] = (Node2D)tileScene.Instance();
//					tileState[y,x].Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
//					tileState[y,x].Scale = currScale;
//
//					gameNode.AddChild(tileState[y,x]);
//				}
//
//				else if(suggestedLevel[y,x] == 95)
//				{
//					tileState[y,x] = (Node2D)tileScene.Instance();
//					tileState[y,x].Call("set_state_onGen", 1);
//					tileState[y,x].Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
//					tileState[y,x].Scale = currScale;
//					gameNode.AddChild(tileState[y,x]);
//				}
//
//				else if(suggestedLevel[y,x] == 100)
//				{
//					tileState[y,x] = (Node2D)tileScene.Instance();
//					tileState[y,x].Call("set_state_onGen", 2);
//					tileState[y,x].Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
//					tileState[y,x].Scale = currScale;
//					gameNode.AddChild(tileState[y,x]);
//				}
//
//				else
//				{	
//					//ADDING BACKGROUND PLATFORM
//					tileState[y,x] = (Node2D)tileScene.Instance();
//					tileState[y,x].Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
//					tileState[y,x].Scale = currScale;
//
//					gameNode.AddChild(tileState[y,x]);
//
//
//					//@OPTIMIZE GET MAX NUMBER FUNCTION
//					if(xMax == 7 && suggestedLevel[y,x] > 16)
//						suggestedLevel[y,x] = 16;
//					if(xMax == 8 && suggestedLevel[y,x] > 32)
//						suggestedLevel[y,x] = 32;
//					if(xMax == 10 && suggestedLevel[y,x] > 64)
//						suggestedLevel[y,x] = 64;
//					Node2D playerNode = (Node2D)playerScene.Instance();		
//
//					playerNode.SetScript(ResourceLoader.Load("res://Scripts/Player_Script.gd"));
//					int tmp = suggestedLevel[y,x];
//
//					playerNode.Position = new Vector2(x*textureSize+xOffset, y*textureSize+yOffset);
//					playerNode.Scale = currScale;
//
//
//					gameNode.AddChild(playerNode);
//					playerNode.Call("set_moves_left", tmp);
//					swipeScene.Call("connect_node", playerNode);
//					playerNode.Call("set_main_game_node", this);
//					playerNode.Call("set_player_grid", x , y, false);
//					playerNode.Call("set_tile_size", textureSize);
//					if(xMax == 7)
//					{
//					free_num_player = 16;
//					playerNode.Call("set_map_size", 5);
//					}
//					if(xMax == 8)
//					{
//					free_num_player = 32;
//					playerNode.Call("set_map_size", 6);
//					}
//					if(xMax == 10)
//					{
//					free_num_player = 64;
//					playerNode.Call("set_map_size", 8);
//					}
//					int temp = (int)globalNode.Call("get_max_val");
//					if ((bool)globalNode.Call("get_isCustom"))
//					{
//						free_num_player = temp;
//					}
//					playerNode.Call("set_map_num", free_num_player); // change this for what the free num should be for each map 
//					gameNode.Call("add_to_player_array", playerNode); // this is for adding the player to the array to be managed
//					playerNode.Call("connect_player"); 
//				}
//			}
//		}
//	}
//
//	/*** MAKE BOOLEAN TO FORCE NON-RANDOMNESS  ***/
//	public void CreateRandomBoard(gridSize _grid = gridSize.FIVE, 
//	diff _difficulty = diff.EASY, int numPlayers = -1,
//	int numImminent = -1, int coreDiv = -1, bool isCustom = false) //CORE_DIV REFERS TO SUMMATION OF ALL PLAYER TILE NUMBERS
//	{
//
//		if(numPlayers == 0)
//			numPlayers = -1;
//		if(coreDiv == 0 || isCustom)
//			coreDiv = -1;
//		int[,] arr;
//		int maxNum = 0;
//		int currStar = 0;
//		int currPlayer = 0;
//		int currImminent = 0;
//		int freeNum = 0;
//		if((int)globalNode.Call("get_max_val") < 3)
//			globalNode.Call("set_max_val", 3);
//
//		switch(_grid)
//		{
//			case gridSize.FIVE:
//				maxNum = 7;
//				if(isCustom)
//					freeNum = (int)globalNode.Call("get_max_val") - 1;
//				else
//					freeNum = 14;
//				break;
//			case gridSize.SIX:
//				maxNum = 8;
//				if(isCustom)
//					freeNum = (int)globalNode.Call("get_max_val") - 1;
//				else
//					freeNum = 30;
//				break;
//			case gridSize.EIGHT:
//				maxNum = 10;
//				if(isCustom)
//					freeNum = (int)globalNode.Call("get_max_val") - 1;
//				else
//					freeNum = 62;
//				break;
//		}		
//		arr = new int[maxNum, maxNum];
//		Random rnd = new Random();
//		switch(_difficulty)
//		{
//			case diff.EASY:
//				if(_grid == gridSize.FIVE)
//				{
//					scoring.Call("set_base_score", 1000);
//					boardName = "5x5";
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 4) + 3;
//					if(coreDiv == -1)
//						coreDiv = (rnd.Next() % 20) + 50;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 2);
//				}
//				else if(_grid == gridSize.SIX)
//				{
//					boardName = "6x6";
//					scoring.Call("set_base_score", 2000);
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 8) + 3;
//					if(coreDiv == -1)
//						coreDiv = (rnd.Next() % 30) + 20;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 5);
//				}
//				else
//				{
//					scoring.Call("set_base_score", 3000);
//					boardName = "8x8";
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 10) + 5;
//					if(coreDiv == -1)	
//						coreDiv = (rnd.Next() % 80) + 20;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 12);
//				}
//				break;
//			case diff.MEDIUM:
//				if(_grid == gridSize.FIVE)
//				{
//					scoring.Call("set_base_score", 2000);
//					boardName = "5x5";
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 3) + 8;
//					if(coreDiv == -1)
//						coreDiv = (rnd.Next() % 40) + 30;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 12);
//				}
//				else if(_grid == gridSize.SIX)
//				{
//					scoring.Call("set_base_score", 3000);
//					boardName = "6x6";
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 14) + 6;
//					if(coreDiv == -1)
//						coreDiv = (rnd.Next() % 20) + 40;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 25);
//				}
//				else
//				{
//					scoring.Call("set_base_score", 4000);
//					boardName = "8x8";
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 10) + 12;
//					if(coreDiv == -1)
//						coreDiv = (rnd.Next() % 70) + 60;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 20) + 10;
//				}
//				break;
//			case diff.HARD:
//				if(_grid == gridSize.FIVE)
//				{
//					scoring.Call("set_base_score", 4000);
//					boardName = "5x5";
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 4) + 10;
//					if(coreDiv == -1)
//						coreDiv = (rnd.Next() % 40) + 60;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 3) + 12;
//				}
//				else if(_grid == gridSize.SIX)
//				{
//					scoring.Call("set_base_score", 4500);
//					boardName = "6x6";
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 10) + 8;
//					if(coreDiv == -1)
//						coreDiv = (rnd.Next() % 50) + 60;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 10) + 12;
//				}
//				else
//				{
//					scoring.Call("set_base_score", 5000);
//					boardName = "8x8";
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 20) + 20;
//					if(coreDiv == -1)
//						coreDiv = (rnd.Next() % 30) + 100;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 40) + 10;
//				}
//				break;
//				// for the custom version of the grid
//			case diff.CUSTOM:
//				if(_grid == gridSize.FIVE)
//				{
//					scoring.Call("set_base_score", 1250);
//					boardName = "custom";
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 4) + 4;
//					if(coreDiv == -1)	
//						coreDiv = (rnd.Next() % 20) + 40;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 10);
//				}
//				else if(_grid == gridSize.SIX)
//				{
//					scoring.Call("set_base_score", 2250);
//					boardName = "custom";
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 15) + 5;
//					if(coreDiv == -1)	
//						coreDiv = (rnd.Next() % 30) + 50;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 45);
//				}
//				else
//				{
//					scoring.Call("set_base_score", 2750);
//					boardName = "custom";
//					if(numPlayers == -1)
//						numPlayers = (rnd.Next() % 20) + 20;
//					if(coreDiv == -1)	
//						coreDiv = (rnd.Next() % 30) + 100;
//					if(numImminent == -1)
//						numImminent = (rnd.Next() % 25) + 20;
//				}
//				break;
//		}
//
//		for(int y = 0; y < maxNum; ++y)
//			{
//				for(int x = 0; x < maxNum; ++x)
//				{
//					if(x == 0 || y == 0 || x == maxNum - 1 || y == maxNum - 1)
//						arr[y,x] = 80;
//					else
//						while(true)
//						{
//							int tileNum = rnd.Next() % 11;
//							if(tileNum == 1 && currPlayer < numPlayers && coreDiv != 0)
//							{
//								tileNum = (rnd.Next() % freeNum) + 1;
//								if(tileNum < coreDiv)
//								{
//									arr[y,x] = (int)tileNum;
//									coreDiv -= tileNum;
//								}
//								else
//								{
//									arr[y,x] = (int)coreDiv;
//									coreDiv -= coreDiv;
//								}
//								currPlayer++;
//								break;
//							}
//
//							else if(tileNum == 2 && currStar != 3)
//							{
//								arr[y,x] = 70;
//								currStar++;
//								break;
//							}
//
//							else if(tileNum == 10 && numImminent > currImminent)
//							{
//								arr[y,x] = 95;
//								currImminent++;
//								break;
//							}
//							else
//							{
//								arr[y,x] = 90;
//								break;
//							}
//						}
//				}
//			}
//
//		while(currStar != 3)
//		{
//			int x = (rnd.Next() % (maxNum - 2)) + 1;
//			int y = (rnd.Next() % (maxNum - 2)) + 1;
//			if(arr[y,x] == 90)
//			{
//				arr[y,x] = 70;
//				currStar++;
//			}
//		}		
//
//		while(currPlayer < numPlayers)
//		{
//			int x = (rnd.Next() % (maxNum - 2)) + 1;
//			int y = (rnd.Next() % (maxNum - 2)) + 1;
//			if(arr[y,x] == 90 || arr[y,x] == 95 )
//			{
//				arr[y,x] = (rnd.Next() % freeNum) + 1;
//				currPlayer++;
//			}
//		}
//
//		while(currImminent < numImminent)
//		{
//			int x = (rnd.Next() % (maxNum - 2)) + 1;
//			int y = (rnd.Next() % (maxNum - 2)) + 1;
//			if(arr[y,x] == 90)
//			{
//				arr[y,x] = 95;
//			}
//			currImminent++;
//		}
//
//		switch(maxNum)
//		{
//			case 7:
//				CreateBoard(gridSize.FIVE, arr);
//				break;
//			case 8:
//				CreateBoard(gridSize.SIX, arr);
//				break;
//			case 10:
//				CreateBoard(gridSize.EIGHT, arr);
//				break;
//		}
//	}
//
//	public void TutorialLevel()
//	{
//		int[,] arr = new int[10,10]
//		{
//			{80, 80, 80, 80, 80, 80, 80, 80, 80, 80},
//			{80, 14, 95,  1, 95, 95, 95, 95, 95, 80},
//			{80,100,100,100, 95,100,100,100, 95, 80},
//			{80, 95, 70,100, 95, 90, 95, 95, 95, 80},
//			{80, 70,100,100,100, 95,100,100,100, 80},
//			{80, 90, 90,100,100,100,100,100, 32, 80},
//			{80,100, 90, 90, 90,100, 95, 95,  2, 80},
//			{80,100, 95,100, 90, 90, 90,100,100, 80},
//			{80,  8,100,100, 70,100, 90,100, 13, 80},
//			{80, 80, 80, 80, 80, 80, 80, 80, 80, 80}
//		};
//		CreateBoard(gridSize.EIGHT, arr);
//	}
//
//
//	public void StartRoadMapGame()
//	{
//		switch(globalNode.Call("get_roadMapLevel"))
//		{
//			case 1:
//				scoring.Call("set_base_score", 2000);
//				boardName = "01";
//				RoadMapLevelOne();
//				break;
//			case 2:
//				scoring.Call("set_base_score", 3000);
//				boardName = "02";
//				RoadMapLevelTwo();
//				break;
//			case 3:
//				scoring.Call("set_base_score", 4000);
//				boardName = "03";
//				RoadMapLevelThree();
//				break;
//			case 4:
//				scoring.Call("set_base_score", 4500);
//				boardName = "04";
//				RoadMapLevelFour();
//				break;
//			case 5:
//				scoring.Call("set_base_score", 5000);
//				boardName = "05";
//				RoadMapLevelFive();
//				break;
//			case 6:
//				scoring.Call("set_base_score", 5500);
//				boardName = "06";
//				RoadMapLevelSix();
//				break;
//			case 7:
//				scoring.Call("set_base_score", 6000);
//				boardName = "07";
//				RoadMapLevelSeven();
//				break;
//			case 8:
//				scoring.Call("set_base_score", 6500);
//				boardName = "08";
//				RoadMapLevelEight();
//				break;
//			case 9:
//				scoring.Call("set_base_score", 7500);
//				boardName = "09";
//				RoadMapLevelNine();
//				break;
//			case 10:
//				scoring.Call("set_base_score", 10000);
//				boardName = "Final Level";
//				RoadMapLevelTen();
//				break;
//			default:
//				GD.Print("ERROR ON GET ROAD MAP NUMBER");
//				break;
//		}
//	}
//
//
//	public void RoadMapLevelOne()
//	{
//		int[,] arr = new int[10,10]
//			{
//				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80},
//				{80, 70, 95, 95, 95, 95, 95, 90, 70, 80},
//				{80,100, 95,100,100,100, 95,100,100, 80},
//				{80,100, 95,100, 35, 90, 95, 90, 90, 80},
//				{80,100, 95,100, 90, 90, 95, 90, 90, 80},
//				{80,100, 95,100,100, 90, 95, 90, 90, 80},
//				{80, 95, 95, 95,100, 90, 95, 90, 90, 80},
//				{80, 95, 15, 95,100, 95, 95, 90, 90, 80},
//				{80, 95, 70, 95,100, 95, 95, 95, 10, 80},
//				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80}
//			};
//		CreateBoard(gridSize.EIGHT, arr);
//
//	}
//
//	public void RoadMapLevelTwo()
//	{
//		int[,] arr = new int[8,8]
//			{
//				{80, 80, 80, 80, 80, 80, 80, 80},
//				{80, 20,100, 90, 70,100, 70, 80},
//				{80, 10,100, 90, 90,100, 95, 80},
//				{80, 90,100, 90, 90,100, 95, 80},
//				{80, 90, 95, 90, 90, 95, 95, 80},
//				{80, 90,100,100,100,100, 95, 80},
//				{80, 90, 90, 95, 70, 95, 90, 80},
//				{80, 80, 80, 80, 80, 80, 80, 80}
//			};
//		CreateBoard(gridSize.SIX, arr);
//
//	}
//
//	public void RoadMapLevelThree()
//	{
//		int[,] arr = new int[7,7]
//			{
//				{80, 80, 80, 80, 80, 80, 80},
//				{80, 10, 90,  1, 90,  1, 80},
//				{80,100,100,100, 70, 90, 80},
//				{80,  1, 90, 70,100,  1, 80},
//				{80, 90,100,100, 70, 90, 80},
//				{80,  1, 90,  1, 90,  1, 80},
//				{80, 80, 80, 80, 80, 80, 80}
//			};
//		CreateBoard(gridSize.FIVE, arr);
//
//	}
//
//	public void RoadMapLevelFour()
//	{
//		int[,] arr = new int[7,7]
//			{
//				{80, 80, 80, 80, 80, 80, 80},
//				{80, 70,100, 90,  2, 90, 80},
//				{80,100,100, 90, 90, 90, 80},
//				{80, 70, 90, 70, 90, 90, 80},
//				{80, 15, 90, 90, 90, 90, 80},
//				{80, 14, 90, 90, 90, 90, 80},
//				{80, 80, 80, 80, 80, 80, 80}
//			};
//		CreateBoard(gridSize.FIVE, arr);
//
//	}
//
//	public void RoadMapLevelFive()
//	{
//		int[,] arr = new int[8,8]
//			{
//				{80, 80, 80, 80, 80, 80, 80, 80},
//				{80,  2, 90,  2, 90,100, 70, 80},
//				{80, 90,  2, 90,  2,100, 90, 80},
//				{80,  2, 90,  2,100,100, 90, 80},
//				{80, 70,  2, 90, 90, 90, 90, 80},
//				{80,  2, 90,  2,100,100, 90, 80},
//				{80, 90,  2, 90,  2,100, 70, 80},
//				{80, 80, 80, 80, 80, 80, 80, 80}
//			};
//		CreateBoard(gridSize.SIX, arr);
//
//	}
//
//	public void RoadMapLevelSix()
//	{
//		int[,] arr = new int[10,10]
//			{
//				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80},
//				{80, 70, 70, 70, 95, 95, 95, 95, 95, 80},
//				{80,100,100,100,100,100, 95, 95, 95, 80},
//				{80, 95, 95, 95, 95,100, 95, 95, 95, 80},
//				{80, 95,  1,100, 95,100, 95, 95, 95, 80},
//				{80, 95, 95,100, 20,100, 95, 95, 95, 80},
//				{80,  1,  2,100,100,100, 95, 95, 95, 80},
//				{80, 95, 95, 95,  1, 95,  2,  2,  2, 80},
//				{80, 95,  1, 95,  1, 95,  5,  3, 95, 80},
//				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80}
//			};
//		CreateBoard(gridSize.EIGHT, arr);
//
//	}
//
//	public void RoadMapLevelSeven()
//	{
//		int[,] arr = new int[7,7]
//			{
//				{80, 80, 80, 80, 80, 80, 80},
//				{80, 90,  7,100, 90, 70, 80},
//				{80, 90, 90,100, 70, 90, 80},
//				{80, 90, 90,100, 90, 90, 80},
//				{80, 90, 90, 90, 90, 90, 80},
//				{80, 70, 90,100,  4, 90, 80},
//				{80, 80, 80, 80, 80, 80, 80}
//			};
//		CreateBoard(gridSize.FIVE, arr);
//
//	}
//
//	public void RoadMapLevelEight()
//	{
//		int[,] arr = new int[8,8]
//			{
//				{80, 80, 80, 80, 80, 80, 80, 80},
//				{80,100, 95, 14, 12, 90, 90, 80},
//				{80, 95, 90,100,100, 90,100, 80},
//				{80, 90, 95,100, 90, 90, 90, 80},
//				{80, 90, 95,100, 90,100, 90, 80},
//				{80, 70, 90,100, 90,100, 90, 80},
//				{80,100,100,100, 70,100, 70, 80},
//				{80, 80, 80, 80, 80, 80, 80, 80}
//			};
//		CreateBoard(gridSize.SIX, arr);
//
//	}
//
//	public void RoadMapLevelNine()
//	{
//		int[,] arr = new int[10,10]
//			{
//				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80},
//				{80, 90, 90, 90,100, 90, 90, 90, 70, 80},
//				{80, 90, 90, 90,100, 90,100,100,100, 80},
//				{80, 90, 90, 90,100, 90,100, 90, 90, 80},
//				{80,100,100,100,100, 90,100,100,100, 80},
//				{80, 90, 90, 90, 90, 50, 90, 90, 90, 80},
//				{80, 90,100,100,100, 90,100,100, 90, 80},
//				{80, 90,100, 90, 90, 90, 90,100, 90, 80},
//				{80, 70,100, 90, 90, 90, 90,100, 70, 80},
//				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80}
//			};
//		CreateBoard(gridSize.EIGHT, arr);
//	}
//
//	public void RoadMapLevelTen()
//	{
//		int[,] arr = new int[10,10]
//			{
//				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80},
//				{80, 70,100, 90, 90,  5, 90, 90, 90, 80},
//				{80,100,100,  2, 90,  5, 90, 90, 90, 80},
//				{80,  2,  2,  2, 90,  5, 90,100,100, 80},
//				{80, 65, 65,  2, 90,  5, 90, 95, 70, 80},
//				{80, 65, 65,  2, 90,  5, 90,100,100, 80},
//				{80,  2,  2,  2, 90,  5, 90, 90, 90, 80},
//				{80,100,100,  2, 90,  5, 90, 90, 90, 80},
//				{80, 70,100, 90, 90,  5, 90, 90, 90, 80},
//				{80, 80, 80, 80, 80, 80, 80, 80, 80, 80}
//			};
//		CreateBoard(gridSize.EIGHT, arr);
//
//	}
//
//
//	public bool IsSpaceAvailable(int x, int y) 
//	{ 
//		if (tileState[y,x] != null)
//		return (currBoard[y,x] != 70 && currBoard[y,x] != 80) && !(bool)tileState[y,x].Call("is_tile_locked"); 
//		return false;
//	}
//	public bool IsTileLocked(int x, int y) 
//		{
//			if (tileState[y,x] != null)
//			return  (bool)tileState[y,x].Call("is_tile_locked"); 
//			else 
//			return false;
//		}
//	public bool IsTileImm(int x, int y) {return  (bool)tileState[y,x].Call("is_tile_imm"); }
//	public void SetTileState(int x, int y, int state) { tileState[y,x].Call("set_state", state); }
//	public void SetTileAfterMerge(int x, int y) { tileState[y,x].Call("setTileAfterMerge"); }
//	public bool IsTileAStar(int x, int y) { return currBoard[y,x] == 70; }
//	public void UnlockLocked(int x, int y) { tileState[y,x].Call("unlock"); }
//	public void UnlockLocked(int x, int y, bool isStuck) { tileState[y,x].Call("set_state", 1); }
//	public float GetScore() {return GetNode<Label>("Label").Text.ToFloat();}
//	public diff GetLevelDifficulty() { return currDiff; } 
//	public gridSize GetLevelGridSize() { return currGridSize; } 
//	public void addToUndoStack(int currPlayer, int Player2, int prevX, int prevY, int currX, int currY, int prevNum, int currNum, bool isCollectable, string _action)
//	{
//
////		GD.Print("\n");
////		GD.Print("currPlayer -> ",currPlayer);
////		GD.Print("Player2 -> ", (int)Player2);
//		GD.Print("prevX -> ",(int)prevX);
//		GD.Print("prevY -> ", (int)prevY);
//		GD.Print("currX -> ", (int)currX);
//		GD.Print("currY -> ", (int)currY);
//		GD.Print("prevNum -> ", (int)prevNum);
//		GD.Print("currNum -> ", (int)currNum);
//		GD.Print("grabbed collectable -> ", (bool)isCollectable);
//		GD.Print("action -> ", _action);
//		GD.Print("---PLAYERS---");
//		GD.Print("---END OF PLAYERS---");
//		gameNode.Call("printPlayers");
//
//		playerStruct p = new playerStruct()
//		{
//			player = currPlayer,
//			player2 = (int)Player2,
//			prevX = (int)prevX,
//			prevY = (int)prevY,
//			currX = (int)currX,
//			currY = (int)currY,
//			prevNum = (int)prevNum,
//			currNum = (int)currNum,
//			tile1State = (int)tileState[prevY,prevX].Call("get_state"),
//			grabbedCollectable = isCollectable,
//			action = _action
//		};
//
//		if(tileState[currY,currX] != null)
//			p.tile2State = (int)tileState[currY,currX].Call("get_state");
//		else
//			p.tile2State = 0;
//		undoStack.Push(p);
////		GD.Print("Num In Stack -> ", undoStack.Count);
////		GD.Print("\n");
//
//	}
//
//	public string peekUndoStackAction()
//	{
//		if(undoStack.Count != 0)
//		{
//			playerStruct p = undoStack.Peek();
//			return p.action;
//		}
//		else return "OK";
//	}
//
//
//	public int GetNumberOfFreeSpaces()
//	{
//		int result = 0;
//		for(int y = 0; y < tileState.GetLength(0); y++)
//		{
//			for(int x = 0; x < tileState.GetLength(1);x++)
//			{
//				if(tileState[y,x] != null)
//					if((int)tileState[y,x].Call("get_state") == 0)
//						result++;
//			}
//		}
//		return result;
//	}
//	public int GetNumberOfLockedSpaces()
//	{
//		int result = 0;
//		for(int y = 0; y < currBoard.GetLength(0); y++)
//		{
//			for(int x = 0; x < currBoard.GetLength(1);x++)
//			{
//				if(tileState[y,x] != null)
//					if((int)tileState[y,x].Call("get_state") == 2)
//						result++;
//			}
//		}
//		return result;
//	}
//
//
//	private void _on_SpliButton_pressed()
//	{
//		gameNode.Call("player_split");
//	}
//
//	private void _on_ResetButton_pressed()
//	{
//		MusicNode.Call("onReset");
//		globalNode.Call("set_isLevelReset", true);
//		GetTree().ChangeScene("res://Scenes/UI/UI_GameHub.tscn");
//	}
//
//	private void _on_SwapPlayerButton_pressed()
//	{
//		gameNode.Call("update_player_vals");
//		gameNode.Call("Change_player");
//	}
//
//
//	/*** THIS WORKS BUT NOT WITH SPLITS OR DELETION YET   ***/
//	private void _on_UndoButton_pressed()
//	{
//		scoring.Call("start_timer");
//		MusicNode.Call("onUndo");
//		if(undoStack.Count == 0)
//			_on_ResetButton_pressed();
//		else
//		{
//			playerStruct p = undoStack.Pop();
//			if(p.action == "MOVE")
//			{
//				GD.Print("MOVE <- Unwind");
//
//				if(peekUndoStackAction() == "ADD")
//				{
//					GD.Print("ADD <- Unwind");
//					p = undoStack.Pop();
//					/***   START WITH MOVE FUNCTION   ***/
//					tileState[p.prevY,p.prevX].Call("turn_off_area_exit");
//					tileState[p.currY,p.currX].Call("turn_off_area_exit");
//
//					//CREATE DELETED PLAYER
//					KinematicBody2D playerNode2 = (KinematicBody2D)playerScene.Instance();
//					playerNode2.Scale = currScale;
//					playerNode2.SetScript(ResourceLoader.Load("res://Scripts/Player_Script.gd"));
//					gameNode.AddChild(playerNode2);
//					swipeScene.Call("connect_node", playerNode2);
//					playerNode2.Call("set_main_game_node", this);
//					playerNode2.Call("set_tile_size", textureSize);
//					playerNode2.Call("set_pos", p.currX * textureSize+xOffset, p.currY * textureSize+yOffset);
//					playerNode2.Call("set_player_grid", p.currX, p.currY, false);
//					playerNode2.Call("set_moves_left", p.currNum - p.prevNum);
//					playerNode2.Call("set_map_num", free_num_player); 
//					gameNode.Call("placeAtIndexInArray", p.player2, playerNode2);
//					gameNode.Call("add_player_to_object_array", p.currX, p.currY);
//					gameNode.Call("update_player_vals");
//
//					//CHANGE PLAYER MOVE
//					KinematicBody2D playerThis = (KinematicBody2D)gameNode.Call("get_player_at_index", p.player);
//					playerThis.Call("set_pos", p.prevX * textureSize+xOffset, p.prevY * textureSize+yOffset);
//					playerThis.Call("set_player_grid", p.prevX, p.prevY, false);
//					playerThis.Call("set_moves_left", p.prevNum);
//					//CHANGE TILE STATE
//					tileState[p.prevY,p.prevX].Call("set_state", p.tile1State);
//					tileState[p.currY,p.currX].Call("set_state", p.tile2State);
//					tileState[p.prevY,p.prevX].Call("turn_on_area_exit");
//					tileState[p.currY,p.currX].Call("turn_on_area_exit");
//					/***   END OF MOVE FUNCTION   ***/
//				}
//				else if(peekUndoStackAction() == "MULTIPLY")
//				{
//					GD.Print("MULTIPLY <- Unwind");
//					p = undoStack.Pop();
//					/***   START WITH MOVE FUNCTION   ***/
//					tileState[p.prevY,p.prevX].Call("turn_off_area_exit");
//					tileState[p.currY,p.currX].Call("turn_off_area_exit");
//
//					//CREATE DELETED PLAYER
//					KinematicBody2D playerNode2 = (KinematicBody2D)playerScene.Instance();
//					playerNode2.Scale = currScale;
//					playerNode2.SetScript(ResourceLoader.Load("res://Scripts/Player_Script.gd"));
//					gameNode.AddChild(playerNode2);
//					swipeScene.Call("connect_node", playerNode2);
//					playerNode2.Call("set_main_game_node", this);
//					playerNode2.Call("set_tile_size", textureSize);
//					playerNode2.Call("set_pos", p.currX * textureSize+xOffset, p.currY * textureSize+yOffset);
//					playerNode2.Call("set_player_grid", p.currX, p.currY, false);
//					playerNode2.Call("set_moves_left", p.prevNum);
//					playerNode2.Call("set_map_num", free_num_player); 
//					gameNode.Call("placeAtIndexInArray", p.player2, playerNode2);
//					gameNode.Call("add_player_to_object_array", p.currX, p.currY);
//					gameNode.Call("update_player_vals");
//
//					//CHANGE PLAYER MOVE
//					KinematicBody2D playerThis = (KinematicBody2D)gameNode.Call("get_player_at_index", p.player);
//					playerThis.Call("set_pos", p.prevX * textureSize+xOffset, p.prevY * textureSize+yOffset);
//					playerThis.Call("set_player_grid", p.prevX, p.prevY, false);
//					playerThis.Call("set_moves_left", p.currNum / p.prevNum);
//					//CHANGE TILE STATE
//					tileState[p.prevY,p.prevX].Call("set_state", p.tile1State);
//					tileState[p.currY,p.currX].Call("set_state", p.tile2State);
//					tileState[p.prevY,p.prevX].Call("turn_on_area_exit");
//					tileState[p.currY,p.currX].Call("turn_on_area_exit");
//					/***   END OF MOVE FUNCTION   ***/
//				}
//				else if(peekUndoStackAction() == "DELETE")
//				{
//					p = undoStack.Pop();
//					GD.Print("DELETE <- Unwind");
//					tileState[p.prevY,p.prevX].Call("turn_off_area_exit");
//					KinematicBody2D playerNode = (KinematicBody2D)playerScene.Instance();
//					playerNode.Scale = currScale;
//					playerNode.SetScript(ResourceLoader.Load("res://Scripts/Player_Script.gd"));
//					int x = p.prevX;
//					int y = p.prevY;
//					gameNode.AddChild(playerNode);
//					swipeScene.Call("connect_node", playerNode);
//					playerNode.Call("set_tile_size", textureSize);
//					playerNode.Call("set_main_game_node", this);
//					playerNode.Call("set_pos", p.prevX * textureSize+xOffset, p.prevY * textureSize+yOffset);
//					playerNode.Call("set_player_grid", p.prevX, p.prevY, false);
//					playerNode.Call("set_moves_left", 1);
//					playerNode.Call("set_map_num", free_num_player); 
//					gameNode.Call("placeAtIndexInArray", p.player, playerNode);
//
//					if((p.currX == collectableOnePos.x && p.currY == collectableOnePos.y && p.grabbedCollectable) ||
//						(p.currX == collectableTwoPos.x && p.currY == collectableTwoPos.y && p.grabbedCollectable) || 
//						(p.currX == collectableThreePos.x && p.currY == collectableThreePos.y && p.grabbedCollectable))
//					{
//						//CREATE COLLECTABLE
//						scoring.Call("collectable_added");
//						Node2D collectable = (Node2D)collectScene.Instance();
//						collectable.Scale = currScale;
//						collectable.Call("set_collect_grid", p.currX, p.currY);
//						gameNode.Call("add_to_collect_array", collectable);
//						collectable.Position = new Vector2(p.currX*textureSize+xOffset, p.currY*textureSize+yOffset);
//						gameNode.AddChild(collectable);
//
//						//CHANGE TILE STATE
//						tileState[p.prevY,p.prevX].Call("set_state", p.tile1State);
//						tileState[p.currY,p.currX].Call("set_state", 0);
//						tileState[p.prevY,p.prevX].Call("turn_on_area_exit");
//						tileState[p.currY,p.currX].Call("turn_on_area_exit");
//					}
//					else
//					{
//						//CHANGE TILE STATE
//						tileState[p.prevY,p.prevX].Call("set_state", p.tile1State);
//						tileState[p.prevY,p.prevX].Call("turn_on_area_exit");
//					}
//				}
//
//				///ONLY MOVE!!
//				else
//				{
//					tileState[p.prevY,p.prevX].Call("turn_off_area_exit");
//					tileState[p.currY,p.currX].Call("turn_off_area_exit");
//
//					//CHANGE PLAYER MOVE
//					KinematicBody2D playerThis = (KinematicBody2D)gameNode.Call("get_player_at_index", p.player);
//					playerThis.Call("set_pos", p.prevX * textureSize+xOffset, p.prevY * textureSize+yOffset);
//					playerThis.Call("set_player_grid", p.prevX, p.prevY, false);
//					if(p.currNum != free_num_player)
//						playerThis.Call("set_moves_left", p.currNum + 1);
//					else
//						playerThis.Call("set_moves_left", free_num_player);
//
//					if((p.currX == collectableOnePos.x && p.currY == collectableOnePos.y && p.grabbedCollectable) ||
//					(p.currX == collectableTwoPos.x && p.currY == collectableTwoPos.y && p.grabbedCollectable) || 
//					(p.currX == collectableThreePos.x && p.currY == collectableThreePos.y && p.grabbedCollectable))
//					{
//						//CREATE COLLECTABLE
//						scoring.Call("collectable_added");
//						Node2D collectable = (Node2D)collectScene.Instance();
//						collectable.Scale = currScale;
//						collectable.Call("set_collect_grid", p.currX, p.currY);
//						gameNode.Call("add_to_collect_array", collectable);
//						collectable.Position = new Vector2(p.currX*textureSize+xOffset, p.currY*textureSize+yOffset);
//						gameNode.AddChild(collectable);
//
//						//CHANGE TILE STATE
//						tileState[p.prevY,p.prevX].Call("set_state", p.tile1State);
//						tileState[p.currY,p.currX].Call("set_state", 0);
//						tileState[p.prevY,p.prevX].Call("turn_on_area_exit");
//						tileState[p.currY,p.currX].Call("turn_on_area_exit");
//					}
//					else
//					{
//						//CHANGE TILE STATE
//						tileState[p.prevY,p.prevX].Call("set_state", p.tile1State);
//						tileState[p.currY,p.currX].Call("set_state", p.tile2State);
//						tileState[p.prevY,p.prevX].Call("turn_on_area_exit");
//						tileState[p.currY,p.currX].Call("turn_on_area_exit");
//					}
//				}
//			}
//			else if(p.action == "UNLOCK")
//			{
//				GD.Print("UNLOCK <- Unwind");
//				/***   START WITH MOVE FUNCTION   ***/
//				tileState[p.prevY,p.prevX].Call("turn_off_area_exit");
//				tileState[p.currY,p.currX].Call("turn_off_area_exit");
//				//CHANGE TILE STATE
//				GD.Print("Original -> <", p.prevX, ",", p.prevY, ">  == ", p.tile1State, "\n");
//				GD.Print("Current -> <", p.currX, ",", p.currY, ">  == ", p.tile2State, "\n");
//				tileState[p.prevY,p.prevX].Call("set_state", p.tile1State);
//				tileState[p.currY,p.currX].Call("set_state", 2);
//
//				int id = p.player;
//				//CREATE DELETED PLAYER
//
//				KinematicBody2D playerNode2 = (KinematicBody2D)playerScene.Instance();
//				playerNode2.Scale = currScale;
//				playerNode2.SetScript(ResourceLoader.Load("res://Scripts/Player_Script.gd"));
//				gameNode.AddChild(playerNode2);
//				swipeScene.Call("connect_node", playerNode2);
//				playerNode2.Call("set_main_game_node", this);
//				playerNode2.Call("set_tile_size", textureSize);
//				playerNode2.Call("set_pos", p.prevX * textureSize+xOffset, p.prevY * textureSize+yOffset);
//				playerNode2.Call("set_player_grid", p.prevX, p.prevY, false);
//				playerNode2.Call("set_moves_left", free_num_player);
//				playerNode2.Call("set_map_num", free_num_player); 
//				gameNode.Call("placeAtIndexInArray", id, playerNode2);
//				gameNode.Call("add_player_to_object_array", p.prevX, p.prevY);
//				gameNode.Call("update_player_vals");
////
////				tileState[p.prevY,p.prevX].Call("turn_on_area_exit");
////				tileState[p.currY,p.currX].Call("turn_on_area_exit");
//				//undoStack.Push(p);
//				//p = undoStack.Pop();
//				/***   END OF MOVE FUNCTION   ***/
//			}
//			else if(p.action == "SPLIT")
//			{
//				GD.Print("SPLIT <- Unwind");
//				tileState[p.prevY,p.prevX].Call("turn_off_area_exit");
//				tileState[p.currY,p.currX].Call("turn_off_area_exit");
//				KinematicBody2D playerThis = (KinematicBody2D)gameNode.Call("get_player_at_index", p.player);
//				KinematicBody2D playerSplit = (KinematicBody2D)gameNode.Call("get_player_at_index", p.player2);
//				playerSplit.Call("remove_player");
//				playerThis.Call("set_moves_left", p.currNum);
//
//				if((p.currX == collectableOnePos.x && p.currY == collectableOnePos.y && p.grabbedCollectable) ||
//					(p.currX == collectableTwoPos.x && p.currY == collectableTwoPos.y && p.grabbedCollectable) || 
//					(p.currX == collectableThreePos.x && p.currY == collectableThreePos.y && p.grabbedCollectable))
//					{
//						//CREATE COLLECTABLE
//						scoring.Call("player_added");
//						Node2D collectable = (Node2D)collectScene.Instance();
//						collectable.Scale = currScale;
//						collectable.Call("set_collect_grid", p.currX, p.currY);
//						gameNode.Call("add_to_collect_array", collectable);
//						collectable.Position = new Vector2(p.currX*textureSize+xOffset, p.currY*textureSize+yOffset);
//						gameNode.AddChild(collectable);
//
//						//CHANGE TILE STATE
//						tileState[p.prevY,p.prevX].Call("set_state", p.tile1State);
//						tileState[p.currY,p.currX].Call("set_state", 0);
//						tileState[p.prevY,p.prevX].Call("turn_on_area_exit");
//						tileState[p.currY,p.currX].Call("turn_on_area_exit");
//					}
//				else
//				{
//					//CHANGE TILE STATE
//					tileState[p.prevY,p.prevX].Call("set_state", p.tile1State);
//					tileState[p.currY,p.currX].Call("set_state", p.tile2State);
//					tileState[p.prevY,p.prevX].Call("turn_on_area_exit");
//					tileState[p.currY,p.currX].Call("turn_on_area_exit");
//				}
//			}
//		}
////		GD.Print("---PLAYERS---");
//		GD.Print("---END OF UNDO---");
//		gameNode.Call("printPlayers");
//
////		GD.Print("Stack Count -> ", undoStack.Count);
//	}
//
//	private void _on_AddButton_pressed()
//	{
//		gameNode.Call("_on_Player_multi_pressed");
//	}
//	public void player_removed()
//	{
//		scoring.Call("player_removed");
//	}
//	public void collect_removed()
//	{
//		scoring.Call("collectable_removed");
//	}
//	public void win_condition()
//	{
//		// place what happens when the player wins here
//		//call and show the "You Win" popup, unless its tutorial as that doesnt need popup
//		if (!(bool)globalNode.Call("get_isTutorial"))
//		{
//			var popup = GetParent().GetParent().GetParent().GetNode<PopupDialog>("WinPopup/PopupDialog");
//			if(popup != null && did_win == false)
//			{
//				did_win = true;
//				scoring.Call("End_timer");
//				popup.Popup_();
//				MusicNode.Call("gameWin");
//				leaderMessenger.Call("send_score", scoring.Call("get_score"), boardName);
//				GD.Print(boardName);
//			}
//		}
//	}
//	public void game_over()
//	{
//			scoring.Call("End_timer");
//			GD.Print("Game Over!?!");
//		// place a game over event here	
//	}
//
//	//from player's movement signal send another signal that theres movement to TutorialPanel - signalception
//	public void _player_moved() 
//	{
//		EmitSignal("sendIsMoved");
//	}
//
//	//TODO: get game info here
//	public int GetPlayer(int index)
//	{	
//		int x = 0;
//		Node2D piece = (Node2D)gameNode.Call("get_player_at_index", index);
//		if(piece != null)
//		{
//			x = (int)piece.Call("get_player_moves_left");
//			return x;
//		}
//		else
//			return x;
//
//	}
//	public int GetCurrentPlayer()
//	{
//		int x = 0;
//		Node2D piece = (Node2D)gameNode.Call("get_cur_player");
//		if(piece != null)
//		{
//			x = (int)piece.Call("get_player_moves_left");
//			return x;
//		}
//		else 
//			return x;
//	}
//
//
//	//TODO: For some reason, its stops calling when theres one collectible left
//	public int GetNumCollectibles()
//	{
//		int size = (int)gameNode.Call("get_collectible_array_size");
//		//GD.Print("Collectible Count: " + size.ToString());
//		return size;
//	}
//
//	public int GetNumPlayers()
//	{
//		int size = (int)gameNode.Call("get_player_array_size");
//		return size;
//	}
//	public void Pause()
//	{
//		gameNode.Call("pause_game");
//		scoring.Call("End_timer");
//	}
//	public void Play()
//	{
//		gameNode.Call("play_game");
//		scoring.Call("start_timer");
//	}
//
//	private void _on_BackToWin_pressed()
//	{
//		did_win = false;
//		win_condition();
//	}
//
//
//	public object GetTileState(int x, int y)
//	{
//		if (tileState[y,x] != null)
//		{
//		return tileState[y,x].Call("get_state");
//		}
//		return null;
//	}
//
//	public void DisableTile(int x, int y)
//	{
//		tileState[y,x].Call("turn_off_area_exit");
//	}
//	public void EnableTile(int x, int y)
//	{
//		tileState[y,x].Call("turn_on_area_exit");
//	}
//	public void SetTileState(int x, int y, object state)
//	{
//		if (tileState[y,x] != null)
//		tileState[y,x].Call("set_state", state);
//	}
//
//	public void EnablePlayer(int index)
//	{
//		gameNode.Call("enable_player", index);
//	}
//
//	public void InPlay(int index)
//	{
//		gameNode.Call("in_play", index);
//		//GD.Print("JARJARBANKS");
//	}
//
//	public void ChangeTileColor(int y, int x)
//	{
//		tileState[y,x].Call("change_tile_color");
//	}
//
//
//	public void ResetTileColor(int y, int x)
//	{
//		tileState[y,x].Call("reset_tile_color");
//	}
//
//	//special case for tiles with a collectible, its actually not the same as regular tiles
//	public void ChangeCollectTileColor(int index)
//	{
//		Node2D collect = (Node2D)gameNode.Call("get_collect_at_index", index);
//		collect.Call("change_collect_tile_color");
//	}
//
//
//}
