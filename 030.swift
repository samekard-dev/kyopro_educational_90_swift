func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nk = readIntArray()
let n = nk[0]
let k = nk[1]

var pCounter = [Int](repeating: 0, count: n + 1)
for i in 2...n {
	if pCounter[i] == 0 {
		for j in stride(from: i, through: n, by: i) {
			pCounter[j] += 1
		}
	}
}

var ans = 0
for i in 2...n {
	if pCounter[i] >= k {
		ans += 1
	}
}

print(ans)
