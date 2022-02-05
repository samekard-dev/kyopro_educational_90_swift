func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nq = readIntArray()
let n = nq[0]
let q = nq[1]
var a = readIntArray()
var base = 0

for _ in 1...q {
	let q123 = readIntArray()
	let q1 = q123[0]
	let q2 = q123[1] - 1
	let q3 = q123[2] - 1
	switch q1 {
		case 1:
			let temp = a[(base + q2) % n]
			a[(base + q2) % n] = a[(base + q3) % n]
			a[(base + q3) % n] = temp
		case 2:
			if base == 0 {
				base = n - 1
			} else {
				base -= 1
			}
		case 3:
			print(a[(base + q2) % n])
		default:
			break
	}
}

