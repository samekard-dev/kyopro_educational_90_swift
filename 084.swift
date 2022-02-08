func readInt() -> Int {
	Int(readLine()!)!
}

let n = readInt()
let s = Array(readLine()!)

var l = 0
var r = 0
var counter = 0
var current = s[0]

search:
while true {
	l = r
	while s[r] == current {
		r += 1
		if r == n {
			break search
		}
	}
	counter += (r - l) * (n - r)
	current = s[r]
}

print(counter)
