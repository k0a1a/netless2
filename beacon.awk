BEGIN {

	## settings are here

	ssi_max = 170+0															## max signal level that we receive
	stk= "/dev/shm/stack.db"
	lines = 20+0																## lines to keep in stack.db
}

function tpos(tag, n, q) {										## n is  the position of the first tag following ssid
	while ($n != tag) {
		q = hextonum($(n + 1))
		if (q == 0) {
			n = null
			break
		}
		else
			n = n + q + 2 													## current position + length of the tag + 
																							## + 2 bytes of length of both
	}
	return n
}

function getrange(s, b, e) {  								## replace heavy for-loops
	return substr(s, b*2+(b-2), e*2+(e-1))
}

function getlen(s) {													## get number of ascii chars from raw hex string
	return (length(s)+1)/3
}

function dehex2(msg, l, i, m) {								## dehex using for-loop of printf()
	l = split(msg,a)
	for (i = 1; i <= l; i += 1) {
		m = m sprintf("%c", hextonum(a[i]));
	}
	return m
}

function hextonum(str, ret, y, x, c, k) {			## implementation of strtonum() for traditional awk
	x = length(str)
	if (x <= 2) {
		ret = 0
		for (y = 1; y <= x; y++) {
			c = substr(str, y, 1)
			if ((k = index("0123456789", c)) > 0)
				k-- # adjust for 1-basing in awk
			else if ((k = index("ABCDEF", c)) > 0)
				k += 9
			ret = ret * 16 + k
			}
	}
	return ret
}

function updatedb(data, stack, c, h, x)	{
	c = 1
	while (( getline line < stk ) > 0 && c <= lines) {
		if (line == data)	{
			h = 1
		}
		stack = stack "\n" line
		c++
	}
	close(stk)

	if (h) return
	
	printf(data stack) > stk
	close(stk)
	return true
}

/80 00 00 00 FF FF FF FF FF FF 6E 65 74 6C 65 73 6E 65 74 6C 65 73 .+$/ { ## listen to NETLESS devices only
	
	apos = hextonum($3) + hextonum($4)					## get header length
	flags = $8 $7 $6 $5													## binary mask
	flags = strtonum("0x"flags)									## decimal mask

	sshift = 0

	if (and (flags, 1) > 0) {										## TSFT: 8 byte
		sshift = sshift + 8
	}
	if (and (flags, 2) > 0) {										## Flags: 1 byte
		sshift = sshift + 1
	}
	if (and (flags, 4) > 0) {										## Rate: 1 byte
		sshift = sshift + 1
	}
	if (and (flags, 8) > 0) {										## Channel: 4 byte
		sshift = sshift + 4
	}
	if (and (flags, 16) > 0) {									## FHSS: 2 byte
		sshift = sshift + 2
	}

#	print hextonum($(8 + sshift + 1))

	ssi = hextonum($(8 + sshift + 1))						## get ssi value

#	rxflag = hextonum($(8 + sshift + 3))				## check 

	if(apos > 13 && ssi > ssi_max) { 						## only work with frame which 
																							## headers are > 13 bytes (not ours) 

		spos = apos + 39													## ssid position = (header len + MAC header + 
																							## + fixed param + SSID params + length)

		slen = hextonum($(spos - 1))							## ssid length = ssid position - 1 /length pair/
		send = spos + slen												## ssid end = ssid position + ssid length
	
		msg = getrange($0, spos, slen)
		epos = tpos("6E", send)										## find extra netless tag (or not)

		if (slen == 32 && epos) {									## we have extended netless tag
			epos += 2
			elen = hextonum($(epos - 1))
			extr = getrange($0, epos, elen)
			if (elen == getlen(extr)) {							## does length match real length?
				msg = substr(msg, 1, length(msg) - 3) ## remove ">" sign from overflown ssid 
																							## (it's 2 of hex and a space)
				msg = msg " " extr
			}
		}

		print "ssi: " ssi
		print "msg: " dehex2(msg) "\n"

		printf(updatedb(msg))											## updating stack file right away

	}																						## end of if-valid-packet
}																							## end of if-netless-packet

