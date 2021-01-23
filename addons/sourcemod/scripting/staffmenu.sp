#include	<multicolors>

#pragma		semicolon	1
#pragma		newdecls	required

public	Plugin	myinfo	=	{
	name		=	"Staff Menu List",
	author		=	"Tk /id/Teamkiller324",
	description	=	"Title says it all",
	version		=	"1.0.0",
	url			=	"https://steamcommunity.com/id/Teamkiller324"
}

public void OnPluginStart()	{
	RegConsoleCmd("sm_admins",	StaffList,	"Get the staff list");
	RegConsoleCmd("sm_staff",	StaffList,	"Get the staff list");
}

Action StaffList(int client, int args)	{
	char	info[96];
	Menu menu = new Menu(StaffListHandler);
	for (int x = 1; x < MaxClients; x++)
	{
		if(IsClientOwner(x) || IsClientAdmin(x) || IsClientModerator(x))
		{
			FormatEx(info, sizeof(info), "Staff Online: %d", x);
			menu.SetTitle(info);
		}
	}
	
	for(int i = 1; i < MaxClients; i++)
	{
		if(IsClientOwner(i))
		{
			char profile[96];
			GetClientAuthId(i, AuthId_SteamID64, profile, sizeof(profile));
			FormatEx(info,	sizeof(info),	"%N [Owner]",	i);
			menu.AddItem(profile,	info, GetEngineVersion() == Engine_CSGO ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
		}
		else if(IsClientAdmin(i))
		{
			char profile[96];
			GetClientAuthId(i, AuthId_SteamID64, profile, sizeof(profile));
			FormatEx(info,	sizeof(info),	"%N [Admin]",	i);
			menu.AddItem(profile,	info, GetEngineVersion() == Engine_CSGO ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
		}
		else if(IsClientModerator(i))
		{
			char profile[96];
			GetClientAuthId(i, AuthId_SteamID64, profile, sizeof(profile));
			FormatEx(info,	sizeof(info),	"%N [Moderator]",	i);
			menu.AddItem(profile,	info, GetEngineVersion() == Engine_CSGO ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
		}
	}
	
	menu.Display(client, 30);
	menu.ExitButton = true;
}

int StaffListHandler(Menu menu, MenuAction action, int client, int selection)	{
	switch (action)
	{
		case	MenuAction_Select:
		{
			char	info[96],
					fix[96];
			menu.GetItem(selection, info, sizeof(info));
			FormatEx(fix, sizeof(fix), "https://steamcommunity.com/profiles/%s/", info);
			if(GetEngineVersion() != Engine_CSGO)	{
				ShowMOTDPanel(client, "Steam Profile", fix, MOTDPANEL_TYPE_URL);
			}
		}
		case	MenuAction_End:	delete menu;
	}
}

stock bool IsClientOwner(int client)	{
	if(CheckCommandAccess(client,	"root",			ADMFLAG_ROOT,		false))	return true;
	return false;
}
stock bool IsClientAdmin(int client)	{
	if(CheckCommandAccess(client,	"admin",		ADMFLAG_GENERIC,	false))	return true;
	return false;
}
stock bool IsClientModerator(int client)	{
	if(CheckCommandAccess(client,	"moderator",	ADMFLAG_CUSTOM1,	false))	return true;
	return false;
}