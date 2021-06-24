using Godot;
using System;
using System.Collections.Generic;

public class LevelEditor : Node2D
{
    private int[,] level;
    private Node globalNode;

    private Node changeScenesNode;
    private Node MusicNode;
    private int maxNum = 7;
    private int freeNumVar = 0;
    private bool isEntering = false;

    private RichTextLabel description;

    public override void _Ready()
    {
        globalNode = GetNode("/root/Global");
        changeScenesNode = GetNode("/root/ChangeScenes");

        if ((int)globalNode.Call("get_grid") == 5)
        {
            maxNum = 7;
            freeNumVar = 17;
        }
        if ((int)globalNode.Call("get_grid") == 6)
        {
            maxNum = 8;
            freeNumVar = 33;
        }
        if ((int)globalNode.Call("get_grid") == 8)
        {
            maxNum = 10;
            freeNumVar = 65;
        }

        //NOTE: for the record, in viewport is still displayed the e's but this will override that
        for (int i = 0; i < (int)GetNode<Control>("Container").Call("get_child_count"); ++i)
        {
            LineEdit l = (LineEdit)GetNode<Control>("Container").GetChild(i);
            l.Set("placeholder_text", "f");
        }

        level = new int[maxNum, maxNum];

        description = GetNode<RichTextLabel>("UI/Panel/Discription/Label");
        description.BbcodeText = "[center]Enter a number or symbol for what you want to appear at the corresponding tile position.\nNumbers cannot be larger than the grid's Free Number ([b]" + globalNode.Call("get_max_val").ToString() + "[/b])\n[b]f[/b] -> represents a [b]Free[/b] tile\n[b]l[/b] -> represents a [b]Locked[/b] tile\n[b]i[/b] -> represents an [b]Imminent[/b] tile\n[b]d[/b] -> represents a [b]Deleted[/b] tile\n[b]s[/b] -> represents a [b]Star[/b] tile\n[b]#[/b] -> represents a [b]Random[/b] number[center]";
    }

    private void _on_BeginButton_pressed()
    {
        for (int y = 0; y < maxNum; ++y)
            for (int x = 0; x < maxNum; ++x)
            {
                if (x == 0 || y == 0 || x == maxNum - 1 || y == maxNum - 1)
                    level[y, x] = 80;
                if (level[y, x] == 0)
                    level[y, x] = 90;
            }
        int playerCount = 0;
        for (int y = 0; y < maxNum; ++y)
            for (int x = 0; x < maxNum; ++x)
            {
                if (!(level[y, x] > 64))
                {
                    playerCount++;
                    break;
                }
            }
        if (playerCount == 0)
        {
            Random rnd = new Random();
            playerCount = rnd.Next() % (maxNum - 2);
            level[playerCount, playerCount] = playerCount;
        }
        GameBoard.currBoard = level;
        GD.Print(level[3, 3]);
        changeScenesNode.Call("change_scene", "res://Scenes/UI/UI_GameHub.tscn", "Fade");
    }

    private void _on_Num_1x1_text_changed(String new_text) { convertAtPos(1, 1, new_text); }
    private void _on_Num_1x2_text_changed(String new_text) { convertAtPos(1, 2, new_text); }
    private void _on_Num_1x3_text_changed(String new_text) { convertAtPos(1, 3, new_text); }
    private void _on_Num_1x4_text_changed(String new_text) { convertAtPos(1, 4, new_text); }
    private void _on_Num_1x5_text_changed(String new_text) { convertAtPos(1, 5, new_text); }
    private void _on_Num_1x6_text_changed(String new_text) { convertAtPos(1, 6, new_text); }
    private void _on_Num_1x7_text_changed(String new_text) { convertAtPos(1, 7, new_text); }
    private void _on_Num_1x8_text_changed(String new_text) { convertAtPos(1, 8, new_text); }
    private void _on_Num_2x1_text_changed(String new_text) { convertAtPos(2, 1, new_text); }
    private void _on_Num_2x2_text_changed(String new_text) { convertAtPos(2, 2, new_text); }
    private void _on_Num_2x3_text_changed(String new_text) { convertAtPos(2, 3, new_text); }
    private void _on_Num_2x4_text_changed(String new_text) { convertAtPos(2, 4, new_text); }
    private void _on_Num_2x5_text_changed(String new_text) { convertAtPos(2, 5, new_text); }
    private void _on_Num_2x6_text_changed(String new_text) { convertAtPos(2, 6, new_text); }
    private void _on_Num_2x7_text_changed(String new_text) { convertAtPos(2, 7, new_text); }
    private void _on_Num_2x8_text_changed(String new_text) { convertAtPos(2, 8, new_text); }
    private void _on_Num_3x1_text_changed(String new_text) { convertAtPos(3, 1, new_text); }
    private void _on_Num_3x2_text_changed(String new_text) { convertAtPos(3, 2, new_text); }
    private void _on_Num_3x3_text_changed(String new_text) { convertAtPos(3, 3, new_text); }
    private void _on_Num_3x4_text_changed(String new_text) { convertAtPos(3, 4, new_text); }
    private void _on_Num_3x5_text_changed(String new_text) { convertAtPos(3, 5, new_text); }
    private void _on_Num_3x6_text_changed(String new_text) { convertAtPos(3, 6, new_text); }
    private void _on_Num_3x7_text_changed(String new_text) { convertAtPos(3, 7, new_text); }
    private void _on_Num_3x8_text_changed(String new_text) { convertAtPos(3, 8, new_text); }
    private void _on_Num_4x1_text_changed(String new_text) { convertAtPos(4, 1, new_text); }
    private void _on_Num_4x2_text_changed(String new_text) { convertAtPos(4, 2, new_text); }
    private void _on_Num_4x3_text_changed(String new_text) { convertAtPos(4, 3, new_text); }
    private void _on_Num_4x4_text_changed(String new_text) { convertAtPos(4, 4, new_text); }
    private void _on_Num_4x5_text_changed(String new_text) { convertAtPos(4, 5, new_text); }
    private void _on_Num_4x6_text_changed(String new_text) { convertAtPos(4, 6, new_text); }
    private void _on_Num_4x7_text_changed(String new_text) { convertAtPos(4, 7, new_text); }
    private void _on_Num_4x8_text_changed(String new_text) { convertAtPos(4, 8, new_text); }
    private void _on_Num_5x1_text_changed(String new_text) { convertAtPos(5, 1, new_text); }
    private void _on_Num_5x2_text_changed(String new_text) { convertAtPos(5, 2, new_text); }
    private void _on_Num_5x3_text_changed(String new_text) { convertAtPos(5, 3, new_text); }
    private void _on_Num_5x4_text_changed(String new_text) { convertAtPos(5, 4, new_text); }
    private void _on_Num_5x5_text_changed(String new_text) { convertAtPos(5, 5, new_text); }
    private void _on_Num_5x6_text_changed(String new_text) { convertAtPos(5, 6, new_text); }
    private void _on_Num_5x7_text_changed(String new_text) { convertAtPos(5, 7, new_text); }
    private void _on_Num_5x8_text_changed(String new_text) { convertAtPos(5, 8, new_text); }
    private void _on_Num_6x1_text_changed(String new_text) { convertAtPos(6, 1, new_text); }
    private void _on_Num_6x2_text_changed(String new_text) { convertAtPos(6, 2, new_text); }
    private void _on_Num_6x3_text_changed(String new_text) { convertAtPos(6, 3, new_text); }
    private void _on_Num_6x4_text_changed(String new_text) { convertAtPos(6, 4, new_text); }
    private void _on_Num_6x5_text_changed(String new_text) { convertAtPos(6, 5, new_text); }
    private void _on_Num_6x6_text_changed(String new_text) { convertAtPos(6, 6, new_text); }
    private void _on_Num_6x7_text_changed(String new_text) { convertAtPos(6, 7, new_text); }
    private void _on_Num_6x8_text_changed(String new_text) { convertAtPos(6, 8, new_text); }
    private void _on_Num_7x1_text_changed(String new_text) { convertAtPos(7, 1, new_text); }
    private void _on_Num_7x2_text_changed(String new_text) { convertAtPos(7, 2, new_text); }
    private void _on_Num_7x3_text_changed(String new_text) { convertAtPos(7, 3, new_text); }
    private void _on_Num_7x4_text_changed(String new_text) { convertAtPos(7, 4, new_text); }
    private void _on_Num_7x5_text_changed(String new_text) { convertAtPos(7, 5, new_text); }
    private void _on_Num_7x6_text_changed(String new_text) { convertAtPos(7, 6, new_text); }
    private void _on_Num_7x7_text_changed(String new_text) { convertAtPos(7, 7, new_text); }
    private void _on_Num_7x8_text_changed(String new_text) { convertAtPos(7, 8, new_text); }
    private void _on_Num_8x1_text_changed(String new_text) { convertAtPos(8, 1, new_text); }
    private void _on_Num_8x2_text_changed(String new_text) { convertAtPos(8, 2, new_text); }
    private void _on_Num_8x3_text_changed(String new_text) { convertAtPos(8, 3, new_text); }
    private void _on_Num_8x4_text_changed(String new_text) { convertAtPos(8, 4, new_text); }
    private void _on_Num_8x5_text_changed(String new_text) { convertAtPos(8, 5, new_text); }
    private void _on_Num_8x6_text_changed(String new_text) { convertAtPos(8, 6, new_text); }
    private void _on_Num_8x7_text_changed(String new_text) { convertAtPos(8, 7, new_text); }
    private void _on_Num_8x8_text_changed(String new_text) { convertAtPos(8, 8, new_text); }

    private void _on_BackButton_pressed()
    {
        MusicNode = GetNode("/root/MusicPlayer");
        MusicNode.Call("onBackButton");

        changeScenesNode.Call("change_scene", "res://Scenes/UI/LevelEditor_ModeSelect.tscn", "Fade");

    }


    private void convertAtPos(int y, int x, String new_text)
    {
        //GD.Print("HERE!!");
        /*** ADD CODE TO DISABLE ALL PLACE HOLDERS TEXT  **/
        if (!isEntering)
        {
            for (int i = 0; i < (int)GetNode<Control>("Container").Call("get_child_count"); ++i)
            {
                LineEdit l = (LineEdit)GetNode<Control>("Container").GetChild(i);
                l.Set("placeholder_text", "");
            }
            isEntering = true;
        }
        /*** END OF CODE TO DISABLE ALL PLACE HOLDERS TEXT  **/

        if (new_text != String.Empty)
        {

            if (new_text == "F" || new_text == "f")
                level[y, x] = 90;
            else if (new_text == "L" || new_text == "l")
                level[y, x] = 100;
            else if (new_text == "I" || new_text == "i")
                level[y, x] = 95;
            else if (new_text == "D" || new_text == "d")
                level[y, x] = 80;
            else if (new_text == "S" || new_text == "s")
                level[y, x] = 70;
            else if (new_text == "#")
            {
                Random rnd = new Random();
                level[y, x] = rnd.Next() % (maxNum - 2);
            }
            else if (Int32.TryParse(new_text, out int val) && val < freeNumVar && val > 0)
                level[y, x] = val;
            else
                level[y, x] = 90;
        }
        else
            level[y, x] = 90;
    }
}
