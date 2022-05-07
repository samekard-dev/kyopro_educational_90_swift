func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let fieldWH = 5000
let nk = readIntArray()
let n = nk[0]
let k = nk[1]

//身長縦軸、体重横軸
//[c, d]]
//[[a, b],
var area = [[Int]](repeating: [Int](repeating: 0, count: fieldWH + 3), count: fieldWH + 3)

let mOffset: Int //左下のONまでの差
let pOffset: Int //右上のONまでの差
let fieldMax: Int
let fieldMin: Int
if k % 2 == 0 {
	mOffset = -k / 2
	pOffset = k / 2 + 1
	fieldMax = fieldWH + 1
	fieldMin = 1
} else {
	//奇数の時は格子点が情報を持つ前提
	mOffset = -k / 2
	pOffset = k / 2 + 2 
	fieldMax = fieldWH + 2
	fieldMin = 1
}

for _ in 1...n {
	let hw = readIntArray()
	let height = hw[0]
	let weight = hw[1]
	area[max(fieldMin, height + mOffset)][max(fieldMin, weight + mOffset)] += 1
	area[max(fieldMin, height + mOffset)][min(fieldMax, weight + pOffset)] -= 1
	area[min(fieldMax, height + pOffset)][max(fieldMin, weight + mOffset)] -= 1
	area[min(fieldMax, height + pOffset)][min(fieldMax, weight + pOffset)] += 1	
}

for h in fieldMin...fieldMax {
	var current: Int = 0
	for w in fieldMin...fieldMax {
		//area[h][w] += area[h][w - 1]とするとコピーを作成するので処理が遅い Swift 5.6
		current += area[h][w]
		area[h][w] = current
	}
}

var maxValue: Int = 0
for w in fieldMin...fieldMax {
	var current: Int = 0
	for h in fieldMin...fieldMax {
		current += area[h][w]
		if current > maxValue {
			maxValue = current
		}
	}
}

print(maxValue)
