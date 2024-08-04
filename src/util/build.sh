#
# Utility to build assembly programs.
# Usage: 
#	1. build.sh hello.s 
#		-> Produces target file with 'hello'
#	2. build.sh hello.s intro 
#		-> Produces target file with 'intro'
#

#!/usr/bin/env bash

if [ "$#" -gt 2 -o "$#" -lt 1 ]; then
	echo ""
	echo "Usage:" $0 " <source file> [ target file ]";
	echo "	target file - if not given, source file name will be the target."
	echo ""
	exit;
fi

source=$1;
target=$2;

if [ -z "$target" ]; then
	target=$(basename "$1" .s)
fi

as $source -o ${target}.o
ld ${target}.o -o $target
rm ${target}.o
