func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
let a = readIntArray().sorted(by: <)
var classBottom = [Int](repeating: 0, count: n)
classBottom[0] = 0
if n >= 2 {
	for i in 1...n - 1 {
		classBottom[i] = a[i - 1] + (a[i] - a[i - 1]) / 2 + 1
		//3と5 -> 5
		//3と6 -> 5
	}
}

let q = readInt()
for _ in 0..<q {
	let rating = readInt()
	var ok = 0
	var ng = n
	while ng - ok >= 2 {
		let middle = (ng - ok) / 2 + ok
		if rating >= classBottom[middle] {
			ok = middle
		} else {
			ng = middle
		}
	}
	print(abs(rating - a[ok]))
}
