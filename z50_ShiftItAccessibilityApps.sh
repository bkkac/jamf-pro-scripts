#!/bin/sh
sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "delete from access where client='org.shiftitapp.ShiftIt';"
## This one works
sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "INSERT INTO access VALUES('kTCCServiceAccessibility','org.shiftitapp.ShiftIt',0,1,1,NULL);"
### https://github.com/fikovnik/ShiftIt/issues/110

sqlite3 /Library/Application\ Support/com.apple.TCC/Tcc.db 'SELECT * FROM access'
