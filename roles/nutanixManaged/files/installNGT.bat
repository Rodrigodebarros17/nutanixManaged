echo off
net use A: \\10.50.6.11\ngt Mudar@123 /u:MANSUR\agility.alcantara /PERSISTENT:YES
net use \\10.50.6.11\ngt /SAVECRED
A:\setup.exe /quiet ACCEPTEULA=yes /norestart
timeout 210
net use  A: /delete
