#!/bin/bash
#basic script used in troubleshooting refresh rate issues on a newly connected 34" Ultrawide monitor. 

#OS: Parrot OS Mate

#Problem:
#The monitor would remain blank when using the monitor's "preferred" resolution of 3440x1440@60Hz. 
#It would retun a "no signal" error and the monitor would fall asleep

#Troubleshooting:
#connected the monitor to another machine, working fine
#booted into a second partition (in this case it was a Mac as I am using a MacPro (2013)) - All working as expected
#Connected up a second monitor while booted into Parrot Mate. could see the primary monitor attached and correct res selected, no display though
#reduced the resolution to 2560x1080@60Hz, working fine.
#tried different refresh rates and got varied levels of working from very blurry to nearly clear to black screen again
#wrote script to cycle through refresh rates.

#credit for the idea goes to Leow Kah Man and his article: https://www.leowkahman.com/2019/02/06/ultrawide-monitor-on-linux/

#Check you monitor specifications for the V-Frequency range

#usage:
#Check your current working resolution by running xrandr and alter the fallback line accordingly
#change the desired X and Y res options
#change the range in the loop to reflect the frequency range
#change the connected port in the loop (DisplayPort-1 to reflect your Monitor's connection
#run script
#cancel script when it works correctly and take note of the Modeline

#I found that 27Hz - 41 Hz worked for me, then 43,45,47Hz then nothing afterwards. 

xRes=3440
yRes=1440

#Script Start
for num in {25..99}
	do
		modeline=$(/usr/bin/cvt $xRes $yRes $num | grep Modeline | cut -d ' ' -f 2-)
		echo $modeline
		profile=$(echo $modeline | cut -c 1-17)
		echo $profile >> res.txt
		/usr/bin/xrandr --newmode $modeline
		/usr/bin/xrandr --addmode DisplayPort-1 $profile
		/usr/bin/xrandr --output DisplayPort-1 --mode $profile
		sleep 15
done

#fallback if script completes and no better res is found
/usr/bin/xrandr --output DisplayPort-1 --mode 2560x1080 --rate 99.94


#To make it permanent:
#create a new config file:
# $ sudo nano /usr/share/X11/xorg.conf.d/10-ultrawide.conf
#copy in the following and uncomment all lines. 
#replace Modeline with the appropriate line from the script
#replace Identifier, Card, Monitor, driver and Modes values as appropriate

#Section "Monitor"
# Identifier "DisplayPort-1"
# Modeline "3440x1440_30.00" 196.25 3440 3600 3952 4464 1440 1443 1453 1468 -hsync +vsync
#EndSection
#
#Section "Screen"
# Identifier "Screen0"
# Device "Card0"
# Monitor "DisplayPort-1"
# SubSection "Display"
#  Modes "3440x1440_30.00"
# EndSubSection
#EndSection
#
#Section "Device"
# Identifier "Card0"
# Driver "radeon"
#EndSection

