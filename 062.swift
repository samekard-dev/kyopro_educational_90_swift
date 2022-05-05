func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()

var outArrow = [[Int]](repeating: [], count: n + 1)
var selected = [Bool](repeating: false, count: n + 1)
var order: [Int] = []

for i in 1...n {
	let input = readIntArray()
	if input[0] == i || input[1] == i {
		order.append(i)
		selected[i] = true
	} else {
		outArrow[input[0]].append(i)
		if input[0] != input[1] {
			outArrow[input[1]].append(i)
		}
	}
}

var walk = 0
while walk < order.count {
	for o in outArrow[order[walk]] {
		if selected[o] == false {
			order.append(o)
			selected[o] = true
		}
	}
	walk += 1
}

if order.count == n {
	for or in order.reversed() {
		print(or)
	}
} else {
	print(-1)
}
