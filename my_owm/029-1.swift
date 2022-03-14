func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let wn = readIntArray()
let w = wn[0]
let n = wn[1]

var height = [Int](repeating: 0, count: w + 1)
for _ in 1...n {
	let lr = readIntArray()
	let l = lr[0]
	let r = lr[1]
	var hightest = 0
	for i in l...r {
		if height[i] > hightest {
			hightest = height[i]
		}
	}
	for i in l...r {
		height[i] = hightest + 1
	}
	print(hightest + 1)
}
