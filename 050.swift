func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nl = readIntArray()
let n = nl[0]
let l = nl[1]

var counter = [Int](repeating: 0, count: n + 1)
counter[0] = 1
for i in 1...n {
	counter[i] += counter[i - 1]
	if i - l >= 0 {
		counter[i] += counter[i - l]
	}
	counter[i] %= 1000000007
}

print(counter[n])
