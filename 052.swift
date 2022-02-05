func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var sum = 1
for _ in 1...n {
	sum *= readIntArray().reduce(0, +)
	sum %= 1000000007
}
print(sum)
