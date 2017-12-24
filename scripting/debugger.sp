#pragma semicolon 1
#include <sourcemod>
#include <sdkhooks>
#include <tf2_stocks>

#define PLUGIN_VERSION  "1.0.0"

new bool:g_bTempEntDisable;
new bool:g_bTempEntInfo;
new bool:g_bEntInfo;
new bool:g_bTransmitInfo;
new bool:g_bSoundInfo;

public Plugin:myinfo = 
{
	name = "Debugger",
	author = "JoinedSenses",
	description = "Prints sound and entity info to chat",
	version = PLUGIN_VERSION
}
new String:g_saEntList[][] = {
	"weapon",
	"sprite"
};

public OnPluginStart(){
	RegAdminCmd("sm_teinf", cmdTempEntInfo, ADMFLAG_ROOT);
	RegAdminCmd("sm_einf", cmdEntInfo, ADMFLAG_ROOT);
	RegAdminCmd("sm_trinf", cmdTransmitInfo, ADMFLAG_ROOT);
	RegAdminCmd("sm_sinf", cmdSoundInfo, ADMFLAG_ROOT);
	RegAdminCmd("sm_tedisable", cmdTempEntDisable, ADMFLAG_ROOT);

	AddTempEntHook("Armor Ricochet", TEHookTest);
	AddTempEntHook("BeamEntPoint", TEHookTest);
	AddTempEntHook("BeamEnts", TEHookTest);
	AddTempEntHook("BeamFollow", TEHookTest);
	AddTempEntHook("BeamLaser", TEHookTest);
	AddTempEntHook("BeamPoints", TEHookTest);
	AddTempEntHook("BeamRing", TEHookTest);
	AddTempEntHook("BeamRingPoint", TEHookTest);
	AddTempEntHook("BeamSpline", TEHookTest);
	AddTempEntHook("Blood Sprite", TEHookTest);
	AddTempEntHook("Blood Stream", TEHookTest);
	AddTempEntHook("breakmodel", TEHookTest);
	AddTempEntHook("BSP Decal", TEHookTest);
	AddTempEntHook("Bubbles", TEHookTest);
	AddTempEntHook("Bubble Trail", TEHookTest);
	AddTempEntHook("Client Projectile", TEHookTest);
	AddTempEntHook("Dust", TEHookTest);
	AddTempEntHook("Dynamic Light", TEHookTest);
	AddTempEntHook("EffectDispatch", TEHookTest);
	AddTempEntHook("Energy Splash", TEHookTest);
	AddTempEntHook("Entity Decal", TEHookTest);
	AddTempEntHook("Explosion", TEHookTest);
	AddTempEntHook("Fire Bullets", TEHookTest);
	AddTempEntHook("Fizz", TEHookTest);
	AddTempEntHook("Footprint Decal", TEHookTest);
	AddTempEntHook("GaussExplosion", TEHookTest);
	AddTempEntHook("GlowSprite", TEHookTest);
	AddTempEntHook("Impact", TEHookTest);
	AddTempEntHook("KillPlayerAttachments", TEHookTest);
	AddTempEntHook("Large Funnel", TEHookTest);
	AddTempEntHook("Metal Sparks", TEHookTest);
	AddTempEntHook("physicsprop", TEHookTest);
	AddTempEntHook("PlayerAnimEvent", TEHookTest);
	AddTempEntHook("Player Decal", TEHookTest);
	AddTempEntHook("Projected Decal", TEHookTest);
	AddTempEntHook("Show Line", TEHookTest);
	AddTempEntHook("Smoke", TEHookTest);
	AddTempEntHook("Sparks", TEHookTest);
	AddTempEntHook("Sprite", TEHookTest);
	AddTempEntHook("Surface Shatter", TEHookTest);
	AddTempEntHook("TFBlood", TEHookTest);
	AddTempEntHook("TFExplosion", TEHookTest);
	AddTempEntHook("TFParticleEffect", TEHookTest);
	AddTempEntHook("World Decal", TEHookTest);
	
	AddAmbientSoundHook(AmbientSHook:AmbientSoundHook);
	AddNormalSoundHook(NormalSHook:NormalSoundHook);

}
public Action:cmdTempEntDisable(client, args){
	g_bTempEntDisable = !g_bTempEntDisable;
	if (g_bTempEntDisable){
		PrintToChatAll("Temp entities disabled");
	}
	else{
		PrintToChatAll("Temp entities enabled");
	}
}
public Action:cmdTempEntInfo(client, args){
	g_bTempEntInfo = !g_bTempEntInfo;
	if (g_bTempEntInfo){
		PrintToChatAll("Temp entity info enabled");
	}
	else{
		PrintToChatAll("Temp entity info disabled");
	}
}
public Action:cmdEntInfo(client, args){
	g_bEntInfo = !g_bEntInfo;
	if (g_bEntInfo){
		PrintToChatAll("Entity info enabled");
	}
	else{
		PrintToChatAll("Entity info disabled");
	}
}
public Action:cmdTransmitInfo(client, args){
	g_bTransmitInfo = !g_bTransmitInfo;
	if (g_bTransmitInfo){
		PrintToChatAll("Transmit info enabled");
	}
	else{
		PrintToChatAll("Transmit info disabled");
	}
}
public Action:cmdSoundInfo(client, args){
	g_bSoundInfo = !g_bSoundInfo;
	if (g_bSoundInfo){
		PrintToChatAll("Sound name enabled");
	}
	else{
		PrintToChatAll("Sound name disabled");
	}
}
public Action:AmbientSoundHook(clients[64], &numClients, String:sample[PLATFORM_MAX_PATH], &entity, &channel, &Float:volume, &level, &pitch, &flags){
	if (g_bSoundInfo){
		PrintToChatAll("Ambient sound is %s", sample);
	}
}
public Action:NormalSoundHook(clients[64], &numClients, String:sample[PLATFORM_MAX_PATH], &entity, &channel, &Float:volume, &level, &pitch, &flags){
	if (g_bSoundInfo){
		PrintToChatAll("Normal sound is %s", sample);
	}
}
public Action:TEHookTest(const String:te_name[], const Players[], numClients, Float:delay){
	if (g_bTempEntInfo){
		PrintToChatAll("Temp Ent name is %s", te_name);
	}
	if (g_bTempEntDisable){
		return Plugin_Handled;
	}
	return Plugin_Continue;
}
public OnEntityCreated(entity, const String:classname[]){
	if (g_bEntInfo || g_bTransmitInfo){
		PrintToChatAll("Class name from root entcreate is %s", classname);

		for (int i = 0; i<=sizeof(g_saEntList)-1; i++){	
			if (StrContains(classname, g_saEntList[i], false) != -1){
				if (g_bEntInfo){
					PrintToChatAll("Class name from entcreate is %s", classname);
				}
				SDKHook(entity, SDKHook_Spawn, OnParticleSpawned);
			}
		}
		if (StrContains(classname, "info_particle", false) != -1){
			decl String:effectname[32];	
			GetEntPropString(entity, Prop_Data, "m_iszEffectName", effectname, sizeof(effectname));
			if (g_bEntInfo){
				PrintToChatAll("effect name from entcreate is %s", effectname);
				PrintToChatAll("Class name from entcreate is %s", classname);
			}
			SDKHook(entity, SDKHook_Spawn, OnParticleSpawned);
		}
	}
}
public OnParticleSpawned(entity){
	if (g_bEntInfo || g_bTransmitInfo){
		decl String:sClassName[32];
		GetEntityClassname(entity, sClassName, sizeof(sClassName));
		if (StrContains(sClassName, "info_particle", false) != -1){
			decl String:effectname[32];	
			GetEntPropString(entity, Prop_Data, "m_iszEffectName", effectname, sizeof(effectname));
			if (g_bEntInfo){
				PrintToChatAll("Class name from particlespawned is %s", sClassName);
				PrintToChatAll("Effect name from particlespawned is %s", effectname);
			}
			SDKHook(entity, SDKHook_SetTransmit, Hook_Particle_SetTransmit);
		}
		else{
			if (g_bEntInfo){
				PrintToChatAll("Class name from particlespawned is %s", sClassName);
			}
			SDKHook(entity, SDKHook_SetTransmit, Hook_Particle_SetTransmit);
		}
	}
}
public Action:Hook_Particle_SetTransmit(entity, client){
	if (g_bTransmitInfo){
		decl String:sClassName[32];
		GetEntityClassname(entity, sClassName, sizeof(sClassName));
		if (StrContains(sClassName, "info_particle", false) != -1){
			decl String:effectname[32];	
			GetEntPropString(entity, Prop_Data, "m_iszEffectName", effectname, sizeof(effectname));
			PrintToChatAll("Effect name from transmit is %s", effectname);
		}
		else{
			if (g_bEntInfo){
				PrintToChatAll("Class name from transmit is %s", sClassName);
			}
		}
	}
}