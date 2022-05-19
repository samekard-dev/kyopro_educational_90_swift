//想定時間に収まる

let tenNineSeven = 1000000007

var one: [Int : Int] = [:]

func getOne(i: Int) -> Int {
	//mod1000000007で
	//iをいくつ足したら余りが1になるか
	if i == 1 {
		return 1
	}
	if let value = one[i] {
		return value
	} else {
		let times = tenNineSeven / i
		let remain = tenNineSeven % i
		one[i] = ((times + 1) * getOne(i: i - remain)) % tenNineSeven
		return one[i, default: 0]
	}
}

func readInt() -> Int {
	Int(readLine()!)!
}

let n = readInt()

if n == 1 {
	print(1)
} else {
	var frac = [Int](repeating: 0, count: n + 1)
	frac[0] = 1
	frac[1] = 1
	
	for i in 2...n {
		frac[i] = (i * frac[i - 1]) % tenNineSeven
	}
	
	func getCount(s: Int, b: Int) -> Int {
		return ((frac[s] * getOne(i: frac[s - b])) % tenNineSeven * getOne(i: frac[b])) % tenNineSeven
	}
	
	for d in 1...n {
		let maxB = (n - 1) / d + 1
		var counter = 0
		for b in 1...maxB {
			let current = getCount(s: n - (b - 1) * (d - 1), b: b)
			counter = (counter + current) % tenNineSeven
		}
		print(counter)
	}
}

