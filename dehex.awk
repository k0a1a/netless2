function dehex2(msg, l, i, m) {			## dehex using for-loop of printf
	l = split(msg,a)
	for (i = 1; i <= l; i += 1) {
		m = m sprintf("%c", hextonum(a[i]));
	}
	return m
}

function hextonum(str, ret, y, x, c, k) {
#	if (2 >= x = length(str)) {       ## instead of slow if (str ~ /^[[:xdigit:]]+/) {
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

{

print dehex2($0)

}
