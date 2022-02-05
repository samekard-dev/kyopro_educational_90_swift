func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nk = readIntArray()
let n = nk[0]
let k = nk[1]

var b = [Int](repeating: 0, count: n)
var c = [Int](repeating: 0, count: n)

for i in 0..<n {
	let ab = readIntArray()
	b[i] = ab[1]
	c[i] = ab[0] - ab[1]
}

var d = b + c
let e = d.sorted(by: >).dropLast(2 * n - k).reduce(0, +)
print(e)
