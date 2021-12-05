func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let hw = readIntArray()
//解説を見ずに書いたものですがほぼ解説通りだったのでそのまま採用
let h = hw[0]
let w = hw[1]
var a: [[Int]] = []
for _ in 0..<h {
	a.append(readIntArray())
}
var b = [[Int]](repeating: [Int](repeating: 0, count: w), count: h)

for i in 0..<h {
	for j in 0..<w {
		b[i][j] = -a[i][j]
	}
}
for i in 0..<h {
	var sum = 0
	for j in 0..<w {
		sum += a[i][j]
	}
	for j in 0..<w {
		b[i][j] += sum
	}
}
for j in 0..<w {
	var sum = 0
	for i in 0..<h {
		sum += a[i][j]
	}
	for i in 0..<h {
		b[i][j] += sum
	}
}

for i in 0..<h {
	print(b[i].map { String($0) }.joined(separator: " "))
}
