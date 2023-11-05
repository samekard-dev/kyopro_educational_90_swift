func readInts() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let wn = readInts()
let w = wn[0]
let n = wn[1]

var height = [Int](repeating: 0, count: w + 1)
for _ in 1...n {
	let lr = readInts()
	let l = lr[0]
	let r = lr[1]
	var highest = 0
	for i in l...r {
		if height[i] > highest {
			highest = height[i]
		}
	}
	for i in l...r {
		height[i] = highest + 1
	}
	print(highest + 1)
}
