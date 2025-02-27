@echo off
set JAVA_HOME=C:\Program Files\Java\jdk-17
set PATH=%JAVA_HOME%\bin;%PATH%
keytool -genkey -v -keystore D:/developer/mobile/Hitachi/hitachi/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias LineElement
pause
