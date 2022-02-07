func readInt() -> Int {
	Int(readLine()!)!
}

let tenSix = 1000000

var n = readInt()
var p = [Bool](repeating: true, count: tenSix + 1)

for i in 2...(tenSix / 2) {
	if p[i] == true {
		var j = i * 2
		while j <= tenSix {
			p[j] = false
			j += i
		}
	}
}

var counter = 0
for i in 2...tenSix {
	if n < i {
		break
	}
	
	if p[i] {
		while n % i == 0 {
			counter += 1
			n /= i
		}
	}
}

if n != 1 {
	counter += 1
}

var times = 0
var value = 1
while counter > value {
	times += 1
	value *= 2
}
print(times)
