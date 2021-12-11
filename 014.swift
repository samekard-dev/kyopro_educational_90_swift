func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
let a = readIntArray().sorted(by: <)
let b = readIntArray().sorted(by: <)
var sum = 0
for i in 0..<n {
	sum += abs(a[i] - b[i])
}
print(sum)
