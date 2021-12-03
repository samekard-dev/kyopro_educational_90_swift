func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nbk = readIntArray()
let n = nbk[0]  //桁
let b = nbk[1]  //割る数
let k = nbk[2]  //素材の数
let c = readIntArray()  //要素数はk

var remain = [Int](repeating:0, count:k)
for j in 0..<k {
	remain[j] = c[j] % b
}
var counter = [Int](repeating: 0, count: b)
for j in 0..<k {
	counter[remain[j]] += 1
}
if n >= 2 {
	(2...n).forEach { _ in
		for j in 0..<k {
			remain[j] = remain[j] * 10 % b
		}
		var newCounter = [Int](repeating: 0, count: b)
		for i in 0..<b {
			if counter[i] != 0 {
				for j in 0..<k {
					let pos = (i + remain[j]) % b
					newCounter[pos] += counter[i]
					newCounter[pos] %= 1000000007
				}
			}
		}
		counter = newCounter
	}
}
print(counter[0])
