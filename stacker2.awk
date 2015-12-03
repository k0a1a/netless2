BEGIN {
	FS="\n"		## fields are separated by newline
	OFS="\n"
	l = 20
	h = 0
}

NR <= l-1 {
	if (string == $0) {		## string is an execution variable (-v string="string")
		h = 1
		exit 0	## exit if string is in stack (nothing has to be done
	}
	if (s) {	## make stack, add newlines
		s = s FS $0
	}
	else s = $0
}

END {
	if (h) { exit }
	$0 = string FS s
	print
}
