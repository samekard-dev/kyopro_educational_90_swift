import Foundation

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nk = readIntArray()
let n = nk[0]
let k = nk[1]
let nn = Int(pow(2.0, Double(n))) //点の組み合わせの数

var pos: [(x: Int, y: Int)] = []

for _ in 1...n {
	let xy = readIntArray()
	pos.append((x: xy[0], y: xy[1]))
}

var dist = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)

for i in 0..<n - 1 {
	for j in i + 1..<n {
		let d = (pos[i].x - pos[j].x) * (pos[i].x - pos[j].x)
				+ (pos[i].y - pos[j].y) * (pos[i].y - pos[j].y)
		dist[i][j] = d
		dist[j][i] = d
	}
}

let dotToNum = (0..<n).map { Int(pow(2.0, Double($0)))}
var dotCount = [Int](repeating: 0, count: nn)
var topDotNum = [Int](repeating: 0, count: nn)
var topDot = [Int](repeating: 0, count: nn)
var start = 1
var end = 2
var dot = 0
for _ in 1...n {
	for i in start..<end {
		dotCount[i] = dotCount[i - start] + 1
		topDotNum[i] = start
		topDot[i] = dot
	}
	start *= 2
	end *= 2
	dot += 1
}

var numToGroup = [[Int]](repeating: [], count: nn)

func getNumToGroup(i: Int) -> [Int] {
	if numToGroup[i] != [] {
		return numToGroup[i]
	}
	
	var returnGroup: [Int] = []
	var dot = 0
	var i = i
	while i != 0 {
		if i % 2 == 1 {
			returnGroup.append(dot)
		}
		i /= 2
		dot += 1
	}
	numToGroup[i] = returnGroup
	return returnGroup
}

var maxDist = [(d: Int, d1: Int, d2: Int)](repeating: (-1, 0, 0), count: nn)

func getMaxDist(i: Int) -> (d: Int, d1: Int, d2:Int) {
	//i: 点の組み合わせ
	//d: 距離の2乗
	//d1とd2: 最大の距離になる組み合わせ（のどれか一組）
	if i == 0 {
		return (0, 0, 0)
	}
	if maxDist[i].d == -1 {
		let group = getNumToGroup(i: i)
		if group.count == 1 {
			maxDist[i] = (0, group.first!, group.first!)
		} else {
			let top = topDot[i]
			let subGroupNum = i - topDotNum[i]
			let subGroup = getNumToGroup(i: subGroupNum)
			var maxValue = getMaxDist(i: subGroupNum)
			for s in subGroup {
				if dist[top][s] > maxValue.d {
					maxValue = (dist[top][s], top, s)
				}
			}
			maxDist[i] = maxValue
		}
	}
	return maxDist[i]
}

//ここから探索

var memResult = [[Int]](repeating: [Int](repeating: -1, count: k + 1), count: nn)

var ansDist = Int.max

func minDist(dotsNum: Int, group: Int, prev: Int) -> Int {
	if group == 1 {
		let dist = getMaxDist(i: dotsNum).d
		if max(prev, dist) < ansDist {
			ansDist = max(prev, dist)
		}
		return dist
	}
	
	/*
	 このグループをひとつのグループとgroup - 1個のグループに分ける
	 ひとつのグループは最大何点含めることができるか
	 */
	let capacity = dotCount[dotsNum] - group + 1
	if capacity == 1 {
		if prev < ansDist {
			ansDist = prev
		}
		return 0
	}
	
	if memResult[dotsNum][group] != -1 {
		let dist = memResult[dotsNum][group]
		if max(prev, dist) < ansDist {
			ansDist = max(prev, dist)
		}
		return dist
	}

	let fixDot = getMaxDist(i: dotsNum).d1
	let fixNum = dotToNum[fixDot]
	var otherDots = getNumToGroup(i: dotsNum).filter { $0 != fixDot }
	otherDots = otherDots.sorted(by: { dist[fixDot][$0] < dist[fixDot][$1] } )
	
	//ひとつとその他の分け方なのでひとつのほうは距離が0。その他の方のDistを代入する。
	var localDist = minDist(dotsNum: dotsNum - fixNum, group: group - 1, prev: prev)
	
	for i in 1..<dotCount[dotsNum] {
		//iは初めのグループのfixDot以外の数
		
		if dist[fixDot][otherDots[i - 1]] > localDist {
			break
		}
		for j in Int(pow(2.0, Double(i - 1)))..<Int(pow(2.0, Double(i))) {
			if dotCount[j] > capacity - 1 {
				continue
			}
			let company = getNumToGroup(i: j)
			var thisGroupNum = fixNum
			for c in company {
				thisGroupNum += dotToNum[otherDots[c]]
			}
			let thisDist = getMaxDist(i: thisGroupNum).d
			let nextDist = minDist(
				dotsNum: dotsNum - thisGroupNum, 
				group: group - 1,
				prev: max(prev, thisDist))
			localDist = min(localDist, max(thisDist, nextDist))
		}
	}
	memResult[dotsNum][group] = localDist
	return localDist
}

_ = minDist(dotsNum: nn - 1, group: k, prev: 0)

print(ansDist)
