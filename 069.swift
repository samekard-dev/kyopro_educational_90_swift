func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let tenNineSeven = 1000000007

let nk = readIntArray()
let n = nk[0]
let k = nk[1]

if n == 1 {
	print(k)
} else if n == 2 {
	if k == 1 {
		print(0)
	} else {
		print(k * (k - 1) % tenNineSeven)
	}
} else {
	if k == 1 || k == 2 {
		print(0)
	} else {
		var k2multiple = [Int](repeating: 0, count: 63)
		var series = [Int](repeating: 0, count: 63)
		k2multiple[0] = k - 2
		series[0] = 1
		
		for i in 1...62 {
			k2multiple[i] = k2multiple[i - 1] * k2multiple[i - 1] % tenNineSeven
			series[i] = series[i - 1] * 2
		}
		
		var sum = k * (k - 1) % tenNineSeven
		var current = n - 2
		
		for i in (0...62).reversed() {
			if current >= series[i] {
				sum = sum * k2multiple[i] % tenNineSeven
				current -= series[i]
			}
		}
		
		print(sum)
	}
}
