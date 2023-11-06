func readInt() -> Int {
	Int(readLine()!)!
}

func readInts() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt() * 2
let a = readInts()

if n == 2 {
	print(abs(a[0] - a[1]))
} else {
	var simple = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
	for i in 0...n - 2 {
		for j in i + 1...n - 1 {
			simple[i][j] = abs(a[i] - a[j])
		}
	}
	
	var complex = simple //隣り合ったもののデータだけそのまま使う。その他は後に書き換える
	
	func calculateComplex(l: Int, r: Int) {
		//lとrの範囲は4以上、つまり r - l >= 3
		var minValue = Int.max
		var mid = l + 1
		
		while true {
			minValue = min(minValue, complex[l][mid] + complex[mid + 1][r])
			if mid + 2 == r {
				break
			} else {
				mid += 2
			}
		}
		complex[l][r] = min(minValue, simple[l][r] + complex[l + 1][r - 1])
	}
	
	var l: Int = 0
	var r: Int = 0
	var rStart: Int = 3
	
	while true {
		l = 0
		r = rStart
		while true {
			
			calculateComplex(l: l, r: r)
			
			if r == n - 1 {
				break
			} else {
				l += 1
				r += 1
			}
		}
		
		if rStart == n - 1 {
			break
		} else {
			rStart += 2
		}
	}
	
	print(complex[0][n - 1])
}
