func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var a: [[Int]] = []
for _ in 1...n {
	a.append(readIntArray())
}

func makeE(a1l: Int, a1r: Int, a2l: Int, a2r: Int) -> Double {
	//a1 > a2となる確率
	//引数の上限は100
	
	if a1r < a2l {
		//重ならない
		return 0.0
	} else if a1l > a2r {
		//重ならない
		return 1.0
	} else {
		//重なる
		let a1 = (a1r - a1l + 1)
		let a2 = (a2r - a2l + 1)
		let all = a1 * a2
		let mid = min(a1r, a2r) - max(a1l, a2l) + 1
		var tentou = 0
		if a1r > a2r {
			tentou += (a1r - a2r) * a2
		}
		if a1l > a2l {
			tentou += mid * (a1l - a2l)
		}
		tentou += mid * (mid - 1) / 2 //等しい場合は除く
		return Double(tentou) / Double(all)
	}
}

if n == 1 {
	print(0.0)
} else {
	var ans = 0.0
	for i in 0...n - 2 {
		for j in i + 1...n - 1 {
			ans += makeE(a1l: a[i][0], a1r: a[i][1], a2l: a[j][0], a2r: a[j][1])
		}
	}
	print(ans)
}
