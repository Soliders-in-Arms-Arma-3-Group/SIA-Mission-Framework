class dialogAFK
{
	idd = 3289
	class controls
	{
		class baseFrame: RscFrame
		{
			idc = 1800;
			text = "AFK Menu"; //--- ToDo: Localize;
			x = 0.372161 * safezoneW + safezoneX;
			y = 0.40284 * safezoneH + safezoneY;
			w = 0.275625 * safezoneW;
			h = 0.14 * safezoneH;
		};
		class exitAFKbutton: RscButton
		{
			idc = 1600;
			text = "Exit"; //--- ToDo: Localize;
			x = 0.42125 * safezoneW + safezoneX;
			y = 0.444 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.07 * safezoneH;
			tooltip = "Exit AFK state at current position"; //--- ToDo: Localize;
			colorBackgroundActive[] = {0,0,0,0.7};
			action = "closeDialog 2; [false]execVM 'sia_f\goAFK\exitAFK.sqf'";
		};
		class exitAFKTPbutton: RscButton
		{
			idc = 1601;
			text = "Exit & TP"; //--- ToDo: Localize;
			x = 0.545937 * safezoneW + safezoneX;
			y = 0.444 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.07 * safezoneH;
			tooltip = "Exit AFK state and teleport to squad"; //--- ToDo: Localize;
			colorBackgroundActive[] = {0,0,0,0.7};
			action = "closeDialog 2; [true]execVM 'sia_f\goAFK\exitAFK.sqf'";
		};
	};
};