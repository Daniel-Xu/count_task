#! /bin/bash

####################################################################
# Fuction:
## This file is used to 
## calculate the total lines
## and total file numbers

# Author
## Xuweidong

# Date
## 2012/07/17
####################################################################

#function
function printerr(){
	echo  "Wrong command!"
	echo  "Try '$0 -h' for more information"
	exit 0
}

function printusage(){
	echo -e "Usage $0 [option]... DIRECTORY... [option]... LEVEL..."	
	echo -e "\t-d specify directory you want to count"
	echo -e "\t-R recursively count the directory, default leve is 1"
	exit 0
}

#help information and usage
if [ $# -ne 1 ]&&[ $# -lt 3 ];then 	
	printerr 
fi

#parse command line
while getopts ":hd:R:" args 2>/dev/null
do
	case $args in
   		h)	printusage
			;;
		d)	dir=$OPTARG
			echo "dir is $dir"
			if [ ! -d $dir ]; then
				echo "$dir doesn't exist or isn't a directory"	
				exit 0
			fi
			;;
		R)	if [ $OPTARG == "-d" ]; then
				OPTIND=$(($OPTIND-1))
				level=1
			else
				level=$OPTARG
			fi
			echo "level is $level"
			;;
	        :)	if [ $OPTARG == "R" ]; then
				level=1
				echo "level is $level"
			fi
			;;
		?)  printerr
			;;
	esac
done

#variable
c_lnum=0
h_lnum=0
sh_lnum=0
c_fnum=0
h_fnum=0
sh_fnum=0

#process
##.c .h .sh lines respectely
##.c .h .sh filenum respectely

##math_expression // /* * */ 
c_lnum=$(find $dir -maxdepth $level -name "*.c" 2>/dev/null |xargs egrep -v  "^//.*|^/\*.*|^ *\*|\*/$" | wc -l) 
h_lnum=$(find $dir -maxdepth $level -name "*.h" 2>/dev/null |xargs egrep -v  "^//.*|^/\*.*|^ *\*|\*/$" | wc -l) 
sh_lnum=$(find $dir -maxdepth $level -name "*.sh" 2>/dev/null |xargs egrep -v  "^#.*" | wc -l)

c_fnum=$(find $dir -maxdepth $level -name "*.c" 2>/dev/null |wc -l)
h_fnum=$(find $dir -maxdepth $level -name "*.h" 2>/dev/null |wc -l)
sh_fnum=$(find $dir -maxdepth $level -name "*.sh" 2>/dev/null |wc -l)

#format output
echo -e "The result is:\n"
echo -e "\t.c linenum \t.h linenum \t.sh linenum"
echo -e "\t\t$c_lnum \t\t$h_lnum \t\t$sh_lnum"
echo -e "\t.c filenum \t.h filenum \t.sh filenum"
echo -e "\t\t$c_fnum \t\t$h_fnum \t\t$sh_fnum"
