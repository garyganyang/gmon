#!/bin/bash
#blue header
headerFormatter="\033[1;4;34;40m| %14s | %11s | %9s | %-8s | %9s | %9s | %8s |\033[0m\n"
printf "$headerFormatter" "Date/Time" "ESTABLISHED" "TIMEWAIT" "CLOSE_WAIT" "FIN_WAIT1" "FIN_WAIT2" "SYN_RECV"
#blue
splitter="\033[1;34;40m|\033[0m"
white14s="\033[1;37;40m%14s\033[0m"
green11s="\033[1;32;40m%11s\033[0m"
yellow10s="\033[1;33;40m%10s\033[0m"
yellow9s="\033[1;33;40m%9s\033[0m"
red9s="\033[1;31;40m%9s\033[0m"
litgreen8s="\033[1;36;40m%8s\033[0m"
bodyFormatter="$splitter $white14s $splitter $green11s $splitter $yellow9s $splitter $yellow10s $splitter $red9s $splitter $red9s $splitter $litgreen8s $splitter\n"
printTitle=0

while true
do
        if [ $printTitle = 55 ]; then
                        printf "$headerFormatter" "Date/Time" "ESTABLISHED" "TIMEWAIT" "CLOSE_WAIT" "FIN_WAIT1" "FIN_WAIT2" "SYN_RECV"
                        printTitle=0
        fi

        dateTime=$(date "+%m-%d %T")
        var=$(netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}')
        estimate=$(echo $var | awk -F"ESTABLISHED " '{print $2}'|awk -F" " '{print $1}')
        if [ -z "$estimate" ];then
                estimate=0
        fi

        timeWait=$(echo $var | awk -F"TIME_WAIT " '{print $2}'|awk -F" " '{print $1}')
        if [ -z "$timeWait" ];then
                timeWait=0
        fi

        closeWait=$(echo $var | awk -F"CLOSE_WAIT " '{print $2}'|awk -F" " '{print $1}')
        if [ -z "$closeWait" ];then
                closeWait=0
        fi

        fin1=$(echo $var | awk -F"FIN_WAIT1 " '{print $2}'|awk -F" " '{print $1}')
        if [ -z "$fin1" ];then
                fin1=0
        fi

        fin2=$(echo $var | awk -F"FIN_WAIT2 " '{print $2}'|awk -F" " '{print $1}')
        if [ -z "$fin2" ];then
                fin2=0
        fi

        syn=$(echo $var  | awk -F"SYN_RECV " '{print $2}' |awk -F" " '{print $1}')
        if [ -z "$syn" ];then
                syn=0
        fi

        printf "$bodyFormatter" "$dateTime" "$estimate" "$timeWait" "$closeWait" "$fin1" "$fin2" "$syn"

        if [ -z "$1" ];then
                frq=1
        else
                frq=$1
        fi

        ((printTitle++))
        sleep $frq
done
