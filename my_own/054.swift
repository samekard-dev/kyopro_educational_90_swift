//条件2は「高橋氏以外のものは〜」と解釈して実装

func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readIntArray()
let n = nm[0]
let m = nm[1]

var number = [Int](repeating: -1, count: n + 1)
number[1] = 0
var unChecked = [Bool](repeating: true, count: m)
var pInR = [[Int]](repeating: [], count: m)
var rOfP = [[Int]](repeating: [], count: n + 1)

for r in 0..<m {
	_ = readInt()
	let pp = readIntArray()
	for p in pp {
		pInR[r].append(p)
		rOfP[p].append(r)
	}
}

var current = 1
var checkingR = rOfP[1]
for r in checkingR {
	unChecked[r] = false
}

while checkingR.isEmpty == false {
	var next: [Int] = []
	for r in checkingR {
		for p in pInR[r] {
			if number[p] == -1 {
				number[p] = current
				for nextR in rOfP[p] {
					if unChecked[nextR] {
						next.append(nextR)
						unChecked[r] = false
					}
				}
			}
		}
	}
	checkingR = next
	current += 1
}

for i in 1...n {
	print(number[i])
}

