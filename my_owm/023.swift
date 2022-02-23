func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var relation = [Set<Int>](repeating: [], count: n + 1)
for _ in 1...n - 1 {
	let pair = readIntArray()
	relation[pair[0]].insert(pair[1])
	relation[pair[1]].insert(pair[0])
}
var oneHand: Set<Int> = []
for i in 1...n {
	if relation[i].count == 1 {
		oneHand.insert(i)
	}
}
var living = [Bool](repeating: true, count: n + 1)
living[0] = false//使わない

var deleteCount = 0
while deleteCount < n - 1 {
	//末端を独立させる。末端と繋がっているものを消去する。
	let leaf = oneHand.first!
	for target in relation[leaf] {
		//leafのrelationにはひとつだけしかない
		for r in relation[target] {
			relation[r].remove(target)
			let rHands = relation[r].count
			if rHands == 0 {
				oneHand.remove(r)
			} else if rHands == 1 {
				oneHand.insert(r)
			}
			deleteCount += 1
		}
		if relation[target].count == 1 {
			oneHand.remove(target)
		}
		relation[target].removeAll()
		living[target] = false
	}
}

var printCount = 0
for i in 1...n {
	if living[i] {
		printCount += 1
		if printCount != n / 2 {
			print(i, terminator: " ")
		} else {
			print(i)
			break
		}
	}
}
