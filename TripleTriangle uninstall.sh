#!/bin/sh
# WIll Pierce
# 20161027
echo "Running script TripleTriangle uninstall"
echo
echo "checking for TripleTriangle folder . . ."
# Remove / uninstall the old TripleTriangle stuff from InDesign 2015 before an update / change.
if [ -d /Applications/Adobe\ InDesign\ CC\ 2015/Plug-Ins/TripleTriangle ]; then
	echo "TripleTriangle folder found, removing. . ."
	rm -R /Applications/Adobe\ InDesign\ CC\ 2015/Plug-Ins/TripleTriangle
else 
	echo "TripleTriangle folder not found."
fi
echo
# # Dont forget the fonts
if [ -f /Applications/Adobe\ InDesign\ CC\ 2015/Fonts/DO_NOT_PUT_IN_SUITECASE_READ_THIS.txt ]; then
	echo "DO_NOT_PUT_IN_SUITECASE_READ_THIS.txt found removing. . ."
	rm /Applications/Adobe\ InDesign\ CC\ 2015/Fonts/DO_NOT_PUT_IN_SUITECASE_READ_THIS.txt 
else 
	echo "DO_NOT_PUT_IN_SUITECASE_READ_THIS.txt not found."
fi
echo
if [ -f /Applications/Adobe\ InDesign\ CC\ 2015/Fonts/PUT_IN_INDESIGN_FONTS_FOLDER.txt ]; then
	echo "PUT_IN_INDESIGN_FONTS_FOLDER.txt found, removing. . ."
	rm /Applications/Adobe\ InDesign\ CC\ 2015/Fonts/PUT_IN_INDESIGN_FONTS_FOLDER.txt
else echo "PUT_IN_INDESIGN_FONTS_FOLDER.txt not found."
fi
echo
if [ -f /Applications/Adobe\ InDesign\ CC\ 2015/Fonts/TTSlu.otf ]; then
	echo "TTSlu.otf found removing. . ."
	rm /Applications/Adobe\ InDesign\ CC\ 2015/Fonts/TTSlu.otf
else echo "TTSlu.otf not found."
fi
echo
if [ -f /Applications/Adobe\ InDesign\ CC\ 2015/Fonts/TTSluBol.otf ]; then
	echo "TTSluBol.otf found removing. . ."
	rm /Applications/Adobe\ InDesign\ CC\ 2015/Fonts/TTSluBol.otf
else echo "TTSluBol.otf not found."
fi
echo
if [ -f /Applications/Adobe\ InDesign\ CC\ 2015/Fonts/TTSlugFontLicense.txt ]; then
	echo "TTSlugFontLicense.txt found, removing. . ."
	rm /Applications/Adobe\ InDesign\ CC\ 2015/Fonts/TTSlugFontLicense.txt 
else echo "TTSlugFontLicense.txt not found."
fi
echo 
echo "End script TripleTriangle uninstall. . ."
exit 0