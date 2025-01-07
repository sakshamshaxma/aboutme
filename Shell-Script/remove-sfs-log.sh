#!/bin/bash

find /gameserver/SmartFoxServer_2X/SFS2X/logs/ -iname "smartfox*" -mtime +1 -exec rm -rf {} \;

find /gameserver/SmartFoxServer_2X/SFS2X/logs/PokerGame/GameDetails -iname "*.log.*" -mtime +1 -exec rm -rf {} \;

find /gameserver/SmartFoxServer_2X/SFS2X/logs/PokerGame/ExtensionDetails -iname "*.log.*" -mtime +1 -exec rm -rf {} \;

find /gameserver/SmartFoxServer_2X/SFS2X/logs/CommonExtension -iname "*.log.*" -mtime +1 -exec rm -rf {} \;

find /gameserver/SmartFoxServer_2X/SFS2X/logs/CommonDBDetails -iname "*.log.*" -mtime +1 -exec rm -rf {} \;

find /gameserver/SmartFoxServer_2X/SFS2X/logs/URLCaller -iname "*.log.*" -mtime +1 -exec rm -rf {} \;

find /gameserver/SmartFoxServer_2X/SFS2X/logs/MongoDBDetails -iname "*.log.*" -mtime +1 -exec rm -rf {} \;

find /gameserver/SmartFoxServer_2X/SFS2X/logs/rabbitmq -iname "*.log.*" -mtime +1 -exec rm -rf {} \;