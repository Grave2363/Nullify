using Godot;
using System;


public class MusicPlayer : Node
{
	//SFX DISCS
	private AudioStream addSfx = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Add.wav");
	private AudioStream backSfx1 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/BackButton_01.wav");
	private AudioStream backSfx2 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/BackButton_02.wav");
	private AudioStream ChangePlayerSfx1 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/ChangePlayer_01.wav");
	private AudioStream ChangePlayerSfx2 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/ChangePlayer_02.wav");
	private AudioStream ChangePlayerSfx3 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/ChangePlayer_03.wav");
	private AudioStream CollectSfx = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Collectable.wav");
	private AudioStream ConfirmSfx1 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Confirm_01.wav");
	private AudioStream ConfirmSfx2 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Confirm_02.wav");
	private AudioStream MultSfx = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Mult.wav");
	private AudioStream PauseSfx = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Pause.wav");
	private AudioStream PlayerDelSfx = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/PlayerDel.wav");
	private AudioStream ResetSfx1 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Reset_01.wav");
	private AudioStream ResetSfx2 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Reset_02.wav");
	private AudioStream ResetSfx3 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Reset_03.wav");
	private AudioStream SplitSfx1 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Split_01.wav");
	private AudioStream SplitSfx2 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Split_02.wav");
	private AudioStream SplitSfx3 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Split_03.wav");
	private AudioStream TileToImmSfx = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/TileToImm.wav");
	private AudioStream TileToLockedSfx = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/TileToLocked.wav");
	private AudioStream TileToUnlockSfx = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/TileToUnlock.wav");
	private AudioStream UndoSfx1 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Undo_01.wav");
	private AudioStream UndoSfx2 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Undo_02.wav");
	private AudioStream UndoSfx3 = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Undo_03.wav");
	private AudioStream WinSfx = (AudioStream)ResourceLoader.Load("res://Assets/Audio/SFX/Win.wav");
	
	//MUSIC DISCS
	private AudioStream menuMusic = (AudioStream)ResourceLoader.Load("res://Assets/Audio/MenuMusic_Glim.wav");
	private AudioStream levelMusic = (AudioStream)ResourceLoader.Load("res://Assets/Audio/spaceEXE.wav");

	//MUSIC PLAYERS
	private AudioStreamPlayer player;
	private AudioStreamPlayer sfx;
	private AudioStreamPlayer sfx2;
	private AudioStreamPlayer sfx3;
	
	
	private string MusicFile = "user://music.dat";
	private string SFXFile = "user://sfx.dat";
	private const int VOLUME = 4;
	private const int VOLUME_SFX = 5;
	private const int VOLUME_OFF = -60;
	private bool isMusicOn;
	private bool isSFXOn;
	
	
	public override void _Ready()
	{
		player = GetNode<AudioStreamPlayer>("Music");
		sfx = GetNode<AudioStreamPlayer>("Sfx");
		sfx2 = GetNode<AudioStreamPlayer>("Sfx2");
		sfx3 = GetNode<AudioStreamPlayer>("Sfx3");
		player.Stream = menuMusic;
		sfx.Stream = addSfx;
		sfx2.Stream = addSfx;
		sfx3.Stream = addSfx;
		setAudioVolumes();
	}

	public void setAudioVolumes()
	{
		File file = new File();
		if (file.FileExists(MusicFile))
		{
			var err = file.Open(MusicFile,File.ModeFlags.Read);
			if(err == Error.Ok)
			{
				isMusicOn = Convert.ToBoolean(file.Get8());
				file.Close();
			}
		}
		else
		{
			var err = file.Open(MusicFile,File.ModeFlags.Write);
			if (err == Error.Ok)
			{
				isMusicOn = true;
				file.Store8(Convert.ToByte(isMusicOn));
				file.Close();
			}
		}
		
		File file2 = new File();
		if (file2.FileExists(SFXFile))
		{
			var err = file2.Open(SFXFile, File.ModeFlags.Read);
			if(err == Error.Ok)
			{
				isSFXOn = Convert.ToBoolean(file2.Get8());
				file2.Close();
			}
		}
		else
		{
			var err = file2.Open(SFXFile, File.ModeFlags.Write);
			if (err == Error.Ok)
			{
				isSFXOn = true;
				file2.Store8(Convert.ToByte(isSFXOn));
				file2.Close();
			}
		}
		
		if(isMusicOn)
		{
			player.Set("volume_db", VOLUME);
			PlayMusic();
		}
		else
			player.Set("volume_db", VOLUME_OFF);
		
		if(isSFXOn)
		{
			sfx.Set("volume_db",  VOLUME_SFX);
			sfx2.Set("volume_db", VOLUME_SFX);
			sfx3.Set("volume_db", VOLUME_SFX);
		}
		else
		{
			sfx.Set("volume_db",  VOLUME_OFF);
			sfx2.Set("volume_db", VOLUME_OFF);
			sfx3.Set("volume_db", VOLUME_OFF);
		}
		
	}
	public void onHomeScreen()
	{
		if(player.Stream != menuMusic)
		{
		 	StopMusic(); player.Stream = menuMusic; PlayMusic(); 
		}
	}
	public void onGameHub() 
	{ 
		if(player.Stream != levelMusic)
		{
		 	StopMusic(); player.Stream = levelMusic; PlayMusic();
		}
	}
	public bool getMusicBoolean() {return isMusicOn; }
	public bool getSFXBoolean() {return isSFXOn; }
	
	
	/***   FOR EXITING FROM GAMEHUB TO HOME SCREEN   ***/
	public void tempTurnOffSFX()
	{
		sfx.Set("volume_db",  VOLUME_OFF);
		sfx2.Set("volume_db", VOLUME_OFF);
		sfx3.Set("volume_db", VOLUME_OFF);
		sfx.Stop();
		sfx2.Stop();
		sfx3.Stop();
	}
	
	public void tempTurnOnSFX()
	{
		if(isSFXOn)
		{
			sfx.Set("volume_db",  VOLUME_SFX);
			sfx2.Set("volume_db", VOLUME_SFX);
			sfx3.Set("volume_db", VOLUME_SFX);
		}
		else
		{
			sfx.Set("volume_db",  VOLUME_OFF);
			sfx2.Set("volume_db", VOLUME_OFF);
			sfx3.Set("volume_db", VOLUME_OFF);
		}
	}
	/***   FOR EXITING FROM GAMEHUB TO HOME SCREEN   ***/
	
	
	public void PlayMusic()
	{
		if (isMusicOn)
			player.Play();
		else
			player.Stop();
	}
	
	
	public void PlaySFX(int disc)
	{
		if(disc == 1)
			sfx.Play();
		else if(disc == 2)
			sfx2.Play();
		else if(disc == 3)
			sfx3.Play();
	}
	
	public void StopMusic()
	{
		player.Stop();
	}
	
	public void SwapMusicBoolean()
	{
		isMusicOn = !isMusicOn;
		File file = new File();
			var err = file.Open(MusicFile,File.ModeFlags.Write);
			if (err == Error.Ok)
			{
				file.Store8(Convert.ToByte(isMusicOn));
				file.Close();
			}
			
		if(isMusicOn)
		{
			player.Set("volume_db", VOLUME);
			PlayMusic();
		}
		else
			player.Set("volume_db", VOLUME_OFF);
	}
	
	public void SwapSFXBoolean()
	{
		isSFXOn = !isSFXOn;
		File file = new File();
			var err = file.Open(SFXFile, File.ModeFlags.Write);
			if (err == Error.Ok)
			{
				file.Store8(Convert.ToByte(isSFXOn));
				file.Close();
			}
		
		if(isSFXOn)
		{
			sfx.Set("volume_db",  VOLUME_SFX);
			sfx2.Set("volume_db", VOLUME_SFX);
			sfx3.Set("volume_db", VOLUME_SFX);
		}
		else
		{
			sfx.Set("volume_db",  VOLUME_OFF);
			sfx2.Set("volume_db", VOLUME_OFF);
			sfx3.Set("volume_db", VOLUME_OFF);
		}
	}
	
	
	public void onAddButton()
	{
		if((bool)sfx.Call("is_playing") == false)
		{
			sfx.Stream = addSfx;
			PlaySFX(1);
		}
		else if((bool)sfx2.Call("is_playing") == false)
		{
			sfx2.Stream = addSfx;
			PlaySFX(2);
		}
		else if((bool)sfx3.Call("is_playing") == false)
		{
			sfx3.Stream = addSfx;
			PlaySFX(3);
		}
	}
	public void onBackButton()
	{
		Random rnd = new Random();
		int x = rnd.Next() % 2;
		if(x == 1)
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = backSfx1;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = backSfx1;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = backSfx1;
				PlaySFX(3);
			}
		}
		else
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = backSfx2;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = backSfx2;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = backSfx2;
				PlaySFX(3);
			}
			sfx.Play();
		}

	}
	public void onChangePlayer()
	{
		Random rnd = new Random();
		int x = rnd.Next() % 3;
		if(x == 1)
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = ChangePlayerSfx1;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = ChangePlayerSfx1;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = ChangePlayerSfx1;
				PlaySFX(3);
			}
		}
		else if(x == 2)
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = ChangePlayerSfx2;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = ChangePlayerSfx2;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = ChangePlayerSfx2;
				PlaySFX(3);
			}
		}
		else
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = ChangePlayerSfx3;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = ChangePlayerSfx3;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = ChangePlayerSfx3;
				PlaySFX(3);
			}
		}
	}
	public void onCollect()
	{
		if((bool)sfx.Call("is_playing") == false)
		{
			sfx.Stream = CollectSfx;
			PlaySFX(1);
		}
		else if((bool)sfx2.Call("is_playing") == false)
		{
			sfx2.Stream = CollectSfx;
			PlaySFX(2);
		}
		else if((bool)sfx3.Call("is_playing") == false)
		{
			sfx3.Stream = CollectSfx;
			PlaySFX(3);
		}
	}
	public void onConfirm()
	{
		Random rnd = new Random();
		int x = rnd.Next() % 2;
		if(x == 1)
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = ConfirmSfx1;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = ConfirmSfx1;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = ConfirmSfx1;
				PlaySFX(3);
			}
		}
		else
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = ConfirmSfx2;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = ConfirmSfx2;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = ConfirmSfx2;
				PlaySFX(3);
			}
		}
	}
	public void onMult()
	{
		if((bool)sfx.Call("is_playing") == false)
		{
			sfx.Stream = MultSfx;
			PlaySFX(1);
		}
		else if((bool)sfx2.Call("is_playing") == false)
		{
			sfx2.Stream = MultSfx;
			PlaySFX(2);
		}
		else if((bool)sfx3.Call("is_playing") == false)
		{
			sfx3.Stream = MultSfx;
			PlaySFX(3);
		}
	}
	public void onPause()
	{
		if((bool)sfx.Call("is_playing") == false)
		{
			sfx.Stream = PauseSfx;
			PlaySFX(1);
		}
		else if((bool)sfx2.Call("is_playing") == false)
		{
			sfx2.Stream = PauseSfx;
			PlaySFX(2);
		}
		else if((bool)sfx3.Call("is_playing") == false)
		{
			sfx3.Stream = PauseSfx;
			PlaySFX(3);
		}
	}
	public void onDeletePlayer()
	{
		if((bool)sfx.Call("is_playing") == false)
		{
			sfx.Stream = PlayerDelSfx;
			PlaySFX(1);
		}
		else if((bool)sfx2.Call("is_playing") == false)
		{
			sfx2.Stream = PlayerDelSfx;
			PlaySFX(2);
		}
		else if((bool)sfx3.Call("is_playing") == false)
		{
			sfx3.Stream = PlayerDelSfx;
			PlaySFX(3);
		}
	}
	public void onReset()
	{
		Random rnd = new Random();
		int x = rnd.Next() % 3;
		if(x == 1)
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = ResetSfx1;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = ResetSfx1;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = ResetSfx1;
				PlaySFX(3);
			}
		}
		else if(x == 2)
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = ResetSfx2;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = ResetSfx2;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = ResetSfx2;
				PlaySFX(3);
			}
		}
		else
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = ResetSfx3;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = ResetSfx3;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = ResetSfx3;
				PlaySFX(3);
			}
		}
	}
	public void onSplit()
	{
		Random rnd = new Random();
		int x = rnd.Next() % 3;
		if(x == 1)
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = SplitSfx1;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = SplitSfx1;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = SplitSfx1;
				PlaySFX(3);
			}
		}
		else if(x == 2)
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = SplitSfx2;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = SplitSfx2;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = SplitSfx2;
				PlaySFX(3);
			}
		}
		else
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = SplitSfx3;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = SplitSfx3;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = SplitSfx3;
				PlaySFX(3);
			}
		}
	}
	public void onTileToImm()
	{
		if((bool)sfx.Call("is_playing") == false)
		{
			sfx.Stream = TileToImmSfx;
			PlaySFX(1);
		}
		else if((bool)sfx2.Call("is_playing") == false)
		{
			sfx2.Stream = TileToImmSfx;
			PlaySFX(2);
		}
		else if((bool)sfx3.Call("is_playing") == false)
		{
			sfx3.Stream = TileToImmSfx;
			PlaySFX(3);
		}
	}
	public void onTileToLock()
	{
		if((bool)sfx.Call("is_playing") == false)
		{
			sfx.Stream = TileToLockedSfx;
			PlaySFX(1);
		}
		else if((bool)sfx2.Call("is_playing") == false)
		{
			sfx2.Stream = TileToLockedSfx;
			PlaySFX(2);
		}
		else if((bool)sfx3.Call("is_playing") == false)
		{
			sfx3.Stream = TileToLockedSfx;
			PlaySFX(3);
		}
	}
	public void onTileToUnlock()
	{
		if((bool)sfx.Call("is_playing") == false)
		{
			sfx.Stream = TileToUnlockSfx;
			PlaySFX(1);
		}
		else if((bool)sfx2.Call("is_playing") == false)
		{
			sfx2.Stream = TileToUnlockSfx;
			PlaySFX(2);
		}
		else if((bool)sfx3.Call("is_playing") == false)
		{
			sfx3.Stream = TileToUnlockSfx;
			PlaySFX(3);
		}
	}
	public void onUndo()
	{
		Random rnd = new Random();
		int x = rnd.Next() % 3;
		if(x == 1)
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = UndoSfx1;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = UndoSfx1;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = UndoSfx1;
				PlaySFX(3);
			}
		}
		else if(x == 2)
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = UndoSfx2;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = UndoSfx2;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = UndoSfx2;
				PlaySFX(3);
			}
		}
		else
		{
			if((bool)sfx.Call("is_playing") == false)
			{
				sfx.Stream = UndoSfx3;
				PlaySFX(1);
			}
			else if((bool)sfx2.Call("is_playing") == false)
			{
				sfx2.Stream = UndoSfx3;
				PlaySFX(2);
			}
			else if((bool)sfx3.Call("is_playing") == false)
			{
				sfx3.Stream = UndoSfx3;
				PlaySFX(3);
			}
		}
	}
	public void onWin()
	{
		StopMusic();
		player.Stream = WinSfx;
		PlayMusic();
	}
}
