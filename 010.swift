func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var class1Sum = [Int](repeating: 0, count: n + 1)
var class2Sum = [Int](repeating: 0, count: n + 1)

for i in 1...n {
	let cp = readIntArray()
	let c = cp[0]
	let p = cp[1]
	if c == 1 {
		class1Sum[i] = class1Sum[i - 1] + p
		class2Sum[i] = class2Sum[i - 1]
	} else if c == 2 {
		class1Sum[i] = class1Sum[i - 1]
		class2Sum[i] = class2Sum[i - 1] + p
	}
}

let q = readInt()
for _ in 0..<q {
	let lr = readIntArray()
	let l = lr[0]
	let r = lr[1]
	print("\(class1Sum[r] - class1Sum[l - 1]) \(class2Sum[r] - class2Sum[l - 1])")
}
