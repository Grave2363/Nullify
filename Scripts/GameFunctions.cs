using Godot;
using System;

public class GameFunctions : Node2D
{
	
	/*
		SCRIPT NOTES:
		This script will be used in the player's parent node that, on the player side, will access as a kind of inheritance.
		Also, these function are only performing the operations, not managing where the numbers land on the board once an operation is performed,
		neither does it take it into account the direction of movement to determine the order of operation.
		We would also need to be able to get the set max number for this board; I set this in the constructor.
		Also collisions needs to be checked against with add, merge, and multiplby 2; any behavior that has to do with another number.
		So, the parameters take in two ints, one that represents the handled number (that the user preessed to move) 
		and another number to represnt the target number, the collided upon number.
		These functions return ints, so the gameplay function needs to be able to check for the set max number and enable it as such.
		It will be the player's (or another correlated script's) job to deal with the returned number as new or changed objects.
		Note on collision: Since most of these functions can be self-handled, an alternative to declaring the collided number would just be to check for collision.
	*/

	int maxNum = 16;
	
//	public GameFunctions(int _maxNumber)
//	{
//		this.maxNum = _maxNumber;
//	}

   //splits the given number with the value by two 
   public int Split(int numToSplit)
   {
	   //split is a curious function. This can only return the result from splitting the number.
	   //further handling of how to assign the given number into two new players is within GameMovement and Player class.
	   int splitVal = 0;
	   if(numToSplit %2 == 0) //check if it's even to proceeed
	   {
		   return splitVal = numToSplit/2 ;
	   }

	   else
	   {
		   //this operation is invalid, it must be an even number. Either return -1 or throw error.
		   GD.Print("INVALID OP: MUST BE AN EVEN NUMBER");
		   return -1;
	   }       
   }

	//Adds the number by itself (or multiply by 2) to merge them into one number
   public int Merge(int numHandled, int numCollided)
   {
	   int mergeVal = 0;
		
	   if(numHandled %2 == 0 && numHandled%2 == 0) //check if it's even to proceeed
	   {
		   //This if is slightly controversial. This is checking if the numbers are the same, but if we were to omit this step
		   //it would require a change to the rules to say that regular muliplication is possible
		   //otherwise, merged number only needs to be multiplied by 2
		   if(numHandled == numCollided) 
		   {
			mergeVal = numHandled*numCollided; //multiply the number by 2

			if(mergeVal > maxNum)
			{
				//the number is to big for the board, return error or -1
					GD.Print("INVALID OP: NUMBER IS BEYOND MAX NUMBER"); 
					return -1;
			}
		   
		   } 
			return mergeVal;    
	   }

	   else
	   {
		   //this operation is invalid, it must be an even number
		   GD.Print("INVALID OP: MUST BE AN EVEN NUMBER");
		   return -1;
	   }
   }

	//Multiplies the number by 2 
   public int MultiplyBy2(int numToMuliply, int collidedTwo)
   {
	   int multiplyVal = 0;

		if(collidedTwo == 2) //make sure collided two is two
		{
			 multiplyVal = numToMuliply*collidedTwo; //muliply the number by 2
			if(multiplyVal > maxNum)
			{
				//the number is to big for the board
				GD.Print("INVALID OP: NUMBER IS BEYOND MAX NUMBER"); 
					return -1;
			}
		}
		else
		{
			//invalid op
			GD.Print("INVALID OP: MULTIPLICAtION ISNT'T BY TWO"); 
			return -1;
		}
	   

	   return multiplyVal;
   }

	//Adds two numbers together
   public int Add(int numHandled, int numCollided)
   {
	   int addVal = numHandled + numCollided; //add the two numbers together
		//check to make sure that the add number isnt greater than the max number
	   if(addVal > maxNum)
		{
			   //the number is to big for the board, return error or -1
			GD.Print("INVALID OP: NUMBER IS BEYOND MAX NUMBER");
			return -1; 
		}
		return addVal;
   }


	//this is in lieu of a maxNum constructor, but this doesnt really work that well
	
	public int GetFreeNum(int maxNum)
	{
		return maxNum;
	}

	//helper that returns the value of the passed in number via the label name
	//made it virtual in case of a need to override
   //public virtual int GetNumber(AnimatedSprite number, string valueLabel)
   //{
	  // return number.GetNode<Label>("Value").ToString().ToInt();
   //}

}
