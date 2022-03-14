func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let wn = readIntArray()
let w = wn[0]
let n = wn[1]

var blocks = [[(l: Int, r: Int)]](repeating: [], count: n + 1)
var highest = 0

for _ in 1...n {
	let lr = readIntArray()
	let l = lr[0]
	let r = lr[1]
	
	var checkHeight = highest
	
checkHeight:
	while checkHeight > 0 {
		for checkBlock in blocks[checkHeight] {
			if checkBlock.r >= l && checkBlock.l <= r {
				break checkHeight
			}
		}
		checkHeight -= 1
	}
	let newHeight = checkHeight + 1
	print(newHeight)
	blocks[newHeight].append((l, r))
	if newHeight > highest {
		highest = newHeight
	}
}
