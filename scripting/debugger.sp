#pragma newdecls required
#pragma semicolon 1
#include <sourcemod>
#include <sdkhooks>
#include <tf2_stocks>

bool
	  g_bTempEntDisable
	, g_bTempEntInfo
	, g_bEntInfo
	, g_bTransmitInfo
	, g_bParticleInfo
	, g_bSoundInfo;

int
	  g_iUtils_EffectDispatchTable
	, g_iUtils_ParticleEffectTable;

public Plugin myinfo = {
	name = "Entity and Sound Debugger",
	author = "JoinedSenses",
	description = "Prints sound and entity info to chat",
	version = "1.0.0"
}

char g_saEntList[][] = {
	"weapon",
	"wearable",
	"sprite",
	"projectile",
	"particle"
};

char g_bExcludedParticles[][] = {
	"waterfall"
};

public void OnPluginStart() {
	RegAdminCmd("sm_teinf", cmdTempEntInfo, ADMFLAG_ROOT);
	RegAdminCmd("sm_einf", cmdEntInfo, ADMFLAG_ROOT);
	RegAdminCmd("sm_trinf", cmdTransmitInfo, ADMFLAG_ROOT);
	RegAdminCmd("sm_pinf", cmdParticleInfo, ADMFLAG_ROOT);
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
	// AddTempEntHook("PlayerAnimEvent", TEHookTest);
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
	// AddTempEntHook("World Decal", TEHookTest);
	
	AddAmbientSoundHook(AmbientSoundHook);
	AddNormalSoundHook(NormalSoundHook);
}

public void OnMapStart() {
	g_iUtils_EffectDispatchTable = FindStringTable("EffectDispatch");
	g_iUtils_ParticleEffectTable = FindStringTable("ParticleEffectNames");
}

public Action cmdTempEntDisable(int client, int args) {
	g_bTempEntDisable = !g_bTempEntDisable;
	PrintToChat(client, "Temp entities %s", g_bTempEntDisable ? "disabled" : "enabled");
	return Plugin_Handled;
}

public Action cmdTempEntInfo(int client, int args) {
	g_bTempEntInfo = !g_bTempEntInfo;
	PrintToChatAll("Temp entity info %s", g_bTempEntInfo ? "enabled" : "disabled");
	return Plugin_Handled;
}

public Action cmdEntInfo(int client, int args) {
	g_bEntInfo = !g_bEntInfo;
	PrintToChatAll("Entity info %s", g_bEntInfo ? "enabled" : "disabled");
	return Plugin_Handled;
}

public Action cmdTransmitInfo(int client, int args) {
	g_bTransmitInfo = !g_bTransmitInfo;
	PrintToChatAll("Transmit info %s", g_bTransmitInfo ? "enabled" : "disabled");
	return Plugin_Handled;
}

public Action cmdParticleInfo(int client, int args) {
	g_bParticleInfo = !g_bParticleInfo;
	PrintToChatAll("Particle info %s", g_bParticleInfo ? "enabled" : "disabled");
	return Plugin_Handled;
}

public Action cmdSoundInfo(int client, int args) {
	g_bSoundInfo = !g_bSoundInfo;
	PrintToChatAll("Sound name %s", g_bSoundInfo ? "enabled" : "disabled");
	return Plugin_Handled;
}

public Action AmbientSoundHook(char sample[PLATFORM_MAX_PATH], int &entity, float &volume, int &level, int &pitch, float pos[3], int &flags, float &delay) {
	if (g_bSoundInfo) {
		PrintToChatAll("Ambient sound: %s from %i", sample, entity);
	}
}

public Action NormalSoundHook(int clients[64], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags) {
	if (g_bSoundInfo) {
		PrintToChatAll("Normal sound: %s", sample);
	}
}

public Action TEHookTest(const char[] te_name, const int[] Players, int numClients, float delay) {
	if (g_bTempEntInfo) {
		PrintToChatAll("Temp Ent name is %s", te_name);

		char effectname[64];

		if (StrContains(te_name, "EffectDispatch") != -1) {
			int effectindex = TE_ReadNum("m_iEffectName");
			ReadStringTable(g_iUtils_EffectDispatchTable, effectindex, effectname, sizeof(effectname));
			PrintToChatAll("[TE] Effect: %s", effectname);
		}
		else if (StrContains(te_name, "ParticleEffect") != -1) {
			int particleindex = TE_ReadNum("m_iParticleSystemIndex");
			ReadStringTable(g_iUtils_ParticleEffectTable, particleindex, effectname, sizeof(effectname));
			PrintToChatAll("[TE] Particle Name: %s Index:  %i", effectname, particleindex);
		}
	}

	if (g_bTempEntDisable) {
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public void OnEntityCreated(int entity, const char[] classname) {
	if (g_bEntInfo || g_bTransmitInfo || g_bParticleInfo) {
		PrintToChatAll("[Create] Class name from root: %s", classname);

		for (int i = 0; i <= sizeof(g_saEntList)-1; i++) {	
			if (StrContains(classname, g_saEntList[i]) != -1) {
				if (g_bEntInfo || g_bParticleInfo) {
					PrintToChatAll("[Create Ent List]Class name: %s", classname);
				}

				SDKHook(entity, SDKHook_Spawn, OnEntitySpawned);
			}
		}

		if (StrContains(classname, "info_particle") == 0) {
			PrintToChatAll("[Create Particle] particle match");

			if (g_bParticleInfo) {
				char effectname[32];	
				GetEntPropString(entity, Prop_Data, "m_iszEffectName", effectname, sizeof(effectname));
				PrintToChatAll("[Create Particle] effect: %s class: %s", effectname, classname);
			}

			SDKHook(entity, SDKHook_Spawn, OnEntitySpawned);
		}
	}
}

public void OnEntitySpawned(int entity) {
	if (g_bEntInfo || g_bTransmitInfo || g_bParticleInfo) {
		char sClassName[32];
		GetEntityClassname(entity, sClassName, sizeof(sClassName));

		PrintToChatAll("[Spawn] Class name from root: %s", sClassName);

		if (StrContains(sClassName, "info_particle") != -1) {
			if (g_bParticleInfo) {
				char effectname[32];	
				GetEntPropString(entity, Prop_Data, "m_iszEffectName", effectname, sizeof(effectname));
				PrintToChatAll("[Particlespawned] Class: %s Effect: %s", sClassName, effectname);
			}

			SDKHook(entity, SDKHook_SetTransmit, Hook_Entity_SetTransmit);
		}
		else {
			if (g_bEntInfo) {
				PrintToChatAll("entity spawned classname: %s", sClassName);
			}
			SDKHook(entity, SDKHook_SetTransmit, Hook_Entity_SetTransmit);
		}
	}
}

public Action Hook_Entity_SetTransmit(int entity, int client) {
	if (g_bTransmitInfo || g_bParticleInfo) {
		char sClassName[32];
		GetEntityClassname(entity, sClassName, sizeof(sClassName));

		if (StrContains(sClassName, "info_particle") != -1) {
			if(g_bParticleInfo) {
				char effectname[32];	
				GetEntPropString(entity, Prop_Data, "m_iszEffectName", effectname, sizeof(effectname));

				for (int i = 0; i <= sizeof(g_bExcludedParticles)-1; i++) {
					if (StrContains(effectname, g_bExcludedParticles[i]) == -1) {
						PrintToChatAll("Effect name from transmit is %s", effectname);
					}
				}
			}
		}
		else if (g_bEntInfo) {
			PrintToChatAll("Class name from transmit is %s", sClassName);
		}
	}
}