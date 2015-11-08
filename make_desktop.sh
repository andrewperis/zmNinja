#!/bin/bash

exe() { echo "\$ $@" ; "$@" ; }

# Custom stuff I need to do for zmNinja
echo ----------------------------------------------------
echo Pliable Pixels Desktop build process
echo ----------------------------------------------------
APPVER=`cat config.xml | grep "widget id=" | sed 's/.* version=\"\([^\"]*\)\" xmlns.*/\1/'`
echo "Application version:$APPVER"

declare -a app_ports=("../zmNinja-mac.app/Contents/Resources" "../zmNinja-linux/resources" "../zmNinja-win/resources")

for i in "${app_ports[@]}"
do
if [ -d "$i" ]; then
	echo "------------------------------------------------------------------------"
	echo "Working on packaging $i"
	echo "------------------------------------------------------------------------"
	exe rm -fr $i/app
	exe mkdir $i/app
	exe cp -R www/ $i/app
	exe cp electron_js/* $i/app
	exe cd $i
	cat app/js/DataModel.js | sed "s/var zmAppVersion=\"unknown\"/var zmAppVersion=\"$APPVER\"/" > app/js/DataModel.js.tmp
	exe rm -fr app/js/DataModel.js
	exe mv app/js/DataModel.js.tmp app/js/DataModel.js
	
	
	rm -fr app.asar
#	exe asar pack app app.asar
#	exe rm -fr app
	exe cd - 
	echo "Done!"
	
else
	echo "$i does not exist, skipping"
fi
done

