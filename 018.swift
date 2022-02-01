import Foundation

func readInt() -> Int {
	Int(readLine()!)!
}

func readDouble() -> Double {
	Double(readLine()!)!
}

func readDoubleArray() -> [Double] {
	readLine()!.split(separator: " ").map { Double(String($0))! }
}

let t = readDouble()
let lxy = readDoubleArray()
let l = lxy[0]
let x = lxy[1]
let y = lxy[2]
let q = readInt()

for _ in 1...q {
	var e = readDouble()
	let ratio = e / t * 2.0 * Double.pi
	let cy = l / 2.0 * -sin(ratio) //current Y
	let cz = l / 2.0 - l / 2.0 * cos(ratio) //current Z
	let levelDistance = sqrt(pow(y - cy, 2.0) + pow(x, 2.0))
	let angle = atan(cz / levelDistance)
	print(angle * 180.0 / Double.pi)
}
