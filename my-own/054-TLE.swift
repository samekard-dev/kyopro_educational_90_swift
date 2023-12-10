//TLE(時間超過)が発生する

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

var c: [Set<Int>] = [Set<Int>](repeating: [], count: n + 1)
//c : cooperate
for _ in 1...m {
	_ = readInt()
	let r = Set(readIntArray())
	for rp in r {
		c[rp].formUnion(r)
	}
}
for p in 1...n {
	c[p].remove(p)
}

var number = [Int](repeating: -1, count: n + 1)
var next: Set<Int> = [1]
var current = 0
while next.isEmpty == false {
	var newNext: Set<Int> = []
	for n in next {
		if number[n] == -1 {
			number[n] = current
			newNext.formUnion(c[n])
		}
	}
	next = newNext
	current += 1
}

for p in 1...n {
	print(number[p])
}
