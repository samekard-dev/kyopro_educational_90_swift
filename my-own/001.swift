func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nl = readIntArray()
let n = nl[0]
let l = nl[1]
let k = readInt()
let a = readIntArray()
let a2 = a + [l]
func check(p: Int) -> Int { //p: piece
	//何個獲れるか
	//最後のハンパは隣にくっつけるとする
	var counter = 0
	var base = 0
	for pos in a2 {
		if pos - base >= p {
			counter += 1
			base = pos
		}
	}
	return counter
}
var short = 1
var long = l
/*
 二分探索で
 short : k + 1獲れる(越えているかもしれない)
 long : k + 1に足りない
 としながら
 short + 1 = longの場所を探す
 */
while short + 1 < long {
	let mid = (short + long) / 2 
	let result = check(p: mid)
	if result >= k + 1 {
		short = mid
	} else {
		long = mid
	}
}

print(short)
