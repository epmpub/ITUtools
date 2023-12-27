#!/bin/bash

checkip(){
    myip=$(curl -s https://checkip.amazonaws.com)
    echo $myip
}

setup_dialog() {
    dialog || sudo apt install dialog -y >&/dev/null
}

showTimebox() {
    dialog --timebox "Time Now IS:" 0 50
}

# install dialog command if not install
dialog || sudo apt install dialog -y

setup_dialog

while true
do

    dialog --title "License Agreement" --clear "$@" \
        --yesno "Hi, this is a yes/no dialog box. You can use this to ask \
                 questions that have an answer of either yes or no. \
                 BTW, do you notice that long lines will be automatically \
                 wrapped around so that they can fit in the box? You can \
                 also control line breaking explicitly by inserting \
                 'backslash n' at any place you like, but in this case, \
                 auto wrap around will be disabled and you will have to \
                 control line breaking yourself." 15 61
    retval=$?


    dialog --msgbox "Return value is $(retval)" 20 50


    dialog --sleep 5  --begin 0 5  --title "INFO BOX" "$@" --infobox "Hi, this is an information box. It is
        different from a message box: it will
        not pause waiting for input after displaying
        the message. The pause here is only introduced
        by the sleep command within dialog.
        You have 4  $unit to read 信息 this..." 0 0


    dialog --ok-label "Submit" \
	  --backtitle "$backtitle" "$@" \
	  --form "Here is a possible piece of a configuration program." \
        20 50 0 \
            "Username:" 1 1	"$user" 1 10 10 0 \
            "UID:"      2 1	"$uid"  2 10  8 0 \
            "GID:"      3 1	"$gid"  3 10  8 0 \
            "HOME:"     4 1	"$home" 4 10 40 0 \
        2>&1



    dialog --buildlist  "Select a directory" 25 75 5 \
    f1 "Directory One" off \
    f2 "Directory Two" on \
    f3 "Directory Three" on \
    f4 "Directory four" on \
    f5 "Directory five" on

    dialog --msgbox "msgbox:Your Select is: $($?)" 20 50


    dialog --title "BUILDLIST DEMO" --backtitle "A user-built list" \
	--separator "|" \
	--buildlist "hello, this is a --buildlist..." 0 0 0 \
		"1" "Item number 1" "on" \
		"2" "Item number 2" "off" \
		"3" "Item number 3" "on" \
		"4" "Item number 4" "on" \
		"5" "Item number 5" "off" \
		"6" "Item number 6" "on" 2> /dev/null

    dialog --backtitle "Select common software envoriments:" \
	    --title "CHECKLIST BOX" "$@" \
        --checklist "Hi, this is a checklist box. You can use this to \n\
                    present a list of choices which can be turned on or \n\
                    off. If there are more items than can fit on the \n\
                    screen, the list will be scrolled. You can use the \n\
                    UP/DOWN arrow keys, the first letter of the choice as a \n\
                    hot key, or the number keys 1-9 to choose an option. \n\
                    Press SPACE to toggle an option on/off. \n\n\
                    Which of the following are fruits?" 40 200 10 \
                            "build-essential"  "It's an apple." off \
                            "net-tools"    "No, that's not my dog." off \
                            "neovim" "Yeah, that's juicy." off \
                            "Chicken"    "Normally not a pet." off \
                            "Cat"    "No, never put a dog and a cat together!" off \
                            "Fish"   "Cats like fish." off \
                            "Lemon"  "You know how it tastes.You know how it tastes.You know how it tastes.You know how it tastes." off \
                            "Apple"  "It's an apple." off \
                            "Dog"    "No, that's not my dog." off \
                            "Orange" "Yeah, that's juicy." off \
                            "Chicken"    "Normally not a pet." off \
                            "Cat"    "No, never put a dog and a cat together!" off \
                            "Fish"   "Cats like fish." off \
                            "Lemon"  "You know how it tastes.You know how it tastes.You know how it tastes.You know how it tastes." off \
                            "Apple"  "It's an apple." off \
                            "Dog"    "No, that's not my dog." off \
                            "Orange" "Yeah, that's juicy." off \
                            "Chicken"    "Normally not a pet." off \
                            "Cat"    "No, never put a dog and a cat together!" off \
                            "Fish"   "Cats like fish." off \
                            "Lemon"  "You know how it tastes.You know how it tastes.You know how it tastes.You know how it tastes." off \
                            "Apple"  "It's an apple." off \
                            "Dog"    "No, that's not my dog." off \
                            "Orange" "Yeah, that's juicy." off \
                            "Chicken"    "Normally not a pet." off \
                            "Cat"    "No, never put a dog and a cat together!" off \
                            "Fish"   "Cats like fish." off \
                            "Lemon"  "You know how it tastes.You know how it tastes.You know how it tastes.You know how it tastes." off  2> tempfile

    for i in $(cat tempfile);do sudo apt install -y $i;done
    rm -rf tempfile


    dialog --inputbox  "Search you package" 20 100 

    showTimebox

    dialog --msgbox "msgbox:Your IP is: $(checkip)" 20 50

    dialog --timebox  "timebox:$(checkip)" 0 50 15 00 00

    dialog --radiolist "radiolist" 10 100 5 inf item status1 inf2 item2 status2

    dialog --timebox  "timebox" 0 50 15 00 00

    dialog --checklist "checklist" 50 100 100 tag1 china status1 tag2 usa statu2 tag3 jpn statu3

    dialog --cr-wrap \
	--title "INPUT YOUR NAME:" --clear \
        --inputbox "$@" \
        "Hi, this is an input dialog box.Try entering your name below:" \
        0 0  $(hostname)

    # Item don't allow space,ie. WNIN NT
    dialog --clear --title "MENU BOX" "$@" \
        --menu "Hi, this is a menu box. You can use this to present a list of choices for the user to choose. If there are more items than can fit on the screen, the menu will be scrolled. You can use the UP/DOWN arrow keys, the first letter of the choice as a hot key, or the number keys 1-9 to choose an option.\n\n

                        Choose the OS you like:" 40 100 30 \
                        "Linux"  "The Great Unix Clone for 386/486" \
                        "NetBSD" "Another free Unix Clone for 386/486" \
                        "OS/2" "IBM OS/2" \
                        "WIN_NT" "Microsoft Windows NT" \
                        "PC-DOS" "IBM PC DOS" \
                        "MS-DOS" "Microsoft DOS" \
                        "Linux"  "The Great Unix Clone for 386/486" \
                        "NetBSD" "Another free Unix Clone for 386/486" \
                        "OS/2" "IBM OS/2" \
                        "WIN_NT NT" "Microsoft Windows NT" \
                        "PC-DOS" "IBM PC DOS" \
                        "MS-DOS" "Microsoft DOS" \
                        "Linux"  "The Great Unix Clone for 386/486" \
                        "NetBSD" "Another free Unix Clone for 386/486" \
                        "OS/2" "IBM OS/2" \
                        "WIN_NT NT" "Microsoft Windows NT" \
                        "PC-DOS" "IBM PC DOS" \
                        "MS-DOS" "Microsoft DOS" \
                        "Linux"  "The Great Unix Clone for 386/486" \
                        "NetBSD" "Another free Unix Clone for 386/486" \
                        "OS/2" "IBM OS/2" \
                        "WIN_NT NT" "Microsoft Windows NT" \
                        "PC-DOS" "IBM PC DOS" \
                        "MS-DOS" "Microsoft DOS" 2> tempfile

    foo() { 
        dialog --backtitle "Select common software envoriments:" \
	    --title "CHECKLIST BOX" "$@" \
        --checklist "Hi, this is a checklist box. You can use this to \n\
                    present a list of choices which can be turned on or \n\
                    off. If there are more items than can fit on the \n\
                    screen, the list will be scrolled. You can use the \n\
                    UP/DOWN arrow keys, the first letter of the choice as a \n\
                    hot key, or the number keys 1-9 to choose an option. \n\
                    Press SPACE to toggle an option on/off. \n\n\
                    Which of the following are fruits?" 40 200 10 \
                            "build-essential"  "It's an apple." off \
                            "net-tools"    "No, that's not my dog." off \
                            "neovim" "Yeah, that's juicy." off \
                            "Chicken"    "Normally not a pet." off \
                            "Cat"    "No, never put a dog and a cat together!" off \
                            "Fish"   "Cats like fish." off \
                            "Lemon"  "You know how it tastes.You know how it tastes.You know how it tastes.You know how it tastes." off \
                            "Apple"  "It's an apple." off \
                            "Dog"    "No, that's not my dog." off \
                            "Orange" "Yeah, that's juicy." off \
                            "Chicken"    "Normally not a pet." off \
                            "Cat"    "No, never put a dog and a cat together!" off \
                            "Fish"   "Cats like fish." off \
                            "Lemon"  "You know how it tastes.You know how it tastes.You know how it tastes.You know how it tastes." off \
                            "Apple"  "It's an apple." off \
                            "Dog"    "No, that's not my dog." off \
                            "Orange" "Yeah, that's juicy." off \
                            "Chicken"    "Normally not a pet." off \
                            "Cat"    "No, never put a dog and a cat together!" off \
                            "Fish"   "Cats like fish." off \
                            "Lemon"  "You know how it tastes.You know how it tastes.You know how it tastes.You know how it tastes." off \
                            "Apple"  "It's an apple." off \
                            "Dog"    "No, that's not my dog." off \
                            "Orange" "Yeah, that's juicy." off \
                            "Chicken"    "Normally not a pet." off \
                            "Cat"    "No, never put a dog and a cat together!" off \
                            "Fish"   "Cats like fish." off \
                            "Lemon"  "You know how it tastes.You know how it tastes.You know how it tastes.You know how it tastes." off  2> tempfile
     }
    for i in $(cat tempfile);do foo && rm -rf tempfile;done



done
