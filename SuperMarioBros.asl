// AutoSplitter for Super Mario Bros. v2.2 //
//                By. Giffi                //

state("nestopia", "1.51") // Nestopie 1.51 UE
{
	// timer //
	byte hundreds  : 0x0017801C, 0x4C, 0xC, 0x860;
	byte tenths    : 0x0017801C, 0x4C, 0xC, 0x861;
	byte seconds   : 0x0017801C, 0x4C, 0xC, 0x862;
	
	// game states //
	byte world    : 0x0017801C, 0x4C, 0xC, 0x7C7;
	byte level    : 0x0017801C, 0x4C, 0xC, 0x7C4;
	byte bowserhp : 0x0017801C, 0x4C, 0xC, 0x4EB;
	
	// mario states//
	byte xoffset : 	0x0017801C, 0x4C, 0xC, 0x415;
}

state("nestopia", "1.50") // Nestopie 1.50 UE
{
	// timer //
	byte hundreds  : 0x0017701C, 0x4C, 0xC, 0x860;
	byte tenths    : 0x0017701C, 0x4C, 0xC, 0x861;
	byte seconds   : 0x0017701C, 0x4C, 0xC, 0x862;
	
	// game states //
	byte world    : 0x0017701C, 0x4C, 0xC, 0x7C7;
	byte level    : 0x0017701C, 0x4C, 0xC, 0x7C4;
	byte bowserhp : 0x0017701C, 0x4C, 0xC, 0x4EB;
	
	// mario states//
	byte xoffset : 	0x0017701C, 0x4C, 0xC, 0x415;
}

state("nestopia", "1.49") // Nestopie 1.49 UE, because it was easy to add.
{
	// timer //
	byte hundreds  : 0x00171D14, 0x4C, 0xC, 0x860;
	byte tenths    : 0x00171D14, 0x4C, 0xC, 0x861;
	byte seconds   : 0x00171D14, 0x4C, 0xC, 0x862;
	
	// game states //
	byte world    : 0x00171D14, 0x4C, 0xC, 0x7C7;
	byte level    : 0x00171D14, 0x4C, 0xC, 0x7C4;
	byte bowserhp : 0x00171D14, 0x4C, 0xC, 0x4EB;
	
	// mario states//
	byte xoffset : 	0x00171D14, 0x4C, 0xC, 0x415;
}

state("nestopia", "1.40")
{
	// timer //
	byte hundreds  : 0x001B1300, 0x4C, 0x860;
	byte tenths    : 0x001B1300, 0x4C, 0x861;
	byte seconds   : 0x001B1300, 0x4C, 0x862;
	
	// game states //
	byte world    : 0x001B1300, 0x4C, 0x7C7;
	byte level    : 0x001B1300, 0x4C, 0x7C4;
	byte bowserhp : 0x001B1300, 0x4C, 0x4EB;
	
	// mario states//
	byte xoffset : 	0x001B1300, 0x4C, 0x415;
}

init 
{
	// Detect the emulator
	switch (modules.First().ModuleMemorySize)
	{
		case 1966080: //Nestopia 1.51 UE
			version = "1.51";
			print("Nestopia 1.51 UE");
			break;
		case 1953792: //Nestopia 1.50 UE
			version = "1.50";
			print("Nestopia 1.50 UE");
			break;
		case 1929216: //Nestopia 1.49 UE
			version = "1.49";
			print("Nestopia 1.49 UE");
			break;
		case 2113536: //Nestopia 1.40v
			version = "1.40";
			print("Nestopia 1.40");
			break;
		default:
			version = "1.40";
			print("Invalid Emulator: " + modules.First().ModuleMemorySize.ToString());
			break;
	}
	
	// Initalize some variables
	vars.timer				= 0;
	vars.warpzone_split   	= false;
	vars.split_on_world    	= 0;
	vars.split_on_level   	= 0; 
}

update
{
	// Timer
	vars.timer = current.hundreds * 100 + current.tenths * 10 + current.seconds;
	
}

split
{
	// New level
	if ((current.level != vars.split_on_level) || (current.world != vars.split_on_world))
	{
		//print("Cur Level: "      + current.level.ToString());
		//print("Cur World: "      + current.world.ToString());
		//print("Old Level: "      + old.level.ToString());
		//print("Old World: "      + old.world.ToString());
		//print("Split Level: "    + vars.split_on_level.ToString());
		//print("Warpzone Split: " + vars.warpzone_split.ToString());
		
		
		
		// Warpzone splitting
		if (old.level == 1 && current.level == 0)
		{
			vars.warpzone_split = true;
			return false;
		}
		if (vars.warpzone_split )
		{
			if (!(vars.timer == 400 || vars.timer == 300))
			{
				return false;
			}
			vars.warpzone_split = false;
		}
			
		
		// We've handled the splitting for this level
		vars.split_on_world = current.world;
		vars.split_on_level = current.level; 
		
		// Handle Cutscene "levels"
		if (old.level == 1)
		{
			if		(current.level == 2 && current.world == 0) // 1-2
			{
				return false;
			}
			else if	(current.level == 2 && current.world == 1) // 2-2
			{
				return false;
			}
			else if	(current.level == 2 && current.world == 3) // 4-2
			{
				return false;
			}
			else if	(current.level == 2 && current.world == 6) // 7-2
			{
				return false;
			}
		}
		
		return true;
	} // End of level change //
	
	// Castles //
	
	// 8-4 Is in 8-4 bowser is loaded and xpos is enough to hit the axe
	if (current.world == 7 && current.level == 3 && current.bowserhp != 0 && current.xoffset > 210)
	{
		return true;
	}
	
	// -3
	if (current.world == 35 && current.level == 2 && current.xoffset > 210)
	{
		return true;
	}
	
	return false;
}

start
{
	//print("Cur Level: "      + current.level.ToString());
	//print("Cur World: "      + current.world.ToString());
	//print("Timer: "  		 + vars.timer.ToString());
	if (vars.timer == 400 && current.world == 0 && current.level == 0)
	{
		// Initalize some variables
		vars.warpzone_split   	= false;
		vars.split_on_world    	= 0;
		vars.split_on_level   	= 0; 
		return true;
	}
	return false;
}
