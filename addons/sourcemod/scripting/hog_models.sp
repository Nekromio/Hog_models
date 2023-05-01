#pragma semicolon 1
#pragma newdecls required

#include <hog_core>
#include <smartdm>
#include <sdktools_stringtables>
#include <sdktools_functions>

ConVar
	cvTimerSetModel,
	cvModels[2];

char
	sModels[2][512];

public Plugin myinfo = 
{
	name = "[Hog] Models Players/Модель игрока",
	author = "Nek.'a 2x2 | ggwp.site ",
	description = "Устанавливает модель игрока Кабану",
	version = "1.0.0",
	url = "https://ggwp.site/"
};

public void OnPluginStart()
{
	cvModels[0] = CreateConVar("sm_hog_model_t", "", "Путь к модели Кабана террориста");
	cvModels[1] = CreateConVar("sm_hog_model_ct", "", "Путь к модели Кабана спецназовца");
	cvTimerSetModel = CreateConVar("sm_hog_setmodel_time", "1.5", "Через сколько секунд будет установлен скин Кабана?");

	AutoExecConfig(true, "hog_models", "hog");
}

public void OnMapStart()
{
	char sBuffer[512];
	
	for(int i; i < 2; i++)
	{
		cvModels[i].GetString(sBuffer, sizeof(sBuffer));
		if(sBuffer[0])
		{
			sModels[i] = sBuffer;
			PrecacheModel(sBuffer);
			Downloader_AddFileToDownloadsTable(sBuffer);
		}
	}
}

public int HOG_ActiveStart(int client)
{
	CreateTimer(cvTimerSetModel.FloatValue, SetModelTimer, GetClientUserId(client));
	return 0;
}

Action SetModelTimer(Handle hTimer, int UserId)
{
	int client = GetClientOfUserId(UserId);

	if(GetClientTeam(client) == 2 && sModels[0][0])
		SetModel(client, sModels[0]);
	else if(GetClientTeam(client) == 3 && sModels[1][0])
        SetModel(client, sModels[1]);

	return Plugin_Stop;
}

void SetModel(int client, char model[512])
{
	SetEntityModel(client, model);
}