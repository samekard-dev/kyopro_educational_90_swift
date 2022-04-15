func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let npk = readIntArray()
let n = npk[0]
let p = npk[1]
let k = npk[2]

var a: [[Int]] = []
for _ in 0..<n {
	a.append(readIntArray())
}

var undef: [(Int, Int)] = []
for i in 0..<n {
	for j in 0..<n {
		if a[i][j] == -1 {
			undef.append((i, j))
		}
	}
}

func inP(x: Int) -> Int {
	for u in undef {
		a[u.0][u.1] = x
	}
	
	var counter = 0
	for i in 0..<n {
		var order: [(c: Int, s: Int)] = []
		
		for j in 0..<n {
			if i != j {
				order.append((c: j, s: a[i][j]))
			}
		}
		order = order.sorted(by: { $0.s < $1.s })
		let orderCount = order.count
		
		var current = 0
		while current < orderCount - 1 { //最後は除く
			let target = order[current].c
			for k in current + 1..<orderCount {
				let checked = order[k].c
				if order[current].s + a[target][checked] < order[k].s {
					order[k].s = order[current].s + a[target][checked]
					var movingLeft = k
					while order[movingLeft].s < order[movingLeft - 1].s {
						let temp = order[movingLeft]
						order[movingLeft] = order[movingLeft - 1]
						order[movingLeft - 1] = temp
						movingLeft -= 1
					}
				}
			}
			current += 1
		}
		
		for o in order {
			if o.s <= p {
				counter += 1
			}
		}
	}
	
	return counter / 2
}

/*
 xを上げると結果は同じか下がるので
 inP(x: 1)とinP(x: p + 1)の結果は
 
 1: k未満
 p+1: k未満
 
 1: k
 p+1: k未満
 
 1: k
 p+1: k
 
 1: kより大
 p+1: k未満
 
 1: kより大
 p+1: k
 
 1: kより大
 p+1: kより大
 
 の6つ
 */

let oneResult = inP(x: 1)
let pPlusOneResult = inP(x: p + 1)

if oneResult < k || pPlusOneResult > k {
	print(0)
} else if pPlusOneResult == k {
	print("Infinity")
} else {
	//oneResult >= k かつ pPlusOneResult < k
	
	var underK = 0 //Kより下となるxの下端
	var overK = 0 //Kより上となるxの上端
	//最終的にoverK < underKである
	
	do {
		var l = 1
		var r = p + 1
		var mid = 0
		while r - l >= 2 {
			mid = (l + r) / 2
			let midResult = inP(x: mid)
			if midResult >= k {
				l = mid
			} else if midResult < k {
				r = mid
			}
		}
		underK = r
	}
	if oneResult > k {
		var l = 1
		var r = underK
		var mid = 0
		while r - l >= 2 {
			mid = (l + r) / 2
			let midResult = inP(x: mid)
			if midResult > k {
				l = mid
			} else if midResult <= k {
				r = mid
			}
		}
		overK = l
	}
	print(underK - overK - 1)
}

/*
上であげた6パターンを
kを徐々に変えてデバッグする方法

斜め
6 5 k
0 -1 10 4 6 2
-1 0 14 3 -1 15
10 14 0 2 -1 -1
4 3 2 0 5 7
6 -1 -1 5 0 22
2 15 -1 7 22 0

k = 16 -> 0 (1: k未満、p+1: k未満)
k = 15 -> 2 (1: k、p+1: k未満)
k = 14 -> 0 (1: k超え、p+1: k未満)
k = 13 -> 1
k = 12 -> 0
k = 11 -> 0
k = 10 -> 2
k = 9 -> 0
k = 8 -> 0
k = 7 -> 0 (1: k超え、p+1: k未満)
k = 6 -> Infinity (1: k超え、p+1: k)
k = 5 -> 0 (1: k超え、p+1: k超え)


水平
3 8 k
0 1 10
1 0 3
10 3 0

k = 4 -> 0 (1: k未満、p+1: k未満)
k = 3 -> Infinity (1: k、p+1: k)
k = 2 -> 0 (1: k超え、p+1: k超え)
*/
