func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let hw = readIntArray()
let h = hw[0]
let w = hw[1]
var a: [[Int]] = []
var b: [[Int]] = []

for _ in 1...h {
	a.append(readIntArray())
}
for _ in 1...h {
	b.append(readIntArray())
}

var counter = 0
var result = true

for i in 0...h - 2 {
	for j in 0...w - 2 {
		let diff = b[i][j] - a[i][j]
		counter += abs(diff)
		a[i][j] += diff
		a[i][j + 1] += diff
		a[i + 1][j] += diff
		a[i + 1][j + 1] += diff
	}
	if a[i][w - 1] != b[i][w - 1] {
		result = false
		break
	}
}
if result {
	for j in 0...w - 1 {
		if a[h - 1][j] != b[h - 1][j] {
			result = false
			break
		}
	}
}

if result {
	print("Yes")
	print(counter)
} else {
	print("No")
}
