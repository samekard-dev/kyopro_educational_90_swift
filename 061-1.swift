func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let q = readInt()
var data: [Int] = [Int](repeating: 0, count: 200000)
var topCurrent = 99999
var bottomCurrent = 100000
for _ in 1...q {
	let tx = readIntArray()
	let t = tx[0]
	let x = tx[1]
	switch t {
		case 1:
			data[topCurrent] = x
			topCurrent -= 1
		case 2:
			data[bottomCurrent] = x
			bottomCurrent += 1
		case 3:
			print(data[topCurrent + x])
		default:
			break
	}
}
