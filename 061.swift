func readInt() -> Int {
	Int(readLine()!)!
}
 
func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}
 
let q = readInt()
var topArray: [Int] = [Int](repeating: 0, count: 100000)
var topCurrent = 0
var bottomArray: [Int] = [Int](repeating: 0, count: 100000)
var bottomCurrent = 0
for _ in 1...q {
	let tx = readIntArray()
	let t = tx[0]
	let x = tx[1]
	switch t {
		case 1:
			topArray[topCurrent] = x
			topCurrent += 1
		case 2:
			bottomArray[bottomCurrent] = x
			bottomCurrent += 1
		case 3:
			if x <= topCurrent {
				print(topArray[topCurrent - x])
			} else {
				print(bottomArray[x - topCurrent - 1])
			}
		default:
			break
	}
}
