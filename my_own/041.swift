func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

func gcd(_ a: Int, _ b: Int) -> Int {
	if b == 0 {
		return a
	} else {
		return gcd(b, a % b)
	}
}

let n = readInt()
var xy: [(x: Int, y: Int)] = []
var xMax = 0
var xMin = Int.max
var yMax = 0
var yMin = Int.max
for _ in 0..<n {
	let input = readIntArray()
	xy.append((input[0], input[1]))
	xMax = max(xMax, input[0])
	xMin = min(xMin, input[0])
	yMax = max(yMax, input[1])
	yMin = min(yMin, input[1])
}
if xMax == xMin {
	print(yMax - yMin + 1 - n)
} else if yMax == yMin {
	print(xMax - xMin + 1 - n)
} else {
	//囲む範囲は面積を持つ
	xy = xy.sorted(by: {
		if $0.x == $1.x {
			return $0.y < $1.y
		} else {
			return $0.x < $1.x
		}
	})
	
	//上のラインと下のラインを記録する
	var topLine: [(x: Int, y: Int)] = [(xy[0].x, xy[0].y)]
	var bottomLine: [(x: Int, y: Int)] = [(xy[0].x, xy[0].y)]
	
	for i in 1..<n {
		//topLine
		while true {
			if xy[i].x == topLine.last!.x {
				if xy[i].y < topLine.last!.y {
					break
				} else {
					topLine.removeLast()
				}
			}
			while topLine.count >= 2 {
				let last = topLine.count - 1
				let slant1 = Double(xy[i].y - topLine[last].y) / Double(xy[i].x - topLine[last].x)
				let slant2 = Double(xy[i].y - topLine[last - 1].y) / Double(xy[i].x - topLine[last - 1].x)
				if slant1 < slant2 {
					break
				} else {
					topLine.removeLast()
				}
			}
			topLine.append((xy[i].x, xy[i].y))
			break
		}
		
		//bottomLine
		while true {
			if xy[i].x == bottomLine.last!.x {
				if xy[i].y > bottomLine.last!.y {
					break
				} else {
					bottomLine.removeLast()
				}
			}
			while bottomLine.count >= 2 {
				let last = bottomLine.count - 1
				let slant1 = Double(xy[i].y - bottomLine[last].y) / Double(xy[i].x - bottomLine[last].x)
				let slant2 = Double(xy[i].y - bottomLine[last - 1].y) / Double(xy[i].x - bottomLine[last - 1].x)
				if slant1 > slant2 {
					break
				} else {
					bottomLine.removeLast()
				}
			}
			bottomLine.append((xy[i].x, xy[i].y))
			break
		}
	}

	//topLine以下の点を数える
	//各範囲の左端は含めない。右端は含める。
	var counter = topLine[0].y + 1 //一番左をあらかじめ数える
	for i in 1..<topLine.count {
		let w = topLine[i].x - topLine[i - 1].x
		let minY = min(topLine[i].y, topLine[i - 1].y)
		let h = abs(topLine[i].y - topLine[i - 1].y)
		let onCross = gcd(max(w, h), min(w, h)) + 1
		let triangle = ((w + 1) * (h + 1) - onCross) / 2
		let underRect = (w + 1) * minY
		counter += triangle + onCross + underRect - (topLine[i - 1].y + 1)
	}
	
	//bottomLineより下の点を省く
	counter -= bottomLine[0].y
	for i in 1..<bottomLine.count {
		let w = bottomLine[i].x - bottomLine[i - 1].x
		let minY = min(bottomLine[i].y, bottomLine[i - 1].y)
		let h = abs(bottomLine[i].y - bottomLine[i - 1].y)
		let onCross = gcd(max(w, h), min(w, h)) + 1
		let triangle = ((w + 1) * (h + 1) - onCross) / 2
		let underRect = (w + 1) * minY
		counter -= triangle + underRect - bottomLine[i - 1].y
	}
	
	print(counter - n)
}
