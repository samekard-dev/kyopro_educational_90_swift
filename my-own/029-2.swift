import Foundation

/*
 領域をまとめて処理する
 塊の単位が10なら
 74から334という範囲は
 74 75 76 77 78 79 80-89 90-99 100-199 200-299 300-309 310-319 320-329 330 331 332 333 334
 という分類で処理する
 */

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let wn = readIntArray()
let w = wn[0]
let n = wn[1]
let w2 = w + 1 //0を追加して考える

let k = 20
var stages = 1
do {
	var tempK = k
	while tempK < w2 {
		stages += 1
		tempK *= k
	}
}
let firstStage = 0
var base = Int(pow(Double(w2), 1.0 / Double(stages)))
if Int(pow(Double(base), Double(stages))) < w2 {
	base += 1
}

var height = [[Int]](repeating: [], count: stages)
var flat = [[Bool]](repeating: [], count: stages)
var sib = [[(l: Int, r: Int)]](repeating: [], count: stages) //siblings 例:30-39のきょうだいは0-9から90-99

do {
	let bigBase = Int(pow(Double(base), Double(stages)))
	var amount = bigBase
	
	for s in 0..<stages {
		height[s] = [Int](repeating: 0, count: amount)
		flat[s] = [Bool](repeating: true, count: amount)
		for a in 0..<amount {
			sib[s].append((
				l: (a / base) * base, 
				r: (((a / base) + 1) * base) - 1))
		}
		amount /= base
	}
}

var posL = [Int](repeating: 0, count: stages)
var posR = [Int](repeating: 0, count: stages)

func breakFlat(s: Int, index: Int) {
	guard s != firstStage else {
		return
	}
	flat[s][index] = false
	for child in index * base...(index + 1) * base - 1 {
		flat[s - 1][child] = true
		height[s - 1][child] = height[s][index]
	}
}

for _ in 1...n {
	
	do {
		let lr = readIntArray()
		var l = lr[0]
		var r = lr[1]
		for i in 0..<stages {
			posL[i] = l
			posR[i] = r
			l /= base
			r /= base
		}
	}
	
	var highest = 0
	var separate = false
	var s = stages - 1
	var getHighestL = false
	var getHighestR = false
	
	while true {
		let l = posL[s]
		let r = posR[s]
		if separate == false {
			if l == r {
				if flat[s][l] {
					highest = max(highest, height[s][l])
					break
				}
			} else {
				separate = true
				for a in l + 1..<r {
					highest = max(highest, height[s][a])
				}
				if flat[s][l] {
					highest = max(highest, height[s][l])
					getHighestL = true
				}
				if flat[s][r] {
					highest = max(highest, height[s][r])
					getHighestR = true
				}
			}
		} else {
			if getHighestL == false {
				if l < sib[s][l].r {
					for a in l + 1...sib[s][l].r {
						highest = max(highest, height[s][a])
					}
				}
				if flat[s][l] {
					highest = max(highest, height[s][l])
					getHighestL = true
				}
			}
			if getHighestR == false {
				for a in sib[s][r].l..<r {
					highest = max(highest, height[s][a])
				}
				if flat[s][r] {
					highest = max(highest, height[s][r])
					getHighestR = true
				}
			}
		}
		if getHighestL && getHighestR {
			break
		}
		s -= 1
	}
	
	let newHeight = highest + 1
	
	separate = false
	s = stages - 1
	
	while s >= 0 {
		let l = posL[s]
		let r = posR[s]
		if separate == false {
			if s == firstStage {
				for a in l...r {
					height[s][a] = newHeight
				}
			} else {
				if l == r {
					if flat[s][l] {
						breakFlat(s: s, index: l)
					}
				} else {
					separate = true
					for a in l + 1..<r {
						flat[s][a] = true
						height[s][a] = newHeight
					}
					if flat[s][l] {
						breakFlat(s: s, index: l)
					}
					if flat[s][r] {
						breakFlat(s: s, index: r)
					}
				}
			}
		} else {
			if s == firstStage {
				for a in l...sib[s][l].r {
					height[s][a] = newHeight
				}
				for a in sib[s][r].l...r {
					height[s][a] = newHeight
				}
			} else {
				if l < sib[s][l].r {
					for a in l + 1...sib[s][l].r {
						flat[s][a] = true
						height[s][a] = newHeight
					}
				}
				if flat[s][l] {
					breakFlat(s: s, index: l)	
				}
				for a in sib[s][r].l..<r {
					flat[s][a] = true
					height[s][a] = newHeight
				}
				if flat[s][r] {
					breakFlat(s: s, index: r)	
				}
			}
		}
		s -= 1
	}
	
	for s in 0..<stages {
		height[s][posL[s]] = max(newHeight, height[s][posL[s]])
		height[s][posR[s]] = max(newHeight, height[s][posR[s]])
	}
	
	print(newHeight)
}
