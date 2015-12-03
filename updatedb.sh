#!/bin/sh
str=$(cat)  ## take stdin as variable

[ -n "$str" ] || exit 0

stk=/dev/shm/stack.db

[ -e $stk ] || touch $stk


#u() { 
#	res=$(awk -f stacker.awk -v str="""$str""" $stk;)
#	if [ -n "$res" ]; then
#		#	flock /dev/shm/lock -c "echo \"$result\" > $file || sleep 1"
#		echo "$res" > $stk || sleep 1
##		(sh ./write-dsp.sh "$str")&
#	fi
#}
#u

## have to use variable here
## otherwise $stk gets fucked

res=$(awk -f stacker2.awk -v string="""$str""" $stk)

if [ -n "$res" ]; then
	echo "$res" > $stk;
	#echo -en '\x7C\x00' > /dev/console;
	#echo -n "$str" | awk -f dehex.awk > /dev/console
fi

exit 0


