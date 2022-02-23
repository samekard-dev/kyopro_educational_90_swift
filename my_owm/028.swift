//模範解答より処理時間が若干かかる
func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let range = 1000

let n = readInt()
var s = [[Int]](repeating: [Int](repeating: 0, count: range), count: range)
var e = [[Int]](repeating: [Int](repeating: 0, count: range), count: range)
for _ in 1...n {
	let area = readIntArray()
	for x in area[0]..<area[2] {
		//紙の下の辺と上の辺（の内側）に印をつける
		s[area[1]][x] += 1
		e[area[3] - 1][x] += 1
	}
}
var piles = [Int](repeating: 0, count: n + 1)
for x in 0..<range {
	var current = 0
	for y in 0..<range {
		if s[y][x] != 0 {
			current += s[y][x]
		}
		piles[current] += 1
		if e[y][x] != 0 {
			current -= e[y][x]
		}
	}
}
for i in 1...n {
	print(piles[i])
}
