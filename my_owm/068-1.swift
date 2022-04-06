
//単純な実装。TLE（時間超過）の可能性あり。

func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
let qs = readInt()

var add = [Int](repeating: 0, count: n)

var leader = (0...n).map{ $0 }

func getLeader(_ a: Int) -> Int {
	if leader[a] == a {
		return a
	} else {
		leader[a] = getLeader(leader[a])
		return leader[a]
	}
}

for _ in 1...qs {
	let q = readIntArray()
	switch q[0] {
		case 0:
			leader[q[2]] = q[1]
			add[q[1]] = q[3]
		case 1:
			if getLeader(q[1]) == getLeader(q[2]) {
				if q[1] <= q[2] {
					//確定：左
					//調べる：右
					var i = q[1]
					var currentValue = q[3]
					while i != q[2] {
						i += 1
						currentValue = add[i - 1] - currentValue
					}
					print(currentValue)
				} else if q[2] < q[1] {
					//確定：右
					//調べる：左
					var i = q[1]
					var currentValue = q[3]
					while i != q[2] {
						i -= 1
						currentValue = add[i] - currentValue
					}
					print(currentValue)
				}
			} else {
				print("Ambiguous")
			}
		default:
			fatalError()
	}
}
