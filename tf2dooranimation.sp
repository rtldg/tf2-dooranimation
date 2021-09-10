// you need to connect to the server with "connect ip:port matchmaking"

#pragma semicolon 1
#pragma newdecls required

#include <sdktools>

Handle gH_RestartTimer = null;
int gI_RestartTimerIteration = 0;

public Plugin myinfo =
{
	name = "TF2 Door Animation Overlay",
	author = "rtldg",
	description = "Play the door animation overlay thing with sm_dooranimation.",
	version = "1.0.0",
	url = "https://github.com/rtldg/tf2-dooranimation"
}

public void OnPluginStart()
{
	RegAdminCmd("sm_dooranimation", Command_DoorAnimation, ADMFLAG_RCON, "Shows you the door animation");
}

public Action Timer_RestartTime(Handle timer)
{
	Event event = CreateEvent("restart_timer_time");
	event.SetInt("time", gI_RestartTimerIteration);
	event.Fire();

	if (gI_RestartTimerIteration-- == 10)
	{
		gH_RestartTimer = CreateTimer(1.0, Timer_RestartTime, 0, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		return Plugin_Continue;
	}

	if (gI_RestartTimerIteration > 0)
	{
		return Plugin_Continue;
	}

	gH_RestartTimer = null;
	return Plugin_Stop;
}

void Frame_RestartTime()
{
	gI_RestartTimerIteration = 10;
	delete gH_RestartTimer;
	Timer_RestartTime(null);
}

public Action Command_DoorAnimation(int client, int args)
{
	GameRules_SetProp("m_nRoundsPlayed", 0);
	GameRules_SetProp("m_nMatchGroupType", 7);
	RequestFrame(Frame_RestartTime);
	return Plugin_Handled;
}
