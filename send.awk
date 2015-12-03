BEGIN {
	FS = ""
	a = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}"
	h = "00 00 0D 00 04 80 02 00 02 00 00 00 00 80 00 00 00 FF FF FF FF FF FF 6E 65 74 6C 65 73 6E 65 74 6C 65 73 00 01 00 00 00 00 00 00 00 01 64 00 01 04"
	t = "01 01 02 03 01 01"
}

	function asc2hex(c) {
		return sprintf("%x", index(a, substr(c, 1, 1)) + 32)
	}

	function range(s, e, x) {
		for (i = s; i <= e; i++) {
			x = x $i
		}
		return x
	}

	function str2hex(s, z) {
		for (i = 1; i <= length(s); i++) {
			z = z toupper(asc2hex(substr(s, i, 1)))
			if (i < length(s)) z = z " "
		}
		return z
}
	function lenhex(s) {
		s = sprintf("%x", length(s))
		if (length(s) == 1) {
			s = 0 s
		}
		return toupper(s)
	}

{
	len = length($0)

	if (len > 255) {
		$0 = range(1, 255) ".."	
	}

	if (len > 31) {
			ssid = range(1, 31) ">"
			extr = range(32, len)
	}
	else {
		ssid = $0
	}

	frame = h " 00 " lenhex(ssid) " " str2hex(ssid) " " t

	if (length(extr) > 0) {
		frame = frame " 6E " lenhex(extr) " " str2hex(extr)
	}
	

	print frame
	system("")
	#print ssid extr


	#print length($0)
	# print NF
	#for(i=1;i<=NF;i++)print $(i)


}
