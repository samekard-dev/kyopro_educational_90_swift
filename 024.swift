func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nk = readIntArray()
let n = nk[0]
let k = nk[1]
let a = readIntArray()
let b = readIntArray()

var diffCounter = 0
for i in 0..<n {
	diffCounter += abs(a[i] - b[i])
}

if diffCounter > k {
	print("No")
} else {
	if diffCounter % 2 == k % 2 {
		print("Yes")
	} else {
		print("No")
	}
}
