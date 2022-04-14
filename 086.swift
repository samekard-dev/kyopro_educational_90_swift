/*
 ビットごとに独立していて処理して構わないのでそうする
 ビットごとに
 - 0になるべきAx
 - 1になるべき3つのAxの組み合わせ
 の制約を整理する
 そのビットのみのAxの組み合わせ（約4000）を制約と照らし合わせる。
 
 例 
 入力
 A1 A2 A3で12
 制約
 - 0ビット(1を担当)はA1 A2 A3すべてでOFF
 - 2ビット(4を担当)はA1 A2 A3のどれかがON
 など
 */
func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nq = readIntArray()
let n = nq[0]
let q = nq[1]

//r: restriction
var rOn = [[Int]](repeating: [], count: 60)
var rOff = [Int](repeating: 0, count: 60)

for _ in 1...q {
	let input = readIntArray()
	let w = input[3]
	let source = (Int(1) << (input[0] - 1))
				| (1 << (input[1] - 1))
				| (1 << (input[2] - 1))
	for i in 0...59 {
		if w & (1 << i) == 0 {
			rOff[i] |= source
		} else {
			rOn[i].append(source)
		}
	}
}

var ans = 1
for i in 0...59 {
	var counter = 0
search:
	for j in 0..<(1 << n) {
		if rOff[i] & j != 0 {
			continue search
		}
		for r in rOn[i] {
			if j & r == 0 {
				continue search
			}
		}
		counter += 1
	}
	ans = (ans * counter) % 1000000007
}

print(ans)
