func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let npq = readIntArray()
let n = npq[0]
let p = npq[1]
let q = npq[2]
let a = readIntArray()

var counter = 0
for i1 in 0..<n - 4 {
	for i2 in i1 + 1..<n - 3 {
		let mul2 = a[i1] * a[i2] % p
		for i3 in i2 + 1..<n - 2 {
			let mul3 = mul2 * a[i3] % p
			for i4 in i3 + 1..<n - 1 {
				let mul4 = mul3 * a[i4] % p
				for i5 in i4 + 1..<n {
					if mul4 * a[i5] % p == q {
						counter += 1
					}
				}
			}
		}
	}
}
print(counter)
