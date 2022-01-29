func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let abc = readIntArray()
let a = abc[0]
let b = abc[1]
let c = abc[2]

//最大公約数を求める
func getGCD(_ a: Int, _ b: Int) -> Int {
	let remain = a % b
	if remain == 0 {
		return b
	} else {
		return getGCD(b, remain)
	}
}

let gcdAB = getGCD(max(a, b), min(a, b))
let gcdABC = getGCD(max(gcdAB, c), min(gcdAB, c))

//各方向に切り込みを入れる
let answer =
	a / gcdABC - 1
	+ b / gcdABC - 1
	+ c / gcdABC - 1

print(answer)
