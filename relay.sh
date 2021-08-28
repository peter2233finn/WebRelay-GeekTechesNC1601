ip="192.168.1.4"
portDir="30000"

function compileMode(){
clear

echo "Compile mode:"
echo "s     = sleep WORKING"
echo "n o/f = turn on/off"
echo "e     = execute WORKING"
echo "c     = cancel WORKING"

function execute(){
	clear
        printf "Executing:\n\n"
        IFS=',' read -r -a cmdArr <<< "$*"
        x=1

        for i in ${cmdArr[@]}; do
                echo "$x $i" | tr "-" " " | sed 's/doAction/Set/g'
                ((x++))
        done

        x=0
        printf "Completed:\n"

        for i in ${cmdArr[@]}; do
                printf "\r\r\r\r\r"
		cmd=$(echo "$i" | tr "-" " ")
                $cmd
                ((x++))
                printf "...$x"
        done
	printf "\n"
}
function preCompile(){
	execute $(echo "$@"|tr "-" " "|tr "," ";" | sed 's/do;/do /g'|sh |tr " " "-"|tr "\n" ",")
}
function halt(){
function doSleep(){
i=0
while [[ $i -le $1 ]]; do
#for i in {0..$1}; do
        printf "$i out of $1 sec    "
        sleep 1
        printf "\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r"
        ((i+=1))
done
}

if [[ "$1" == *"m" ]]; then
	doSleep $((${1::-1}*60))
elif [[ "$1" == *"h" ]]; then
	doSleep $((${1::-1}*60*60))
else
	doSleep $1
fi
}

comp=""
while true; do
        read zzz

        # cancel
        if [[ "$zzz" == "c" ]]; then
                break
        elif [[ "$zzz" == "ef" ]]; then
		comp=$comp"done,"
        elif [[ "$zzz" == "f"* ]]; then
		loops=${zzz#?}
		comp=$comp"for-i-in-{1..$loops};-do,"
        elif [[ "$zzz" == "e" ]]; then
                preCompile "$comp"
		comp=""
		break

# this will execute during sleep due to number
        elif [[ $zzz =~ [0-9] ]] && [[ "$zzz" != *"s"* ]]; then
                comp=$comp"echo-doAction-$zzz,"

        elif [[ "$zzz" == *"s"* ]]; then
                comp=$comp"echo-halt-${zzz:1},"
        fi

done
}


function doAction() {
rrr=$1

# add 0 for on, 1 for off
# Also -1 because it starts at 0
lastChar="${rrr: -1}"
number="${rrr: : -1}"
number=$((number-1))

# Multiply by 2 because each relay needs two numbers
# too turn on and off

number=$((number*2))

#echo "Num $number"
#echo "lchar $lastChar"



if [[ "$lastChar" == "o" ]];then
#	echo "Relay on"
	number=$((number+1))

elif [[ "$lastChar" == "f" ]];then
	number=$number
#	echo "Relay off"

elif [[ "$rrr" == "c" ]];then
	compileMode
elif [[ "$rrr" == "ss" ]];then
	function showStatus() {
	        for i in {1..4};do
	        	curl --silent http://$ip/$portDir/43 |sed 's/ <font color="#FF0000">//g'|sed 's/&nbsp&nbsp<\/font>//g'|grep -oh "Relay-......."|sed 's/<fo/ON/g'| grep -v Relay-ALL
		done
	}
	showStatus | sort
else
	echo "Error"
fi

#echo "finel num is: $number"

# Get length of string. add a 0 of it on less than 10
if [[ $(echo "$number" | wc -m) == "2" ]]; then
#	echo "Adding 0 as single digit"
	number="0"$number
fi

#echo "$ip/30000/$number"
curl "$ip/$portDir/$number" 2> /dev/null 1> /dev/null

}

if [[ "$*" == *"a"* ]];then

echo all XX
	for i in {1..16}; do
	# skip 1,9
	doAction "$i""$2"
	done

else
	# parse and do actions
	for i in "$@" ; do
		doAction $i
	done
fi
