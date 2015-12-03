BEGIN {
	FS="\n"		## fields are separated by newline
	OFS="\n"
	stack = ""
	have = 0
	lines = 20
}

{
	if (string == $0) {		## string is an execution variable (-v string="string")
		have = 1
	}
	if (stack == "") {
		stack = $0
	}
	else { stack = stack FS $0 }
}

END { 
	if (!have) {  ## if string is not in the stack prepend it
		$0 = string FS stack
	}
#	else { $0 = stack }
	else { exit }	## string is in the stack, do nothing

	if (NF < lines) { lines = NF } ## output no more then var lines

	for (x = 1; x <= lines; x++) { 
#		output = output $x
		print $x
#		if (x < lines) {output = output FS}
	}
#print output
system("")
#cmd = "cat > stack.db"
#print msg | cmd
#system("")
#close(cmd)

}
