enum Turn {
	case e
	case s
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nq = readIntArray()
let n = nq[0]
let q = nq[1]
var aSource: [(i: Int, v: Int)] = [(0, Int.max)] //先頭にダミー
for (index, v) in readIntArray().enumerated() {
	aSource.append((index + 1, v))
}
let aOrdered = aSource.sorted(by: { $0.v > $1.v } )
var a: [Int] = []
var oToS = [Int](repeating: 0, count: n + 1) //source to order
var sToO = [Int](repeating: 0, count: n + 1) //order to source
for (index, ao) in aOrdered.enumerated() {
	a.append(ao.v)
	oToS[index] = ao.i
	sToO[ao.i] = index
} 
var p = [[Int]](repeating: [], count: n + 1) //prohibit
for _ in 0..<q {
	let pair = readIntArray()
	//片方だけでよろしい
	if sToO[pair[0]] < sToO[pair[1]] {
		p[sToO[pair[0]]].append(sToO[pair[1]])
	} else {
		p[sToO[pair[1]]].append(sToO[pair[0]])
	}
}

var remain = [Int](repeating: 0, count: n + 1)
var sum = 0
for i in (1..<a.count).reversed() {
	sum += a[i]
	remain[i] = sum
}

var eState = [Int](repeating: 0, count: n + 1)
var sState = [Int](repeating: 0, count: n + 1)

var eSum = 0
var sSum = 0
var complete = false

func selectCard(least: Int) {
	if eSum != 0 && eSum == sSum {
		printResult()
		complete = true
		return
	}
	guard least <= n else {
		return
	}
	let esDiff = abs(eSum - sSum)
	
	let turn: [Turn]
	if eSum - sSum > 0 {
		turn = [.s, .e]
	} else {
		turn = [.e, .s]
	}
	
	for t in turn {
		switch t {
			case .e:
				for i in least...n {
					if remain[least] < esDiff {
						break
					}
					if eState[i] == 0 {
						eState[i] = 1
						eSum += a[i]
						for pn in p[i] {
							eState[pn] -= 1
						}
						selectCard(least: i + 1)
						eState[i] = 0
						eSum -= a[i]
						for pn in p[i] {
							eState[pn] += 1
						}
					}
					if complete {
						break
					}
				}
			case .s:
				for i in least...n {
					if remain[least] < esDiff {
						break
					}
					if sState[i] == 0 {
						sState[i] = 1
						sSum += a[i]
						for pn in p[i] {
							sState[pn] -= 1
						}
						selectCard(least: i + 1)
						sState[i] = 0
						sSum -= a[i]
						for pn in p[i] {
							sState[pn] += 1
						}
					}
					if complete {
						break
					}
				}
		}
		if complete {
			break
		}
	}
}

func printResult() {
	print(eState.filter( {$0 == 1} ).count)
	var eAns: [Int] = []
	for (i, e) in eState.enumerated() where e == 1 {
		eAns.append(oToS[i])
	}
	eAns = eAns.sorted(by: <)
	for e in eAns {
		print(e, terminator: " ")
	}
	print()
	print(sState.filter( {$0 == 1} ).count)
	var sAns: [Int] = []
	for (i, s) in sState.enumerated() where s == 1 {
		sAns.append(oToS[i])
	}
	sAns = sAns.sorted(by: <)
	for s in sAns {
		print(s, terminator: " ")
	}
	print()
}

selectCard(least: 1)
